@testable import StationFinderData
import Foundation
import StationFinderDomain

final class MockAllStationsDataSource: AllStationsDataSource {
    var expectedStations: [StationDTO] = []
    var shouldThrowError: NSError?
    
    func fetchAllStations() async throws -> [StationDTO] {
        if let error = self.shouldThrowError{
            throw error
        }
        return self.expectedStations
    }
}
