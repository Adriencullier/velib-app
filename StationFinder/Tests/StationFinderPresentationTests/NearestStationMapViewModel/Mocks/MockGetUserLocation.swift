import StationFinderDomain

// MARK: - Mock Classes
actor MockGetUserLocation: GetUserLocation {
    private var expectedUserLocation: Location?
    
    func setExpectedUserLocation(_ location: Location?) {
        self.expectedUserLocation = location
    }
    
    func execute() async -> Location? {
        return self.expectedUserLocation
    }
}
