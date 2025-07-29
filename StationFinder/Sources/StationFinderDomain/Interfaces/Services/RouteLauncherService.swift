public protocol RouteLauncherService: AnyObject, Sendable {
    @MainActor
    func showRoute(from: Location, to: Location) throws
}
