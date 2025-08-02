public protocol GetUserLocation: Actor {
    func execute() async throws -> Location
}
