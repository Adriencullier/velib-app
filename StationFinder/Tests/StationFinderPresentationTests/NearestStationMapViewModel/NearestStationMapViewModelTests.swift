import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

struct NearestStationMapViewModelTests {
    let mockGetNearestStations = MockGetNearestStations()
    let mockGetUserLocation = MockGetUserLocation()
    let mockGetCity = MockGetCity()
    let mockShowRoute = MockShowRoute()
    
    // MARK: - Initial map position
    @Test("After view task, if the userlocation is available, map position should be userlocation")
    func userLocationPositionIfAvailable() async throws {
        // Given
        let expectedUserLocation = Location(latitude: 48.8584, longitude: 2.2945)
        let expectedCLLoc = CLLocationCoordinate2D(
            latitude: expectedUserLocation.latitude,
            longitude: expectedUserLocation.longitude
        )
        await mockGetUserLocation.setExpectedUserLocation(expectedUserLocation)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        // Then
        await MainActor.run {
            #expect(
                expectedCLLoc == sut.position.camera?.centerCoordinate
            )
        }
    }
    
    @Test("After view task, if the userlocation is not available, map position should be default city center location")
    func afterViewTaskDefaultCityIfUserLocNotAvailable() async throws {
        // Given
        let expectedLocation = CLLocationCoordinate2D(
            latitude: City.defaultCity.centerLocation.latitude,
            longitude: City.defaultCity.centerLocation.longitude
        )
        await mockGetUserLocation.setExpectedUserLocation(nil)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        // Then
        await MainActor.run {
            #expect(
                expectedLocation == sut.position.camera?.centerCoordinate
            )
        }
    }
    
    // MARK: - ShouldPresentFetchButton
    @Test("After view task, ShouldPresentFetchButton should be false")
    func shouldPresentFetchButtonIsFalseAfterViewTask() async throws {
        // Given
        await mockGetUserLocation.setExpectedUserLocation(nil)
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        // Then
        await MainActor.run {
            #expect(
                !sut.shouldPresentFetchButton
            )
        }
    }
    
    @Test("On position change, if the distance with the new position is lower or equal than 1000, ShouldPresentFetchButton should be false")
    func onPositionChangeShouldPresentFetchButtonIsFalse() async throws {
        // Given
        let userLocation = CLLocationCoordinate2D(
            latitude: 48.8584,
            longitude: 2.2945
        )
        let longitudeDeltaFor1000m = 0.0135
        let newPosition = CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude + longitudeDeltaFor1000m
        )
        await mockGetUserLocation.setExpectedUserLocation(
            Location(
                latitude: userLocation.latitude,
                longitude: userLocation.longitude
            )
        )
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        await sut.onPositionChange(newPosition)
        // Then
        await MainActor.run {
            #expect(
                !sut.shouldPresentFetchButton
            )
        }
    }
    
    @Test("On position change, if the distance with the new position is greater than 1000, ShouldPresentFetchButton should be true")
    func onPositionChangeShouldPresentFetchButtonIsTrue() async throws {
        // Given
        let userLocation = CLLocationCoordinate2D(
            latitude: 48.8584,
            longitude: 2.2945
        )
        let longitudeDeltaFor1001m = 0.0142
        let newPosition = CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude + longitudeDeltaFor1001m
        )
        await mockGetUserLocation.setExpectedUserLocation(
            Location(
                latitude: userLocation.latitude,
                longitude: userLocation.longitude
            )
        )
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        await sut.onPositionChange(newPosition)
        // Then
        await MainActor.run {
            #expect(
                sut.shouldPresentFetchButton
            )
        }
    }
    
    @Test("On refresh, ShouldPresentFetchButton should be false")
    func onFetchButtonPressedShouldPresentFetchButtonIsFalse() async throws {
        // Given
        let userLocation = CLLocationCoordinate2D(
            latitude: 48.8584,
            longitude: 2.2945
        )
        let longitudeDeltaFor1001m = 0.0142
        let newPosition = CLLocationCoordinate2D(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude + longitudeDeltaFor1001m
        )
        await mockGetUserLocation.setExpectedUserLocation(
            Location(
                latitude: userLocation.latitude,
                longitude: userLocation.longitude
            )
        )
        let sut = await NearestStationMapViewModel(
            getNearestStations: mockGetNearestStations,
            getUserLocation: mockGetUserLocation,
            getCity: mockGetCity,
            showRoute: mockShowRoute
        )
        // When
        await sut.onTask()
        await sut.onPositionChange(newPosition)
        await sut.onRefresh()
        // Then
        await MainActor.run {
            #expect(
                !sut.shouldPresentFetchButton
            )
        }
    }
    
    // MARK: - Velo name
    @Test(
        "After view task, velo name should be set, according to GetCity return",
        arguments: City.allCases
    )
    func veloNameAfterViewTask(city: City) async throws {
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
        // Then
        await MainActor.run {
            #expect(
                sut.veloName == city.veloName
            )
        }
    }
    
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
}

