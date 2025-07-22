struct StationDTO: Decodable, Sendable {
    let stationCode: Int
    let name: String
    let city: String
    let availableDocks: Int
    let mechanical: Int
    let ebike: Int
    let coordinates: CoordinatesDTO
    
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
