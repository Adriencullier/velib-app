public protocol GetNearestStations: Actor {
    func execute(longitude: Double,
                 latitude: Double,
                 city: City) async throws -> [Station]
}
