public protocol AllVelibStationsDataSource: Actor {
    func fetchAllStations() async throws -> [VelibStationDTO]
}
