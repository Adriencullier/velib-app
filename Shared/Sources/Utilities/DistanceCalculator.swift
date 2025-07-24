import Foundation

public struct DistanceCalculator {
    public static func calculateDistance(startLatitude: Double,
                                         startLongitude: Double,
                                         destinationLatitude: Double,
                                         destinationLongitude: Double) -> Int {
        // Earth radius in meters
        let earthRadius = 6371000.0
        
        let lat1 = startLatitude * .pi / 180
        let lat2 = destinationLatitude * .pi / 180
        let deltaLat = (destinationLatitude - startLatitude) * .pi / 180
        let deltaLon = (destinationLongitude - startLongitude) * .pi / 180
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) +
        cos(lat1) * cos(lat2) *
        sin(deltaLon/2) * sin(deltaLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        return Int(earthRadius * c)
    }
}
