public protocol AllParisStationsDataSource: Actor {
    func fetchAllStations() async throws -> [ParisStationDTO]
}
