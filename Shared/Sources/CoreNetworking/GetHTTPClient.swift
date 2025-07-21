public protocol GetHTTPClient: Sendable {
    func get<T: Decodable>(from endpoint: String, responseType: T.Type) async throws -> T
}
