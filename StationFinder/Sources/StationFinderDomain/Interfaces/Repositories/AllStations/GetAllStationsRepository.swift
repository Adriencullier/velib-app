public protocol GetAllStationsRepository: Actor {
    func getAllStations() async throws -> [Station]
}
