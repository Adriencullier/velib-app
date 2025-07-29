import Testing
import Foundation
import StationFinderDomain
@testable import StationFinderData

struct GetAllStationsRepositoryTests {
    private let mockDataSource = MockAllStationsDataSource()
    
    private lazy var repository: GetAllStationsRepository = {
        let repo = GetAllStationsRepositoryImpl()
        repo.allStationssDataSource = self.mockDataSource
        return repo
    }()
    
    @Test(
        "GetAllStationsRepository should return an empty array when no stations are available on AllTerminal data source"
    )
    mutating func emptyArrayWhenNoStationsFromDataSource() async throws {
        // Given
        self.mockDataSource.expectedStations = []
        // When
        let stations = try await self.repository.getAllStations()
        // Then
        #expect(stations.isEmpty)
    }
    
    @Test(
        "GetAllStationsRepository should return the list of stations gotten from AllTerminals data source"
    )
    mutating func stationsFromDataSource() async throws {
        // Given
        let stationsDTOs = [
            StationDTO(
                stationCode: 1,
                name: "Station A",
                city: "City A",
                availableDocks: 3,
                mechanical: 2,
                ebike: 5,
                coordinates: CoordinatesDTO(
                    longitude: 1.1,
                    latitude: 1.3
                )
            ),
            StationDTO(
                stationCode: 2,
                name: "Station B",
                city: "City B",
                availableDocks: 2,
                mechanical: 1,
                ebike: 8,
                coordinates: CoordinatesDTO(
                    longitude: 2.1,
                    latitude: 3.3
                )
            ),
        ]
        let expectedStations = stationsDTOs.map { StationMapper.map(from: $0) }
        self.mockDataSource.expectedStations = stationsDTOs
        // When
        let stations = try await self.repository.getAllStations()
        // Then
        #expect(stations == expectedStations)
    }
    
    @Test(
        "GetAllStationsRepository should thow the error thrown by AllTerminals data source"
    )
    mutating func errorThrownByDataSource() async throws {
        // Given
        self.mockDataSource.shouldThrowError = NSError(domain: "MockError", code: 1)
        // When Then
        await #expect(throws: NSError.self, performing: {
            let _ = try await self.repository.getAllStations()
        })
    }
}
