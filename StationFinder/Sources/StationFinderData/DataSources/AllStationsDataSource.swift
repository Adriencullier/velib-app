protocol AllStationsDataSource: AnyObject {
    func fetchAllStations() async throws -> [StationDTO]
}
