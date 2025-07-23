public protocol GetUserLocation: Sendable {
    func execute() async throws -> UserLocation
}
