import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

struct NearestStationMapViewModelTests {
    let mockGetNearestStations = MockGetNearestStations()
    let mockGetUserLocation = MockGetUserLocation()
    let mockGetCity = MockGetCity()
    let mockShowRoute = MockShowRoute()
    
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
    func defaultCityPositionIfUserLocationNotAvailable() async throws {
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
}

