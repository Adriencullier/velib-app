import StationFinderDomain

public actor GetUserLocationRepositoryImpl: GetUserLocationRepository {
    private weak var userLocationDataSource: UserLocationDataSource?
    
    public init() {}
    
    public func getUserLocation() async throws -> UserLocation {
        guard let userLocationDataSource = userLocationDataSource else {
            throw GetUserLocationRepositoryError.userLocationDataSourceNotSet
        }
        guard let userLocationDTO = try await userLocationDataSource.fetchUserLocation() else {
            throw GetUserLocationRepositoryError.userLocationNotAvailable
        }
        return UserLocation(
            latitude: userLocationDTO.latitude,
            longitude: userLocationDTO.longitude
        )
    }
    
    public func setDependencies(_ userLocationDataSource: UserLocationDataSource) {
        self.userLocationDataSource = userLocationDataSource
    }
}
