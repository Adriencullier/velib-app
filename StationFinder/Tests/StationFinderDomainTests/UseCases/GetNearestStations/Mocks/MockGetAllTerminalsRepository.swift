import StationFinderDomain
import Foundation

actor MockGetAllStationsRepository: GetAllStationsRepository {
    private(set) var stations: [Station] = []
    var shouldThrowError: Bool = false
    
    func getAllStations() async throws -> [Station] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1,)
        }
        return self.stations
    }
    
    func setStations(_ stations: [Station]) {
        self.stations = stations
    }
    
    func shouldThrow(_ shouldThrow: Bool) {
        self.shouldThrowError = shouldThrow
    }
}
