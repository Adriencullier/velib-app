import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

extension NearestStationMapViewModelTests {
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
}
