import StationFinderDomain
import DependencyInjection

public actor GetUserLocationRepositoryImpl: GetUserLocationRepository, HasDependencies {
    private weak var userLocationDataSource: UserLocationDataSource?
    private var continuation: AsyncStream<Location?>.Continuation?
    
    public init() {}
    
    public func getUserLocation() throws -> AsyncStream<Location?> {
        guard let userLocationDataSource = userLocationDataSource else {
            fatalError("UserLocationDataSource is not set. Call setDependencies before using this method.")
        }
        let asyncStream = AsyncStream<Location?> { continuation in
            self.continuation = continuation
        }
        Task {
            for await locDTO in try await userLocationDataSource.fetchUserLocation() {
                if let locDTO = locDTO {
                    let location = Location(
                        latitude: locDTO.latitude,
                        longitude: locDTO.longitude
                    )
                    self.continuation?.yield(location)
                } else {
                    self.continuation?.yield(nil)
                }
            }
        }
        return asyncStream
    }
    
    public func setDependencies(_ userLocationDataSource: UserLocationDataSource) {
        self.userLocationDataSource = userLocationDataSource
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.userLocationDataSource = dependencies.first(where: { $0 is UserLocationDataSource }) as? UserLocationDataSource
    }
}
