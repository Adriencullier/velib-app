import Utilities

public actor DefaultGetCity: GetCity {
    public init() {}
    public func execute(userLocation: Location?) -> City {
        guard let userLocation else {
            return .defaultCity
        }
        guard let city = City.allCases.first(where: { city in
            DistanceCalculator.calculateDistance(
                startLatitude: city.centerLocation.latitude,
                startLongitude: city.centerLocation.longitude,
                destinationLatitude: userLocation.latitude,
                destinationLongitude: userLocation.longitude
            ) <= city.radius
        }) else {
            return City.allCases.sorted(by: { city1, city2 in
                DistanceCalculator.calculateDistance(
                    startLatitude: city1.centerLocation.latitude,
                    startLongitude: city1.centerLocation.longitude,
                    destinationLatitude: userLocation.latitude,
                    destinationLongitude: userLocation.longitude
                ) <
                    DistanceCalculator.calculateDistance(
                        startLatitude: city2.centerLocation.latitude,
                        startLongitude: city2.centerLocation.longitude,
                        destinationLatitude: userLocation.latitude,
                        destinationLongitude: userLocation.longitude
                    )
            }).first ?? .defaultCity
        }
        return city
    }
}
