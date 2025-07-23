public protocol AllStationsDataSource: AnyObject, Sendable {
    func fetchAllStations() async throws -> [StationDTO]
}
