public protocol GetUserLocationRepository: Actor {
    func getUserLocation() async throws -> Location
}
