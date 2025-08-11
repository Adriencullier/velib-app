public protocol GetUserLocation: Actor {
    func execute() async -> Location?
}
