import StationFinderDomain

public struct DefaultGetUserLocation: GetUserLocation {
    private let getUserLocationRepository: GetUserLocationRepository
    
    public init(getUserLocationRepository: GetUserLocationRepository) {
        self.getUserLocationRepository = getUserLocationRepository
    }
    
    public func execute() async throws -> Location {
        return try await self.getUserLocationRepository.getUserLocation()
    }
}
