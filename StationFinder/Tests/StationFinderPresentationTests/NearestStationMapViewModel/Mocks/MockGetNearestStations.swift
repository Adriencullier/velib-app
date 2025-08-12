import Foundation
import StationFinderDomain

actor MockGetNearestStations: GetNearestStations {
    private(set) var shouldReturnEmpty: Bool = false
    private(set) var shouldThrowError: Bool = false
    
    func execute(longitude: Double, latitude: Double, city: City) async throws -> [StationFinderDomain.Station] {
        if self.shouldThrowError {
            throw NSError(domain: "Error", code: 1)
        }
        if shouldReturnEmpty {
            return []
        }        
        return getStationByCity(city)
    }
    
    func setShouldReturnEmpty(_ shouldReturnEmpty: Bool) {
        self.shouldReturnEmpty = shouldReturnEmpty
    }
    
    func setShoultThrow(_ shouldThrow: Bool) {
        self.shouldThrowError = shouldThrow
    }
    
    func getStationByCity(_ city: City) -> [Station] {
        switch city {
        case .paris:
            return [
                Station(
                    id: "1",
                    name: "Station 1",
                    address: "Adresse de la station 1",
                    availablePlaces: 3,
                    availableMechanicalBikes: 1,
                    availableEBikes: 4,
                    longitude: 3.1,
                    latitude: 3.1
                ),
                Station(
                    id: "2",
                    name: "Station 2",
                    address: "Adresse de la station 2",
                    availablePlaces: 3,
                    availableMechanicalBikes: 1,
                    availableEBikes: 4,
                    longitude: 3.2,
                    latitude: 3.2
                )
            ]
        case .lille:
            return [
                Station(
                    id: "3",
                    name: "Station 3",
                    address: "Adresse de la station 3",
                    availablePlaces: 3,
                    availableMechanicalBikes: 1,
                    availableEBikes: 4,
                    longitude: 3.3,
                    latitude: 3.3
                ),
                Station(
                    id: "4",
                    name: "Station 4",
                    address: "Adresse de la station 4",
                    availablePlaces: 3,
                    availableMechanicalBikes: 1,
                    availableEBikes: 4,
                    longitude: 3.4,
                    latitude: 3.4
                )
            ]
        }
    }
}
