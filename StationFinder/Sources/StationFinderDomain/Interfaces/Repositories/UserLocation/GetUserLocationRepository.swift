public protocol GetUserLocationRepository: Actor {
    func getUserLocation() throws -> AsyncStream<Location?>
}
