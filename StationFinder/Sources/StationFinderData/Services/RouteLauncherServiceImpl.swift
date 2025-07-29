import UIKit
import StationFinderDomain

public final class RouteLauncherServiceImpl: RouteLauncherService {
    public init() {}
    
    public func showRoute(from: Location, to: Location) throws {
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
