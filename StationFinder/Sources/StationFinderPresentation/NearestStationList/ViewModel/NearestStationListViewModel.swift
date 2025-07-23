import SwiftUI
import StationFinderDomain

@MainActor
@Observable
public final class NearestStationListViewModel {
    private(set) var nearestStations: [StationModel] = []
    
    private let getNearestStations: GetNearestStations
    private let getUserLocation: GetUserLocation
    
    private let userLongitude: Double = 2.2965630438180575
    private let userLatitude: Double = 48.9626867371301
    
    public init(getNearestStations: GetNearestStations,
                getUserLocation: GetUserLocation) {
        self.getNearestStations = getNearestStations
        self.getUserLocation = getUserLocation
    }
    
    func onViewTask() async throws {
        try await self.fetchNearestStations()
    }
    
    func onRefresh() async throws {
        try await self.fetchNearestStations()
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
                availableBikes: station.availableBikes,
                distance: calculateDistance(
                    userLatitude: self.userLatitude,
                    userLongitude: self.userLongitude,
                    stationLatitude: station.latitude,
                    stationLongitude: station.longitude
                )
            )
        }
    }
    
    private func calculateDistance(
        userLatitude: Double,
        userLongitude: Double,
        stationLatitude: Double,
        stationLongitude: Double
    ) -> String {
        let earthRadius = 6371000.0 // Earth radius in meters
        
        let lat1 = userLatitude * .pi / 180
        let lat2 = stationLatitude * .pi / 180
        let deltaLat = (stationLatitude - userLatitude) * .pi / 180
        let deltaLon = (stationLongitude - userLongitude) * .pi / 180
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) +
        cos(lat1) * cos(lat2) *
        sin(deltaLon/2) * sin(deltaLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = Int(earthRadius * c)
        if distance < 1000 {
            return "\(distance) m"
        } else {
            let kilometers = Double(distance) / 1000.0
            return String(format: "%.1f km", kilometers)
        }
    }
}
