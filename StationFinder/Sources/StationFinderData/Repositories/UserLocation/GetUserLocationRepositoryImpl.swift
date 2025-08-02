import StationFinderDomain
import DependencyInjection

public actor GetUserLocationRepositoryImpl: GetUserLocationRepository, HasDependencies {
    private weak var userLocationDataSource: UserLocationDataSource?
    
    public init() {}
    
    public func getUserLocation() async throws -> Location {
        guard let userLocationDataSource = userLocationDataSource else {
            fatalError("UserLocationDataSource is not set. Call setDependencies before using this method.")
        }
        guard let userLocationDTO = try await userLocationDataSource.fetchUserLocation() else {
            throw GetUserLocationRepositoryError.userLocationNotAvailable
        }
        return Location(
            latitude: userLocationDTO.latitude,
            longitude: userLocationDTO.longitude
        )
    }
    
    public func setDependencies(_ userLocationDataSource: UserLocationDataSource) {
        self.userLocationDataSource = userLocationDataSource
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.userLocationDataSource = dependencies.first(where: { $0 is UserLocationDataSource }) as? UserLocationDataSource
    }
}
