struct StationResultDTO: Decodable, Sendable {
    let results: [StationDTO]
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "result"
        case total = "total"
    }
}
