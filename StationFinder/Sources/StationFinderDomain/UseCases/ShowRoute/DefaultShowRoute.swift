public struct DefaultShowRoute: ShowRoute {
    private let routeLauncherService: RouteLauncherService
    
    public init(routeLauncherService: RouteLauncherService) {
        self.routeLauncherService = routeLauncherService
    }
    
    public func execute(from start: Location, to destination: Location) throws {
        try self.routeLauncherService.showRoute(
            from: start,
            to: destination,
        )
    }
}
