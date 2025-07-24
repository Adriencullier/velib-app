import Foundation
import Utilities
import StationFinderDomain

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
