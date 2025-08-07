struct LilleStationResultDTO: Decodable, Sendable {
    let results: [LilleStationDTO]
    
    enum CodingKeys: String, CodingKey {
        case results = "records"
    }
}
