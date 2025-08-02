import Foundation

enum GetUserLocationRepositoryError: Error, LocalizedError {
    case userLocationNotAvailable
    
    var errorDescription: String? {
        switch self {
        case .userLocationNotAvailable:
            return "User location is not available."
        }
    }
}
