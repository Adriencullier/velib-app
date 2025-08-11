import SwiftUI
import StationFinderDomain
import MapKit


struct NearestStationMapView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Bindable private var viewModel: NearestStationMapViewModel
    
    @State private var mapScale: Double = 0
    @State private var selectedStation: MapStationModel?
    
    init(viewModel: NearestStationMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            mapView
                .task {
                    await self.viewModel.onTask()
                }
                .mapControls({
                    MapUserLocationButton()
                    MapCompass()
                })
                .onMapCameraChange { context in
                    viewModel.onPositionChange(context.camera.centerCoordinate)
                    self.mapScale = context.camera.distance
                }
                .navigationTitle(
                    "Stations "
                    + self.viewModel.veloName
                )
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        self.viewModel.onEnterForeground()
                    }
                }
                .toolbar(
                    content: {
                        ToolbarItem(
                            placement: .primaryAction) {
                                Button(
                                    "Refresh",
                                    systemImage: "arrow.counterclockwise") {
                                        Task {
                                            await self.viewModel.onRefresh()
                                        }
                                    }
                            }
                    }
                )
            if viewModel.shouldPresentFetchButton {
                Button {
                     self.viewModel.onFetchButtonPressed()
                } label: {
                    Text("Rechercher dans cette zone")
                        .font(.callout)
                        .foregroundStyle(.blue.gradient)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 44)
                                .foregroundStyle(.thickMaterial)
                        )
                }
            }
        }
    }
    
    private var mapView: some View {
        Map(position: self.$viewModel.position) {
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
    }
    
    private func selectStation(_ station: MapStationModel?) {
        self.selectedStation = station
    }
}
