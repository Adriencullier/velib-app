struct CoordinatesDTO: Decodable, Sendable {
    let longitude: Double
    let latitude: Double    
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
