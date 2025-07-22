import Foundation
import CoreNetworking

public actor AllStationsDataSourceImpl: AllStationsDataSource {
    weak var client: GetHTTPClient?
    
    public init() {}
    
    public func fetchAllStations() async throws -> [StationDTO] {
        guard let client = self.client else {
            fatalError("HTTP client is not set")
        }
        let limit = 100
        let total = try await self.getTotal(with: client)
        return try await withThrowingTaskGroup(of: StationResultDTO.self) { taskGroup in
            var fetchedStationsCount = 0
            
            while fetchedStationsCount < total {
                var uRLComponents = URLComponents(
                    string: "https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/velib-disponibilite-en-temps-reel/records"
                )
                uRLComponents?.queryItems = [
                    URLQueryItem(name: "offset", value: "\(fetchedStationsCount)"),
                    URLQueryItem(name: "limit", value: "\(limit)")
                ]
                guard let url = uRLComponents?.url else {
                    throw HTTPError.invalidURL
                }
                taskGroup.addTask {
                    try await client.get(
                        from: url.absoluteString,
                        responseType: StationResultDTO.self
                    )
                }
                fetchedStationsCount += limit
            }
            
            var stations: [StationDTO] = []
            for try await result in taskGroup {
                stations += result.results
            }
            return stations
        }
    }
    
    public func setDependencies(_ client: GetHTTPClient) {
        self.client = client
    }
    
    private func getTotal(with client: GetHTTPClient) async throws -> Int {
        var uRLComponents = URLComponents(
            string: "https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/velib-disponibilite-en-temps-reel/records"
        )
        uRLComponents?.queryItems = [
            URLQueryItem(name: "limit", value: "1")
        ]
        guard let url = uRLComponents?.url else {
            throw HTTPError.invalidURL
        }
        let response = try await client.get(
            from: url.absoluteString,
            responseType: StationResultDTO.self
        )
        return response.total
    }
}
