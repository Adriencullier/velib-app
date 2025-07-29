public protocol AllStationsDataSource: Actor {
    func fetchAllStations() async throws -> [StationDTO]
}
