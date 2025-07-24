public protocol RouteLauncherService {
    @MainActor
    func showRoute(from: LocationDTO, to: LocationDTO) throws
}
