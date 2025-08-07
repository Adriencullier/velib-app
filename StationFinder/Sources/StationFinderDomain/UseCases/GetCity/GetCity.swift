public protocol GetCity: Actor {
    func execute(userLocation: Location?) -> City
}
