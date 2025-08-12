import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

extension NearestStationMapViewModelTests {
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
}
