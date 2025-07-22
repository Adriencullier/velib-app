import StationFinderDomain

public final class GetAllStationsRepositoryImpl: GetAllStationsRepository {
    weak var allTerminalsDataSource: AllStationsDataSource?
    
    public func getAllStations() async throws -> [Station] {
        guard let allTerminalsDataSource = self.allTerminalsDataSource else {
            fatalError("AllTerminalsDataSource is not set")
        }
        let terminalsDTO = try await allTerminalsDataSource.fetchAllStations()
        return terminalsDTO.map {
            StationMapper.map(from: $0)
        }
    }
}
