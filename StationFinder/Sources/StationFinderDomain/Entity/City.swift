public enum City: CaseIterable, Sendable {
    case paris
    
    public static let defaultCity: City = .paris
    
    public var centerLocation: Location {
        switch self {
        case .paris:
            return Location(
                latitude: 48.8566,
                longitude: 2.3522
            )
        }
    }
    
    public var radius: Int {
        switch self {
        case .paris:
            return 10000
        }
    }
}
