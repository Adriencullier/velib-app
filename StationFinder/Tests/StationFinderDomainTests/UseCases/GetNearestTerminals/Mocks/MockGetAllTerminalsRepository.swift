import Foundation

struct MockGetAllStationsRepository: GetAllStationsRepository {
    var stations: [Station] = []
    var shouldThrowError: Bool = false
    
    func getAllStations() async throws -> [Station] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1,)
        }
        return self.stations
    }
}
