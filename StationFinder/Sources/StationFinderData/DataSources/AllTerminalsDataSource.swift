protocol AllTerminalsDataSource: AnyObject {
    func fetchAllTerminals() async throws -> [StationDTO]
}
