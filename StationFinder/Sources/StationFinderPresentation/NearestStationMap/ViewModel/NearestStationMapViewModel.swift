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
    
    var position: MapCameraPosition = .camera(
        .init(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: City.defaultCity.centerLocation.latitude,
                longitude: City.defaultCity.centerLocation.longitude
            ),
            distance: 3000
        )
    )
    
    private(set) var shouldPresentFetchButton: Bool = false
    private(set) var stations: [MapStationModel] = []
        
    private var fetchStationsTask: Task<Void, Never>? = nil
    private var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(
        latitude: City.defaultCity.centerLocation.latitude,
        longitude: City.defaultCity.centerLocation.longitude
    )
    private var lastLocationRefresh: CLLocationCoordinate2D? = nil
    private var city: City = .defaultCity
    
    var veloName: String {
        self.city.veloName
    }
            
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation,
                getCity: GetCity,
                showRoute: ShowRoute) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
        self.getCity = getCity
        self.showRoute = showRoute
    }
    
    func onPositionChange(_ coordinates: CLLocationCoordinate2D) {
        self.currentLocation = coordinates
        guard let lastLocationRefresh = self.lastLocationRefresh else {
            return
        }
        if DistanceCalculator.calculateDistance(
            startLatitude: lastLocationRefresh.latitude,
            startLongitude: lastLocationRefresh.longitude,
            destinationLatitude: coordinates.latitude,
            destinationLongitude: coordinates.longitude
        ) > 1000 {
            self.shouldPresentFetchButton = true
        }
    }
    
    func onEnterForeground() {
        Task {
            await self.onRefresh()
        }
    }
    
    func onRoutePressed(_ station: MapStationModel) {
        Task {
            guard let userLocation = await self.getUserLocation.execute() else {
                print("No user location, can't show route")
                return
            }
            do {
                try await self.showRoute.execute(
                    from: userLocation,
                    to: Location(
                        latitude: station.latitude,
                        longitude: station.longitude
                    )
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onRefresh() async {
        await self.initializeMap()
        self.fetchNearesStations()
    }
    
    func onTask() async {
        await self.setUserLocation()
        self.currentLocation = self.position.camera?.centerCoordinate ?? CLLocationCoordinate2D(
            latitude: self.city.centerLocation.latitude,
            longitude: self.city.centerLocation.longitude
        )
        await self.onRefresh()
    }
    
    func onFetchButtonPressed() {
        Task {
            await self.onRefresh()
            self.lastLocationRefresh = self.currentLocation
        }
    }
    
    private func setUserLocation() async {
        guard let userLoc = await self.getUserLocation.execute() else {
            return
        }
        self.position = .camera(
            .init(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: userLoc.latitude,
                    longitude: userLoc.longitude
                ),
                distance: 3000
            )
        )
    }
    
    private func initializeMap() async {
        let city = await self.getCity.execute(
            userLocation: Location(
                latitude: self.currentLocation.latitude,
                longitude: self.currentLocation.longitude
            )
        )
        self.city = city
        self.fetchNearesStations()
    }
    
   
    private func fetchNearesStations() {
        self.fetchStationsTask?.cancel()
        self.fetchStationsTask = Task {
            guard !Task.isCancelled else { return }
            do {
                let stations = try await self.getNearestStations.execute(
                    longitude: self.currentLocation.longitude,
                    latitude: self.currentLocation.latitude,
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

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
        && lhs.longitude == rhs.longitude
    }
}
