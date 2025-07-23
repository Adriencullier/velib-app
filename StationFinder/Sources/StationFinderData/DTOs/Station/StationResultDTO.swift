public struct StationResultDTO: Decodable, Sendable {
    public let results: [StationDTO]
    public let total: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case total = "total_count"
    }
}
