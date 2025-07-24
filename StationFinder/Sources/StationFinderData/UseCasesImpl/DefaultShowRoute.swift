import StationFinderDomain

public struct DefaultShowRoute: ShowRoute {
    private let routeLauncherService: RouteLauncherService
    
    public init(routeLauncherService: RouteLauncherService) {
        self.routeLauncherService = routeLauncherService
    }
    
    public func execute(from start: Location, to destination: Location) throws {
        try self.routeLauncherService.showRoute(
            from: LocationDTO(
                longitude: start.longitude,
                latitude: start.latitude
            ),
            to: LocationDTO(
                longitude: destination.longitude,
                latitude: destination.latitude
            ),
        )
    }
}
