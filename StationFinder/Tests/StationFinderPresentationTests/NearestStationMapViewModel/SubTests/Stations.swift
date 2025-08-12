import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

extension NearestStationMapViewModelTests {
    // MARK: - Stations
    @Test(
        "After view task, stations should be set, according to GetCity return",
        arguments: City.allCases
    )
    func stationsAfterViewTask(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        let expectedStations = await self.mockGetNearestStations.getStationByCity(city).map({ station in
            return MapStationModel(
                id: station.id,
                name: station.name,
                availablePlaces: station.availablePlaces,
                availableMechanicalBikes: station.availableMechanicalBikes,
                availableEBikes: station.availableEBikes,
                longitude: station.longitude,
                latitude: station.latitude
            )
        })
        // Then
        await MainActor.run {
            #expect(
                sut.stations == expectedStations
            )
        }
    }
    
    @Test(
        "After refresh, stations should be set, according to GetCity return",
        arguments: City.allCases
    )
    func stationsAfterRefresh(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        for newCity in City.allCases.filter({ $0 != city }) {
            let expectedStations = await self.mockGetNearestStations.getStationByCity(newCity).map({ station in
                return MapStationModel(
                    id: station.id,
                    name: station.name,
                    availablePlaces: station.availablePlaces,
                    availableMechanicalBikes: station.availableMechanicalBikes,
                    availableEBikes: station.availableEBikes,
                    longitude: station.longitude,
                    latitude: station.latitude
                )
            })
            await mockGetCity.setCityToReturn(newCity)
            await sut.onRefresh()
            // Then
            await MainActor.run {
                #expect(
                    sut.stations == expectedStations
                )
            }
        }
    }
    
    @Test(
        "After enter foreground, stations should be set, according to GetCity return",
        arguments: City.allCases
    )
    func stationsAfterEnterForeground(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        for newCity in City.allCases.filter({ $0 != city }) {
            let expectedStations = await self.mockGetNearestStations.getStationByCity(newCity).map({ station in
                return MapStationModel(
                    id: station.id,
                    name: station.name,
                    availablePlaces: station.availablePlaces,
                    availableMechanicalBikes: station.availableMechanicalBikes,
                    availableEBikes: station.availableEBikes,
                    longitude: station.longitude,
                    latitude: station.latitude
                )
            })
            await mockGetCity.setCityToReturn(newCity)
            await sut.onEnterForeground()
            // Then
            await MainActor.run {
                #expect(
                    sut.stations == expectedStations
                )
            }
        }
    }
    
    @Test(
        "After view task, stations should be empty if empty useCase return",
        arguments: City.allCases
    )
    func emptyStationsAfterViewTask(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShouldReturnEmpty(true)
        await sut.onTask()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }
    
    @Test(
        "After refresh, stations should be empty if empty useCase return",
        arguments: City.allCases
    )
    func emptyStationsAfterRefresh(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShouldReturnEmpty(true)
        await sut.onRefresh()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }

    @Test(
        "After enterForeground, stations should be empty if empty useCase return",
        arguments: City.allCases
    )
    func emptyStationsAfterEnterForeground(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShouldReturnEmpty(true)
        await sut.onEnterForeground()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }
    
    @Test(
        "After view task, stations should be empty if empty useCase throw error",
        arguments: City.allCases
    )
    func emptyStationsAfterViewTaskIfThrow(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShoultThrow(true)
        await sut.onTask()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }
    
    @Test(
        "After refresh, stations should be empty if empty useCase throw",
        arguments: City.allCases
    )
    func emptyStationsAfterRefreshIfThrow(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShoultThrow(true)
        await sut.onRefresh()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }
    
    @Test(
        "After enter foreground, stations should be empty if empty useCase throw",
        arguments: City.allCases
    )
    func emptyStationsAfterEnterForegroundIfThrow(city: City) async throws {
        // Given
        await mockGetCity.setCityToReturn(city)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await mockGetNearestStations.setShoultThrow(true)
        await sut.onEnterForeground()
        // Then
        await MainActor.run {
            #expect(
                sut.stations.isEmpty
            )
        }
    }
}
