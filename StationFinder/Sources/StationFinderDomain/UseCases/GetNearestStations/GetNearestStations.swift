public protocol GetNearestStations: AnyObject {
    func execute(longitude: Double, latitude: Double) async throws -> [Station]
}
