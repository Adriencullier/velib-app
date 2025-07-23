public struct Station: Equatable, Sendable {
    public let id: String
    public let name: String
    public let address: String
    public let availablePlaces: Int
    public let availableMechanicalBikes: Int
    public let availableEBikes: Int
    public let longitude: Double
    public let latitude: Double
    
    public init(id: String,
                name: String,
                address: String,
                availablePlaces: Int,
                availableMechanicalBikes: Int,
                availableEBikes: Int,
                longitude: Double,
                latitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.availablePlaces = availablePlaces
        self.availableMechanicalBikes = availableMechanicalBikes
        self.availableEBikes = availableEBikes
        self.longitude = longitude
        self.latitude = latitude
    }
}
