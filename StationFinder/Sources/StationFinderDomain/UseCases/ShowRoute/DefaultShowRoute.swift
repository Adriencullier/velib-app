import DependencyInjection

public actor DefaultShowRoute: ShowRoute, HasDependencies {
    weak var routeLauncherService: RouteLauncherService?
    
    public init() {}
    
    public func execute(from start: Location, to destination: Location) throws {
        Task { @MainActor in
            try await self.routeLauncherService?.showRoute(
                from: start,
                to: destination,
            )
        }
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.routeLauncherService = dependencies.first(where: { $0 is RouteLauncherService }) as? RouteLauncherService
    }
}
