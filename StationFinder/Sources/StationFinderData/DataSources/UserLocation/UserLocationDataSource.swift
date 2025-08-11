public protocol UserLocationDataSource: Actor {
    func fetchUserLocation() -> LocationDTO?
}
    
