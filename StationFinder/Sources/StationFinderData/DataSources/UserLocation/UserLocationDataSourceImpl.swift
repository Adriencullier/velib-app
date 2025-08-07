import CoreLocation

@MainActor
public final class UserLocationDataSourceImpl: NSObject, UserLocationDataSource {
    private let locationManager: CLLocationManager = CLLocationManager()
    private var location: CLLocation?
    private var asyncStream: AsyncStream<LocationDTO?>?
    private var continuation: AsyncStream<LocationDTO?>.Continuation?
    
    public override init() {
        super.init()
        self.start()
        self.asyncStream = AsyncStream { continuation in
            self.continuation = continuation
        }
    }
    
    public func fetchUserLocation() async throws -> AsyncStream<LocationDTO?> {
        return self.asyncStream!
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
        let location: LocationDTO? = {
            guard let location = locations.first else {
                return nil
            }
            return LocationDTO(
                longitude: location.coordinate.longitude,
                latitude: location.coordinate.latitude
            )
        }()
        Task { @MainActor in
            self.continuation?.yield(location)
        }
    }
    
    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            Task { @MainActor in
                self.continuation?.yield(nil)
            }
        }  
    }
}
