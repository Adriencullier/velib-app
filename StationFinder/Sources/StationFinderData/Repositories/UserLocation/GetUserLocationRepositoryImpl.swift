import StationFinderDomain
import DependencyInjection

public actor GetUserLocationRepositoryImpl: GetUserLocationRepository, HasDependencies {
    private weak var userLocationDataSource: UserLocationDataSource?
    
    public init() {}
    
    public func getUserLocation() async throws -> Location {
        guard let userLocationDataSource = userLocationDataSource else {
            throw GetUserLocationRepositoryError.userLocationDataSourceNotSet
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
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let userLocationDataSource = dependencies.first(where: { $0 is UserLocationDataSource }) as? UserLocationDataSource
        Task {
            await self.setDependencies(userLocationDataSource)
        }
    }
    
    private func setDependencies(_ userLocationDataSource: UserLocationDataSource?) {
        self.userLocationDataSource = userLocationDataSource
    }
}
