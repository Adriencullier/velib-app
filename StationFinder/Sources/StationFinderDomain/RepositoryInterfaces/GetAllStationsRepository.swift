public protocol GetAllStationsRepository: AnyObject {
    func getAllStations() async throws -> [Station]
}
