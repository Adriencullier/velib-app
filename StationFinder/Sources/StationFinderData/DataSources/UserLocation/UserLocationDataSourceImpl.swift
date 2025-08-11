import CoreLocation

public actor UserLocationDataSourceImpl: NSObject, UserLocationDataSource {
    private let locationManager: CLLocationManager = CLLocationManager()
    
    public override init() {
        super.init()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func fetchUserLocation() -> LocationDTO? {
        guard let location = self.locationManager.location?.coordinate else {
            return nil
        }
        return LocationDTO(
            longitude: location.longitude,
            latitude: location.latitude
        )
    }
}
