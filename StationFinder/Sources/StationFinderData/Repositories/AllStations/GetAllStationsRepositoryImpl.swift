import StationFinderDomain
import DependencyInjection

public actor GetAllStationsRepositoryImpl: GetAllStationsRepository, HasDependencies {
    weak var allStationssDataSource: AllStationsDataSource?
    
    public init() {}
    
    public func getAllStations() async throws -> [Station] {
        guard let allTerminalsDataSource = self.allStationssDataSource else {
            fatalError("AllTerminalsDataSource is not set")
        }
        let terminalsDTO = try await allTerminalsDataSource.fetchAllStations()
        return terminalsDTO.compactMap {
            StationMapper.map(from: $0)
        }
    }
    
    public func setDependencies(_ allTerminalsDataSource: AllStationsDataSource) {
        self.allStationssDataSource = allTerminalsDataSource
    }
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let allStationsDataSource = dependencies.first(where: { $0 is AllStationsDataSource }) as? AllStationsDataSource
        Task {
            await self.setDependencies(allStationsDataSource)
        }
    }
    
    private func setDependencies(_ allStationsDataSource: AllStationsDataSource?) {
        self.allStationssDataSource = allStationsDataSource
    }
}
