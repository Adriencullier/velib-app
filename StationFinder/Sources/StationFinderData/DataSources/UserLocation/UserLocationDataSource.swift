public protocol UserLocationDataSource: AnyObject, Sendable {
    func fetchUserLocation() async throws -> AsyncStream<LocationDTO?>
}
    
