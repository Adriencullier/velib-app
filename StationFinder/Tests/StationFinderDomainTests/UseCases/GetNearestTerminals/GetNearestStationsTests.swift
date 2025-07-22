import Testing
@testable import StationFinderDomain

struct GetNearestStationsTests {
    @Test(
        "When the repository returns an empty list, the use case should return an empty list of stations"
    )
    func executeReturnEmptyStations() async throws {
        // Given
        var repository = MockGetAllStationsRepository()
        repository.stations = []
        let useCase = DefaultGetNearestStations(getAllStationsRepository: repository)
        // When
        let stations = try await useCase.execute(longitude: 1.1, latitude: 1.2)
        // Then
        #expect(stations.isEmpty)
    }
    
    @Test(
        "When the repository returns a list of stations, the use case should not return more than 5 stations",
        arguments: (1...7)
    )
    func executeReturnStations(numberOfStations: Int) async throws {
        // Given
        var repository = MockGetAllStationsRepository()
        let expectedStations = Array(
            repeating: Station(
                id: 1,
                name: "1st Station",
                address: "123 Main St",
                availablePlaces: 0,
                availableBikes: 3,
                longitude: 1.0,
                latitude: 1.2
            ),
            count: numberOfStations
        )
        repository.stations = expectedStations
        let useCase = DefaultGetNearestStations(getAllStationsRepository: repository)
        // When
        let stations = try await useCase.execute(longitude: 1.1, latitude: 1.2)
        // Then
        if numberOfStations > 5 {
            #expect(stations.count == 5)
        } else {
            #expect(stations.count == numberOfStations)
        }
    }
    
    @Test(
        "When the repository throws an error, the use case should throw that error"
    )
    func executeThrowError() async throws {
        // Given
        var repository = MockGetAllStationsRepository()
        repository.shouldThrowError = true
        let useCase = DefaultGetNearestStations(getAllStationsRepository: repository)
        // When
        // Then
        await #expect(throws: Error.self, performing: {
            let _ = try await useCase.execute(longitude: 1.1, latitude: 1.2)
        })
    }
    
    @Test(
        "When the repository returns a list of stations, the use case should return the five nearest stations from my location. And the result needs to be sorted by shortest distance from give location"
    )
    func executeReturnsFiveNearestStations() async throws {
        // Given
        let stations = [
            Station(
                id: 1,
                name: "Saint-Denis Terminal",
                address: "12 Avenue de Paris",
                availablePlaces: 4,
                availableBikes: 2,
                longitude: 2.295734,
                latitude: 48.963421
            ),
            Station(
                id: 3,
                name: "Asnières Terminal",
                address: "8 Boulevard Victor Hugo",
                availablePlaces: 3,
                availableBikes: 3,
                longitude: 2.293418,
                latitude: 48.960129
            ),
            Station(
                id: 6,
                name: "Villeneuve Terminal",
                address: "72 Avenue Jean Jaurès",
                availablePlaces: 6,
                availableBikes: 1,
                longitude: 2.304128,
                latitude: 48.958921
            ),
            Station(
                id: 4,
                name: "Argenteuil Terminal",
                address: "23 Quai de Seine",
                availablePlaces: 0,
                availableBikes: 7,
                longitude: 2.299856,
                latitude: 48.965204
            ),
            Station(
                id: 5,
                name: "Colombes Terminal",
                address: "16 Rue des Entrepreneurs",
                availablePlaces: 1,
                availableBikes: 4,
                longitude: 2.290187,
                latitude: 48.967354
            ),
            Station(
                id: 2,
                name: "Gennevilliers Terminal",
                address: "45 Rue du Port",
                availablePlaces: 2,
                availableBikes: 5,
                longitude: 2.298012,
                latitude: 48.961543
            )
        ]
        let expectedResult = [
            stations[0], // Saint-Denis Terminal (closest)
            stations[5], // Gennevilliers Terminal (2nd closest)
            stations[3], // Argenteuil Terminal (4th closest)
            stations[1], // Asnières Terminal (3rd closest)
            stations[4]  // Colombes Terminal (5th closest)
        ]
        var repository = MockGetAllStationsRepository()
        repository.stations = stations
        let useCase = DefaultGetNearestStations(getAllStationsRepository: repository)
        // When
        let result = try await useCase.execute(longitude: 2.296634, latitude: 48.962786)
        // Then
        #expect(result == expectedResult)
    }
}
