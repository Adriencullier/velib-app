import SwiftUI
import MapKit
import Utilities
import StationFinderDomain

@Observable
@MainActor
public final class NearestStationMapViewModel {
    private unowned let getNearestStations: GetNearestStations
    private unowned let getUserLocation: GetUserLocation
    private unowned let getCity: GetCity
    private unowned let showRoute: ShowRoute

    var position: MapCameraPosition = .userLocation(
        fallback: .camera(
            .init(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: City.defaultCity.centerLocation.latitude,
                    longitude: City.defaultCity.centerLocation.longitude
                ),
                distance: 3000
            )
        )
    )
     
    var shouldPresentFetchButton: Bool = false
    
    private(set) var stations: [MapStationModel] = []
    private(set) var veloName: String = "Vélos"
    
    private var fetchStationsTask: Task<Void, Never>? = nil
    
    private var currentLocation: CLLocationCoordinate2D? = nil
    private var lastLocationRefresh: CLLocationCoordinate2D? = nil
    private var city: City = .defaultCity
    private var userLocation: Location? = nil
            
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation,
                getCity: GetCity,
                showRoute: ShowRoute) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
        self.getCity = getCity
        self.showRoute = showRoute
        
        Task {
            await self.observeUserLocation()
        }
    }
    
    func onPositionChange(_ coordinates: CLLocationCoordinate2D) {
        Task {
            guard let _ = self.currentLocation,
                  let lastLocationRefresh = self.lastLocationRefresh else {
                return
            }
            self.currentLocation = coordinates
            if DistanceCalculator.calculateDistance(
                startLatitude: lastLocationRefresh.latitude,
                startLongitude: lastLocationRefresh.longitude,
                destinationLatitude: coordinates.latitude,
                destinationLongitude: coordinates.longitude
            ) > 1000 {
                self.shouldPresentFetchButton = true
            }
        }
    }
    
    func onEnterForeground() {
        Task {
            do {
                try await self.onRefresh()
            } catch {
                print("Failed to refresh nearest stations: \(error.localizedDescription)")
            }
        }
    }
    
    func onRoutePressed(_ station: MapStationModel) {
        Task {
            guard let userLocation = self.userLocation else {
                return
            }
            try await self.showRoute.execute(
                from: userLocation,
                to: Location(
                    latitude: station.latitude,
                    longitude: station.longitude
                )
            )
        }
    }
    
    func onRefresh() async throws {
        self.fetchNearesStations()
    }
    
    func onTask() async {
        Task {
            await self.initializeMap()
            self.fetchNearesStations()
        }
    }
    
    func onFetchButtonPressed() {
        self.fetchNearesStations()
        self.lastLocationRefresh = self.currentLocation
    }
    
    private func observeUserLocation() async {
        do {
            for await location in try await self.getUserLocation.execute() {
                self.userLocation = location
                if let userLocation = location, self.currentLocation == nil {
                    self.currentLocation = CLLocationCoordinate2D(
                        latitude: userLocation.latitude,
                        longitude: userLocation.longitude
                    )
                }
            }
        } catch {
            print("Failed to fetch user location: \(error.localizedDescription)")
        }
    }
    
    private func initializeMap() async {
        if let userLocation = self.userLocation {
            let city = await self.getCity.execute(
                userLocation: userLocation
            )
            if self.city != city {
                self.city = city
            }
            self.veloName = city.veloName
        }
    }
    
   
    private func fetchNearesStations() {
        guard let coordinates = self.currentLocation else { return }
        self.fetchStationsTask?.cancel()
        self.fetchStationsTask = Task {
            guard !Task.isCancelled else { return }
            do {
                let stations = try await self.getNearestStations.execute(
                    longitude: coordinates.longitude,
                    latitude: coordinates.latitude,
                    city: self.city
                )
                self.stations = stations.map(
                    { station in
                        MapStationModel(
                            id: station.id,
                            name: station.name,
                            availablePlaces: station.availablePlaces,
                            availableMechanicalBikes: station.availableMechanicalBikes,
                            availableEBikes: station.availableEBikes,
                            longitude: station.longitude,
                            latitude: station.latitude
                        )
                    }
                )
                self.shouldPresentFetchButton = false
                self.lastLocationRefresh = self.currentLocation
            } catch {
                self.fetchStationsTask?.cancel()
                print(error.localizedDescription)
            }
        }
    }
}
