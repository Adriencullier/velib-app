struct MapStationModel: Identifiable, Equatable {
    let id: String
    let name: String
    let availablePlaces: Int
    let availableMechanicalBikes: Int
    let availableEBikes: Int
    let longitude: Double
    let latitude: Double
}
