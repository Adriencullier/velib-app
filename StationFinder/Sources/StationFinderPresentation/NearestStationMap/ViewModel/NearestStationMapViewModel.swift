import SwiftUI
import MapKit
import StationFinderDomain

@Observable
@MainActor
public final class NearestStationMapViewModel {
    private unowned let getNearestStations: GetNearestStations
    private unowned let getUserLocation: GetUserLocation
    private unowned let showRoute: ShowRoute

    private var debounceTask: Task<Void, Never>? = nil
    
    var stations: [MapStationModel] = [
        MapStationModel(
            id: "1",
            name: "Nom de la station",
            availablePlaces: 0,
            availableMechanicalBikes: 7,
            availableEBikes: 3,
            longitude: 2.333333,
            latitude: 48.866667
        )
    ]

    var position: MapCameraPosition = .userLocation(
        fallback: .camera(
            .init(
                centerCoordinate: .init(
                    latitude: 48.866667,
                    longitude: 2.333333
                ),
                distance: 1000
            )
        )
    )
    
    var bounds: MapCameraBounds {
        return .init(
            centerCoordinateBounds: self.parisRegion,
            minimumDistance: self.minimumDistance,
            maximumDistance: self.maximumDistance
        )
    }
    
    private let parisRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.866667,
            longitude: 2.333333
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.3,
            longitudeDelta: 0.3
        )
    )
    
    private let minimumDistance: CLLocationDistance = 500
    private let maximumDistance: CLLocationDistance = 10000
    
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation,
                showRoute: ShowRoute) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
        self.showRoute = showRoute
    }
    
    func onPositionChange(_ coordinates: CLLocationCoordinate2D) {
        print("Position changed to: \(coordinates.latitude), \(coordinates.longitude)")
        self.debounceTask?.cancel()
        self.debounceTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
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
}
