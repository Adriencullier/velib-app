import StationFinderDomain
import DependencyInjection

public actor GetUserLocationRepositoryImpl: GetUserLocationRepository, HasDependencies {
    private weak var userLocationDataSource: UserLocationDataSource?
    private var continuation: AsyncStream<Location?>.Continuation?
    
    public init() {}
    
    public func getUserLocation() async -> Location? {
        guard let userLocationDataSource = userLocationDataSource else {
            fatalError("UserLocationDataSource is not set. Call setDependencies before using this method.")
        }
        guard let userLocation = await userLocationDataSource.fetchUserLocation() else {
            return nil
        }
        return Location(
            latitude: userLocation.latitude,
            longitude: userLocation.longitude
        )
    }
    
    public func setDependencies(_ userLocationDataSource: UserLocationDataSource) {
        self.userLocationDataSource = userLocationDataSource
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.userLocationDataSource = dependencies.first(where: { $0 is UserLocationDataSource }) as? UserLocationDataSource
    }
}
