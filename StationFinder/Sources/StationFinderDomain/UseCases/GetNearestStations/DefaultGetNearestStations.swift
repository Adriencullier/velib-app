import Foundation
import DependencyInjection
import Utilities

public actor DefaultGetNearestStations: GetNearestStations, HasDependencies {
    weak var getAllStationsRepository: GetAllStationsRepository?
    
    public init() {}
    
    public func execute(longitude: Double, latitude: Double) async throws -> [Station] {
        let allStations = try await getAllStationsRepository?.getAllStations() ?? []
        let sortedStations = self.sortStations(
            allStations,
            lat: latitude,
            long: longitude
        )
        return Array(sortedStations.prefix(5))
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.getAllStationsRepository = dependencies.first(where: { $0 is GetAllStationsRepository }) as? GetAllStationsRepository
    }
    
    private func sortStations(_ stations: [Station],
                              lat: Double,
                              long: Double) -> [Station] {
        let stationDistances = stations.map { station -> (Station, Int) in
            let distance = DistanceCalculator.calculateDistance(
                startLatitude: station.latitude,
                startLongitude: station.longitude,
                destinationLatitude: lat,
                destinationLongitude: long
            )
            return (station, distance)
        }
        let nearestStations = stationDistances
            .sorted { $0.1 < $1.1 }
            .map { $0.0 }
        return nearestStations
    }
}
