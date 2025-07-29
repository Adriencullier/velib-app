public protocol GetAllStationsRepository: AnyObject, Sendable {
    func getAllStations() async throws -> [Station]
}
