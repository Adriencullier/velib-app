public protocol GetNearestStations: Actor {
    func execute(longitude: Double, latitude: Double) async throws -> [Station]
}
