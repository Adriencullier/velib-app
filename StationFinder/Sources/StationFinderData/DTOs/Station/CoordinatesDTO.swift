public struct CoordinatesDTO: Decodable, Sendable {
    let longitude: Double
    let latitude: Double    
    
    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
