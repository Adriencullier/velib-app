import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

extension NearestStationMapViewModelTests {
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
    func onRefreshShouldPresentFetchButtonIsFalse() async throws {
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
    
    @Test("On enter foreground, ShouldPresentFetchButton should be false")
    func onEnterForegroundShouldPresentFetchButtonIsFalse() async throws {
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
        await sut.onEnterForeground()
        // Then
        await MainActor.run {
            #expect(
                !sut.shouldPresentFetchButton
            )
        }
    }
}
