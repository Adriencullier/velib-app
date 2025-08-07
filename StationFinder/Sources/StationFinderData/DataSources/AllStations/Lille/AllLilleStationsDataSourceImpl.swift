//
//  AllParisStationsDataSourceImpl.swift
//  StationFinder
//
//  Created by Adrien Cullier on 07/08/2025.
//


import Foundation
import CoreNetworking
import DependencyInjection

public actor AllLilleStationsDataSourceImpl: AllLilleStationsDataSource, HasDependencies {
    weak var client: GetHTTPClient?
    
    public init() {}
    
    public func fetchAllStations() async throws -> [LilleStationDTO] {
        guard let client = self.client else {
            fatalError("HTTP client is not set")
        }
        guard let url = URL(
            string: "https://data.lillemetropole.fr/data/ogcapi/collections/ilevia:vlille_temps_reel/items?limit=500&f=json"
        ) else {
            throw HTTPError.invalidURL
        }
        let result = try await client.get(
            from: url.absoluteString,
            responseType: LilleStationResultDTO.self
        )
        return result.results
    }
    
    nonisolated public func setDependencies(_ dependencies: [Any]) {
        let client = dependencies.first as? GetHTTPClient
        Task {
            await self.setDependencies(client)
        }
    }
    
    private func setDependencies(_ client: GetHTTPClient?) {
        self.client = client
    }
}
