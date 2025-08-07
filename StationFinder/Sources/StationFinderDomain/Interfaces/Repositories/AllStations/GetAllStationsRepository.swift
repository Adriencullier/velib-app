public protocol GetAllStationsRepository: Actor {
    func getAllStations(for city: City) async throws -> [Station]
}
