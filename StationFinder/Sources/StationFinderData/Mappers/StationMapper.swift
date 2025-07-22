import StationFinderDomain

struct StationMapper {
    static func map(from dto: StationDTO) -> Station? {
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
            availableBikes: (dto.ebike ?? 0) + dto.mechanical,
            longitude: coordinates.longitude,
            latitude: coordinates.latitude
        )
    }
}
