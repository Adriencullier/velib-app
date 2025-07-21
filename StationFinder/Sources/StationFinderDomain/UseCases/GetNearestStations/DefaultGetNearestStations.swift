public final class DefaultGetNearestStations: GetNearestStations {
    weak var getAllStationsRepository: GetAllStationsRepository?
    
    public init() {}
    
    public func execute(longitude: Double, latitude: Double) async throws -> [Station] {
        guard let repository = self.getAllStationsRepository else {
            fatalError("GetAllStationsRepository is not set")
        }
        let allStations = try await repository.getAllStations()
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
            let latDiff = station.latitude - lat
            let longDiff = station.longitude - long
            let distance = (latDiff * latDiff) + (longDiff * longDiff)
            return (station, distance)
        }
        let nearestStations = stationDistances
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        return nearestStations
    }
}
