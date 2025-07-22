import Foundation

public enum HTTPError: Error, LocalizedError {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed(Error)
    case networkError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .requestFailed(let statusCode):
            return "Request failed with status code \(statusCode)."
        case .decodingFailed(let error):
            return "Decoding failed with error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        }
    }
}
