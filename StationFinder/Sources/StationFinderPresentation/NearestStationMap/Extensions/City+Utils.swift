import StationFinderDomain

extension City {
    public var veloName: String {
        switch self {
        case .paris:
            return "Velib"
        }
    }        
}
