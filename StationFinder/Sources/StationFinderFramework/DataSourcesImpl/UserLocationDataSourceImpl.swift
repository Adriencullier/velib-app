import CoreLocation
import StationFinderData

@MainActor
public final class UserLocationDataSourceImpl: NSObject, UserLocationDataSource {
    private let locationManager: CLLocationManager = CLLocationManager()
    private var location: CLLocation?
    
    public override init() {
        super.init()
        self.start()
    }
    
    public func fetchUserLocation() async throws -> UserLocationDTO? {
        guard let coordinates = self.location?.coordinate else {
            return nil
        }
        return UserLocationDTO(
            longitude: coordinates.longitude,
            latitude: coordinates.latitude
        )
    }
    
    private func start() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}

extension UserLocationDataSourceImpl: CLLocationManagerDelegate {
    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            self.location = locations.last
        }
    }
}
