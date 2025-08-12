import Testing
import MapKit
import StationFinderDomain
@testable import StationFinderPresentation

extension NearestStationMapViewModelTests {
    @Test(
        "When user location is nil then onShowRoute should not be called"
    )
    func onShowRouteWhenNoUserLocation() async {
        // Given
        let sut = await NearestStationMapViewModel(
            getNearestStations: self.mockGetNearestStations,
            getUserLocation: self.mockGetUserLocation,
            getCity: self.mockGetCity,
            showRoute: self.mockShowRoute
        )
        let station = MapStationModel(
            id: "1",
            name: "Station 1",
            availablePlaces: 0,
            availableMechanicalBikes: 0,
            availableEBikes: 0,
            longitude: 0,
            latitude: 0
        )
        // When
        await sut.onRoutePressed(station)
        // Then
        await #expect(self.mockShowRoute.executeHasBeenCalled == false)
    }
    
    @Test(
        "When user location exists then onShowRoute should be called with staion and user loctions"
    )
    func onShowRouteWhenUserLocation() async {
        // Given
        let sut = await NearestStationMapViewModel(
            getNearestStations: self.mockGetNearestStations,
            getUserLocation: self.mockGetUserLocation,
            getCity: self.mockGetCity,
            showRoute: self.mockShowRoute
        )
        let userLocation = Location(
            latitude: 2.123,
            longitude: 4.387
        )
        await self.mockGetUserLocation.setExpectedUserLocation(userLocation)
        let station = MapStationModel(
            id: "1",
            name: "Station 1",
            availablePlaces: 0,
            availableMechanicalBikes: 0,
            availableEBikes: 0,
            longitude: 3.143,
            latitude: 21.367
        )        
        // When
        await sut.onRoutePressed(station)
        // Then
        let start = await self.mockShowRoute.startLocation
        let destination = await self.mockShowRoute.destinationLocation
        #expect(
            start == userLocation
            && destination == Location(
                latitude: station.latitude,
                longitude: station.longitude
            )
        )
    }
}
