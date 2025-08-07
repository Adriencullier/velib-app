public struct LilleStationDTO: Decodable, Sendable {
    let stationCode: String?
    let name: String?
    let city: String?
    let availableDocks: Int?
    let mechanical: Int?
    let latitude: Double?
    let longitude: Double?
    
    init(stationCode: String,
         name: String,
         city: String,
         availableDocks: Int,
         mechanical: Int,
         latitude: Double,
         longitude: Double) {
        self.stationCode = stationCode
        self.name = name
        self.city = city
        self.availableDocks = availableDocks
        self.mechanical = mechanical
        self.latitude = latitude
        self.longitude = longitude
    }
    
    enum CodingKeys: String, CodingKey {
        case stationCode = "@id"
        case name = "nom"
        case city = "commune"
        case availableDocks = "nb_places_dispo"
        case mechanical = "nb_velos_dispo"
        case latitude = "y"
        case longitude = "x"
    }
}
