struct VelibStationResultDTO: Decodable, Sendable {
    let results: [VelibStationDTO]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case total = "total_count"
    }
}
