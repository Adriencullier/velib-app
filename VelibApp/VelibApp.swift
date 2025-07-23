import SwiftUI
import DependencyInjection
import StationFinderDomain
import StationFinderPresentation

@main
struct VelibApp: App {
    private let container: (Registry & Resolver) = DependencyContainer()
    
    @State var nearestStationListViewModel: NearestStationListViewModel?
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let nearestStationListViewModel = self.nearestStationListViewModel {
                    NearestStationListView(
                        viewModel: nearestStationListViewModel
                    )
                    
                } else {
                    ProgressView()
                }
            }
            .task {
                await ModulesConfiguration.configureModules(
                    container: self.container
                )
                await self.setupViewModel()
            }
        }
    }
    
    private func setupViewModel() async {
        guard let getAllStationsRepository: GetAllStationsRepository = await self.container.resolve(type: GetAllStationsRepository.self) else {
            return
        }
        guard let getUserLocationRepository: GetUserLocationRepository = await self.container.resolve(type: GetUserLocationRepository.self) else {
            return
        }
        let getNearestStations: GetNearestStations = DefaultGetNearestStations(getAllStationsRepository: getAllStationsRepository)
        let getUserLocation: GetUserLocation = DefaultGetUserLocation(getUserLocationRepository: getUserLocationRepository)
        
        self.nearestStationListViewModel = NearestStationListViewModel(
            getNearestStations: getNearestStations,
            getUserLocation: getUserLocation
        )
    }
}
