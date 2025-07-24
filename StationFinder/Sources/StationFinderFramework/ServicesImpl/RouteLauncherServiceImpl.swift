import UIKit
import Foundation
import StationFinderData

enum RouteLauncherServiceError: Error, LocalizedError {
    case noRouteAppAvailable
    
    public var errorDescription: String? {
        switch self {
        case .noRouteAppAvailable:
            return "No route app available to open."
        }
    }
}


public struct RouteLauncherServiceImpl: RouteLauncherService {
    public init() {}
    
    public func showRoute(from: StationFinderData.LocationDTO, to: StationFinderData.LocationDTO) throws {
        let googleRouteURL = URL(
            string: "comgooglemaps://?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)&directionsmode=walking"
        )
        let appleRouteURL = URL(string: "http://maps.apple.com/?saddr=\(from.latitude),\(from.longitude)&daddr=\(to.latitude),\(to.longitude)&dirflg=w")
        
        if let googleURL = googleRouteURL,
           UIApplication.shared.canOpenURL(googleURL) {
            UIApplication.shared.open(
                googleURL,
                options: [:],
                completionHandler: nil
            )
        } else if let appleURL = appleRouteURL,
                  UIApplication.shared.canOpenURL(appleURL) {
            UIApplication.shared.open(
                appleURL,
                options: [:],
                completionHandler: nil
            )
        } else {
            throw RouteLauncherServiceError.noRouteAppAvailable
        }
    }
}
