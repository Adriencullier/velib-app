public struct DefaultGetUserLocation: GetUserLocation {
    private let getUserLocationRepository: GetUserLocationRepository
    
    public init(getUserLocationRepository: GetUserLocationRepository) {
        self.getUserLocationRepository = getUserLocationRepository
    }
    
    public func execute() async throws -> UserLocation {
        return try await self.getUserLocationRepository.getUserLocation()
    }
}
