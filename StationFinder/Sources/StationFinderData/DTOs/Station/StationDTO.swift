public struct StationDTO: Decodable, Sendable {
    let stationCode: String
    let name: String?
    let city: String?
    let availableDocks: Int
    let mechanical: Int
    let ebike: Int?
    let coordinates: CoordinatesDTO?
    
    init(stationCode: String,
         name: String,
         city: String,
         availableDocks: Int,
         mechanical: Int,
         ebike: Int,
         coordinates: CoordinatesDTO) {
        self.stationCode = stationCode
        self.name = name
        self.city = city
        self.availableDocks = availableDocks
        self.mechanical = mechanical
        self.ebike = ebike
        self.coordinates = coordinates
    }
    
    enum CodingKeys: String, CodingKey {
        case stationCode = "stationcode"
        case name = "name"
        case city = "nom_arrondissement_communes"
        case availableDocks = "numdocksavailable"
        case mechanical = "mechanical"
        case ebike = "ebike"
        case coordinates = "coordonnees_geo"
    }
}
