import StationFinderDomain
import DependencyInjection

public actor GetAllStationsRepositoryImpl: GetAllStationsRepository, HasDependencies {
    weak var allParisStationsDataSource: AllParisStationsDataSource?
    weak var allLilleStationsDataSource: AllLilleStationsDataSource?
    
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
        case .lille:
            guard let allLilleStationsDataSource = self.allLilleStationsDataSource else {
                fatalError("AllLilleStationsDataSource is not set")
            }
            let lilleStationDTO = try await allLilleStationsDataSource.fetchAllStations()
            return lilleStationDTO.compactMap {
                StationMapper.map(from: $0)
            }
        }
    }
    
    public func setDependencies(allParisStationsDataSource: AllParisStationsDataSource?,
                                allLilleStationsDataSource: AllLilleStationsDataSource?) {
        self.allParisStationsDataSource = allParisStationsDataSource
        self.allLilleStationsDataSource = allLilleStationsDataSource
    }
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let allParisStationsDataSource = dependencies.first(where: {
            $0 is AllParisStationsDataSource
        }) as? AllParisStationsDataSource
        let allLilleStationsDataSource = dependencies.first(where: {
            $0 is AllLilleStationsDataSource
        }) as? AllLilleStationsDataSource
        Task {
            await self.setDependencies(
                allParisStationsDataSource: allParisStationsDataSource,
                allLilleStationsDataSource: allLilleStationsDataSource
            )
        }
    }
    
    private func setDependencies(_ allParisStationsDataSource: AllParisStationsDataSource?) {
        self.allParisStationsDataSource = allParisStationsDataSource
    }
}
