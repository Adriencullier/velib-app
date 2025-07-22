public protocol GetNearestStations {
    func execute(longitude: Double, latitude: Double) async throws -> [Station]
}
