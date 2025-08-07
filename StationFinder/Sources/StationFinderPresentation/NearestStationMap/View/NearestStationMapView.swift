import SwiftUI
import StationFinderDomain
import MapKit


struct NearestStationMapView: View {
    @Bindable private var viewModel: NearestStationMapViewModel
    
    @State private var mapScale: Double = 0
    @State private var selectedStation: MapStationModel?
    
    init(viewModel: NearestStationMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Map(
            position: self.$viewModel.position,
            bounds: self.viewModel.bounds
        ) {
            ForEach(self.viewModel.stations) { station in
                Annotation("",
                           coordinate: .init(latitude: station.latitude, longitude: station.longitude)) {
                    StationAnnotationView(
                        viewModel: StationAnnotationViewModel(
                            station: station,
                            zoomLevel: mapScale,
                            isSelected: selectedStation?.id == station.id,
                            onNavigatePress: {
                                self.viewModel.onRoutePressed(station)
                            }
                        )
                    )
                    .onTapGesture {
                        if let selected = self.selectedStation, selected.id == station.id {
                            self.selectedStation = nil
                        } else {
                            self.selectedStation = station
                        }
                    }
                }
            }
            UserAnnotation()
        }
        .mapControls({
            MapUserLocationButton()
            MapCompass()
        })
        .onMapCameraChange { context in
            viewModel.onPositionChange(context.camera.centerCoordinate)
            self.mapScale = context.camera.distance
        }
        .onAppear {
            if let coordinate = viewModel.position.camera?.centerCoordinate {
                viewModel.onPositionChange(coordinate)
            }
            if let distance = viewModel.position.camera?.distance {
                mapScale = distance
            }
        }
        .navigationTitle("Vélos à proximité")
        .toolbar(
            content: {
                ToolbarItem(
                    placement: .primaryAction) {
                        Button(
                            "Refresh",
                            systemImage: "arrow.counterclockwise") {
                                Task {
                                    try await self.viewModel.onRefresh()
                                }
                            }
                    }
            })
    }
    
    private func selectStation(_ station: MapStationModel?) {
        self.selectedStation = station
    }
}
