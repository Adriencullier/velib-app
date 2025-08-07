import SwiftUI
import MapKit
import StationFinderDomain

@Observable
@MainActor
public final class NearestStationMapViewModel {
    private unowned let getNearestStations: GetNearestStations
    private unowned let getUserLocation: GetUserLocation
    private unowned let getCity: GetCity
    private unowned let showRoute: ShowRoute

    var position: MapCameraPosition = .camera(.init(.init()))
    
    private(set) var stations: [MapStationModel] = []
    private(set) var bounds: MapCameraBounds?
    private(set) var veloName: String = "Vélos"
    
    private var fetchStationsTask: Task<Void, Never>? = nil
    private var currentLocation: CLLocationCoordinate2D? = nil
    
    private let minimumDistance: CLLocationDistance = 500
        
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation,
                getCity: GetCity,
                showRoute: ShowRoute) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
        self.getCity = getCity
        self.showRoute = showRoute
        
        Task {
            let initialUserLocation = try? await self.getUserLocation.execute()
            let city = await self.getCity.execute(userLocation: initialUserLocation)

            self.veloName = city.veloName
            self.setInitialPosition(for: initialUserLocation, city: city)
            self.setBounds(city: city)
        }
    }
    
    func onPositionChange(_ coordinates: CLLocationCoordinate2D) {
        self.currentLocation = coordinates
        self.fetchNearesStations()
    }
    
    private func setInitialPosition(for userLocation: Location?, city: City) {
        if let userLocation = userLocation {
            self.position = .camera(
                MapCamera(
                    centerCoordinate: .init(
                        latitude: userLocation.latitude,
                        longitude: userLocation.longitude
                    ),
                    distance: 3000
                )
            )
        } else {
            self.position = .camera(
                MapCamera(
                    centerCoordinate: .init(
                        latitude: city.centerLocation.latitude,
                        longitude: city.centerLocation.longitude
                    ),
                    distance: 3000
                )
            )
        }
    }
    
    private func setBounds(city: City) {
        self.bounds = MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: city.centerLocation.latitude,
                    longitude: city.centerLocation.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.3,
                    longitudeDelta: 0.3
                )
            ),
            minimumDistance: self.minimumDistance,
            maximumDistance: Double(city.radius)
        )
    }
    
    private func fetchNearesStations() {
        guard let coordinates = self.currentLocation else { return }
        self.fetchStationsTask?.cancel()
        self.fetchStationsTask = Task {
            guard !Task.isCancelled else { return }
            do {
                let stations = try await self.getNearestStations.execute(longitude: coordinates.longitude, latitude: coordinates.latitude)
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
                    })
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func onRoutePressed(_ station: MapStationModel) {
        Task {
            guard let userLocation = try? await self.getUserLocation.execute() else {
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
}
