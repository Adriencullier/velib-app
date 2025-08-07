public protocol AllLilleStationsDataSource: Actor {
    func fetchAllStations() async throws -> [LilleStationDTO]
}
