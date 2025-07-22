import SwiftUI
import StationFinderDomain

@MainActor
@Observable
public final class NearestStationListViewModel {
    private(set) var nearestStations: [Station] = []
    
    private let getNearestStations: GetNearestStations
    
    public init(getNearestStations: GetNearestStations) {
        self.getNearestStations = getNearestStations
    }
    
    func onViewTask() async throws {
        self.nearestStations = try await self.getNearestStations.execute(
            longitude: 2.2965630438180575,
            latitude: 48.9626867371301
        )
    }
}
