struct StationAnnotationViewModel {
    let station: MapStationModel
    let zoomLevel: ZoomLevel
    let onNavigatePress: () -> Void
    
    var allAvailableBikes: Int {
        return self.station.availableEBikes + self.station.availableMechanicalBikes
    }
    
    var stationCapacity: Int {
        return self.station.availablePlaces
        + self.allAvailableBikes
    }
    
    init(station: MapStationModel,
         zoomLevel: Double,
         isSelected: Bool,
         onNavigatePress: @escaping () -> Void) {
        self.station = station
        if isSelected {
            self.zoomLevel = .maximum
        } else {
            self.zoomLevel = ZoomLevel(zoomLevel)
        }
        self.onNavigatePress = onNavigatePress
    }
}
