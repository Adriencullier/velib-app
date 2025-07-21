public struct Station: Equatable {
    public let id: Int
    public let name: String
    public let address: String
    public let availablePlaces: Int
    public let availableBikes: Int
    public let longitude: Double
    public let latitude: Double
    
    public init(id: Int,
                name: String,
                address: String,
                availablePlaces: Int,
                availableBikes: Int,
                longitude: Double,
                latitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.availablePlaces = availablePlaces
        self.availableBikes = availableBikes
        self.longitude = longitude
        self.latitude = latitude
    }
}
