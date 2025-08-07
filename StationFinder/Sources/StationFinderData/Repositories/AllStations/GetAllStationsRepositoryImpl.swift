import StationFinderDomain
import DependencyInjection

public actor GetAllStationsRepositoryImpl: GetAllStationsRepository, HasDependencies {
    weak var allParisStationsDataSource: AllParisStationsDataSource?
    
    public init() {}
    
    public func getAllStations(for city: City) async throws -> [Station] {
        switch city {
        case .paris:
            guard let allParisStationsDataSource = self.allParisStationsDataSource else {
                fatalError("AllTerminalsDataSource is not set")
            }
            let parisStationDTO = try await allParisStationsDataSource.fetchAllStations()
            return parisStationDTO.compactMap {
                StationMapper.map(from: $0)
            }
        }
    }
    
    public func setDependencies(_ allParisStationsDataSource: AllParisStationsDataSource) {
        self.allParisStationsDataSource = allParisStationsDataSource
    }
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let allParisStationsDataSource = dependencies.first(where: {
            $0 is AllParisStationsDataSource
        }) as? AllParisStationsDataSource
        Task {
            await self.setDependencies(allParisStationsDataSource)
        }
    }
    
    private func setDependencies(_ allParisStationsDataSource: AllParisStationsDataSource?) {
        self.allParisStationsDataSource = allParisStationsDataSource
    }
}
