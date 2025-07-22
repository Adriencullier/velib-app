import Foundation
import CoreNetworking

actor AllStationsDataSourceImpl: AllStationsDataSource {
    private let client: GetHTTPClient
    
    init(client: GetHTTPClient) {
        self.client = client
    }
    
    func fetchAllStations() async throws -> [StationDTO] {
        let limit = 100
        let total = try await self.getTotal()
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
                    try await self.client.get(
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
    
    private func getTotal() async throws -> Int {
        var uRLComponents = URLComponents(
            string: "https://opendata.paris.fr/api/explore/v2.1/catalog/datasets/velib-disponibilite-en-temps-reel/records"
        )
        uRLComponents?.queryItems = [
            URLQueryItem(name: "limit", value: "1")
        ]
        guard let url = uRLComponents?.url else {
            throw HTTPError.invalidURL
        }
        let response = try await self.client.get(
            from: url.absoluteString,
            responseType: StationResultDTO.self
        )
        return response.total
    }
}
