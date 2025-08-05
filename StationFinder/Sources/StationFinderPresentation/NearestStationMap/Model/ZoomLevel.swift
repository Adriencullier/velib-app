enum ZoomLevel {
    case minimal
    case medium
    case maximum
    
    private static let dotThreshold: Double = 5000
    private static let minimalThreshold: Double = 2000
    
    init(_ zoom: Double) {
        switch zoom {
        case 0..<ZoomLevel.minimalThreshold:
            self = .maximum
        case ZoomLevel.minimalThreshold..<ZoomLevel.dotThreshold:
            self = .medium
        default:
            self = .minimal
        }
    }
}
