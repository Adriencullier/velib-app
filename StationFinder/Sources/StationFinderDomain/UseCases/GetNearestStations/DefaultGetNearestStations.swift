import Foundation

public struct DefaultGetNearestStations: GetNearestStations {
    private let getAllStationsRepository: GetAllStationsRepository
    
    public init(getAllStationsRepository: GetAllStationsRepository) {
        self.getAllStationsRepository = getAllStationsRepository
    }
    
    public func execute(longitude: Double, latitude: Double) async throws -> [Station] {
        let allStations = try await getAllStationsRepository.getAllStations()
        let sortedStations = self.sortStations(
            allStations,
            lat: latitude,
            long: longitude
        )
        return Array(sortedStations.prefix(5))
    }
    
    private func sortStations(_ stations: [Station],
                              lat: Double,
                              long: Double) -> [Station] {
        let stationDistances = stations.map { station -> (Station, Double) in
            let earthRadius = 6371000.0 // Earth radius in meters
            
            let lat1 = lat * .pi / 180
            let lat2 = station.latitude * .pi / 180
            let deltaLat = (station.latitude - lat) * .pi / 180
            let deltaLon = (station.longitude - long) * .pi / 180
            
            let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(lat1) * cos(lat2) * sin(deltaLon/2) * sin(deltaLon/2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            
            let distance = earthRadius * c
            return (station, distance)
        }
        let nearestStations = stationDistances
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        return nearestStations
    }
}
