import StationFinderDomain

public actor GetAllStationsRepositoryImpl: GetAllStationsRepository {
    weak var allTerminalsDataSource: AllStationsDataSource?
    
    public init() {}
    
    public func getAllStations() async throws -> [Station] {
        guard let allTerminalsDataSource = self.allTerminalsDataSource else {
            fatalError("AllTerminalsDataSource is not set")
        }
        let terminalsDTO = try await allTerminalsDataSource.fetchAllStations()
        return terminalsDTO.compactMap {
            StationMapper.map(from: $0)
        }
    }
    
    public func setDependencies(_ allTerminalsDataSource: AllStationsDataSource) {
        self.allTerminalsDataSource = allTerminalsDataSource
    }
}
