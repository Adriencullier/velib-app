public protocol GetUserLocationRepository: Sendable {
    func getUserLocation() async throws -> UserLocation
}
