import SwiftUI
import Utilities
import StationFinderDomain

@MainActor
@Observable
public final class NearestStationListViewModel {
    private(set) var nearestStations: [StationModel] = []
    
    private let getNearestStations: GetNearestStations
    private let getUserLocation: GetUserLocation
    private let showRoute: ShowRoute
    
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation,
                showRoute: ShowRoute) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
        self.showRoute = showRoute
    }
    
    func onViewTask() async throws {
        try await self.fetchNearestStations()
    }
    
    func onRefresh() async throws {
        try await self.fetchNearestStations()
    }
    
    func onCardPress(_ station: StationModel) {
        Task {
            do {
                let userLocation = try await self.getUserLocation.execute()
                try await self.showRoute.execute(
                    from: Location(
                        latitude: userLocation.latitude,
                        longitude: userLocation.longitude
                    ),
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
    
    private func fetchNearestStations() async throws {
        let userLocation = try await self.getUserLocation.execute()
        let stations = try await self.getNearestStations.execute(
            longitude: userLocation.longitude,
            latitude: userLocation.latitude
        )
        self.nearestStations = stations.map { station in
            StationModel(
                id: station.id,
                name: station.name,
                city: station.address,
                availablePlaces: station.availablePlaces,
                availableMechanicalBikes: station.availableMechanicalBikes,
                availableEBikes: station.availableEBikes,
                distance: getDistanceStr(
                    userLatitude: userLocation.latitude,
                    userLongitude: userLocation.longitude,
                    stationLatitude: station.latitude,
                    stationLongitude: station.longitude
                ),
                longitude: station.longitude,
                latitude: station.latitude
            )
        }
    }
    
    private func getDistanceStr(userLatitude: Double,
                                userLongitude: Double,
                                stationLatitude: Double,
                                stationLongitude: Double) -> String {
        let distance = DistanceCalculator.calculateDistance(
            startLatitude: userLatitude,
            startLongitude: userLongitude,
            destinationLatitude: stationLatitude,
            destinationLongitude: stationLongitude
        )
        if distance < 1000 {
            return "\(distance) m"
        } else {
            let kilometers = Double(distance) / 1000.0
            return String(format: "%.1f km", kilometers)
        }
    }
}
