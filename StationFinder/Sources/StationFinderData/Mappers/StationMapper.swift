import StationFinderDomain

struct StationMapper {
    static func map(from dto: ParisStationDTO) -> Station? {
        guard let name = dto.name,
              let city = dto.city,
              let coordinates = dto.coordinates else {
            return nil
        }
        return Station(
            id: dto.stationCode,
            name: name,
            address: city,
            availablePlaces: dto.availableDocks,
            availableMechanicalBikes: dto.mechanical,
            availableEBikes: dto.ebike ?? 0,
            longitude: coordinates.longitude,
            latitude: coordinates.latitude
        )
    }
    
    static func map(from dto: LilleStationDTO) -> Station? {
        guard let name = dto.name,
              let city = dto.city,
              let lat = dto.latitude,
              let long = dto.longitude,
              let id = dto.stationCode,
              let availPlaces = dto.availableDocks,
              let availBikes = dto.mechanical else {
            return nil
        }
        return Station(
            id: id,
            name: name,
            address: city,
            availablePlaces: availPlaces,
            availableMechanicalBikes: availBikes,
            availableEBikes: 0,
            longitude: long,
            latitude: lat
        )
    }
}
