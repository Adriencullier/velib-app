import Foundation

public enum GetUserLocationRepositoryError: Error, LocalizedError {
    case userLocationDataSourceNotSet
    case userLocationNotAvailable
    
    public var errorDescription: String? {
        switch self {
        case .userLocationDataSourceNotSet:
            return "User location data source is not set."
        case .userLocationNotAvailable:
            return "User location is not available."
        }
    } 
}
