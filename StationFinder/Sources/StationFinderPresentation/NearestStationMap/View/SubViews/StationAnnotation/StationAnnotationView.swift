import SwiftUI

struct StationAnnotationView: View {
    private let viewModel: StationAnnotationViewModel
    
    init(viewModel: StationAnnotationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch self.viewModel.zoomLevel {
        case .minimal:
            MinimalStationAnnotation()
        case .medium:
            MediumStationAnnotation(
                allAvailableBikes: self.viewModel.allAvailableBikes,
                stationCapacity: self.viewModel.stationCapacity
            )
        case .maximum:
            MaximumStationAnnotation(
                name: self.viewModel.station.name,
                availableMechanicalBikes: self.viewModel.station.availableMechanicalBikes,
                availableEBikes: self.viewModel.station.availableEBikes,
                availablePlaces: self.viewModel.station.availablePlaces,
                onNavigatePress: self.viewModel.onNavigatePress
            )
        }
    }
}
