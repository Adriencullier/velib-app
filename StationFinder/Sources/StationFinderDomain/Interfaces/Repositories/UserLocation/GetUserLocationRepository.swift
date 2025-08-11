public protocol GetUserLocationRepository: Actor {
    func getUserLocation() async -> Location?
}
