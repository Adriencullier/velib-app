import StationFinderDomain

struct StationMapper {
    static func map(from dto: StationDTO) -> Station {
        return Station(
            id: dto.stationCode,
            name: dto.name,
            address: dto.city,
            availablePlaces: dto.availableDocks,
            availableBikes: dto.ebike + dto.mechanical,
            longitude: dto.coordinates.longitude,
            latitude: dto.coordinates.latitude
        )
    }
}
