import DependencyInjection

public protocol GetNearestStations: Sendable {
    func execute(longitude: Double, latitude: Double) async throws -> [Station]
}
