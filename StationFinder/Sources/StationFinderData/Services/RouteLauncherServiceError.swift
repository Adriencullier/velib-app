import Foundation

enum RouteLauncherServiceError: Error, LocalizedError {
    case noRouteAppAvailable
    
    public var errorDescription: String? {
        switch self {
        case .noRouteAppAvailable:
            return "No route app available to open."
        }
    }
}
