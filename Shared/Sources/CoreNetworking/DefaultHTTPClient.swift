import Foundation

public actor DefaultHTTPClient: GetHTTPClient {
    private let session: URLSession = .shared
    
    public func get<T: Decodable & Sendable>(from endpoint: String, responseType: T.Type) async throws -> T {
        guard let url = URL(string: "\(endpoint)") else {
            throw HTTPError.invalidURL
        }
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.requestFailed(statusCode: 0)
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                throw HTTPError.requestFailed(statusCode: httpResponse.statusCode)
            }            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw HTTPError.decodingFailed(error)
            }
        } catch let error as HTTPError {
            throw error
        } catch {
            throw HTTPError.networkError(error)
        }
    }
}
