struct ParisStationResultDTO: Decodable, Sendable {
    let results: [ParisStationDTO]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case total = "total_count"
    }
}
