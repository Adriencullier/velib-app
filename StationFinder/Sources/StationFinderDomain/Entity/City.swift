public enum City: CaseIterable, Sendable {
    case paris
    case lille
    
    public static let defaultCity: City = .lille
    
    public var centerLocation: Location {
        switch self {
        case .paris:
            return Location(
                latitude: 48.8566,
                longitude: 2.3522
            )
        case .lille:
            return Location(
                latitude: 50.6278,
                longitude: 3.0583
            )
        }
    }
    
    public var radius: Int {
        switch self {
        case .paris:
            return 15000
        case .lille:
            return 15000
        }
    }
}
