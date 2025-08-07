import StationFinderDomain
import DependencyInjection

public actor GetAllStationsRepositoryImpl: GetAllStationsRepository, HasDependencies {
    weak var allVelibStationsDataSource: AllVelibStationsDataSource?
    
    public init() {}
    
    public func getAllStations(for city: City) async throws -> [Station] {
        switch city {
        case .paris:
            guard let allVelibStationsDataSource = self.allVelibStationsDataSource else {
                fatalError("AllTerminalsDataSource is not set")
            }
            let velibStationDTO = try await allVelibStationsDataSource.fetchAllStations()
            return velibStationDTO.compactMap {
                StationMapper.map(from: $0)
            }
        }
    }
    
    public func setDependencies(_ allVelibStationsDataSource: AllVelibStationsDataSource) {
        self.allVelibStationsDataSource = allVelibStationsDataSource
    }
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let allVelibStationsDataSource = dependencies.first(where: {
            $0 is AllVelibStationsDataSource
        }) as? AllVelibStationsDataSource
        Task {
            await self.setDependencies(allVelibStationsDataSource)
        }
    }
    
    private func setDependencies(_ allVelibStationsDataSource: AllVelibStationsDataSource?) {
        self.allVelibStationsDataSource = allVelibStationsDataSource
    }
}
