import DependencyInjection
import SwiftUICore
import StationFinderDomain

public struct NearestStationListBuilder {
    @ViewBuilder
    public static func build(_ resolver: Resolver) async -> some View {
        let getNearestStations = DefaultGetNearestStations(
            getAllStationsRepository: await resolver.resolve(type: GetAllStationsRepository.self)
        )
        let getUserLocation = DefaultGetUserLocation(
            getUserLocationRepository: await resolver.resolve(type: GetUserLocationRepository.self)
        )
        let showRoute = DefaultShowRoute(
            routeLauncherService: await resolver.resolve(type: RouteLauncherService.self)
        )
        let viewModel = await NearestStationListViewModel(
            getNearestStations: getNearestStations,
            getUserLocation: getUserLocation,
            showRoute: showRoute
        )
        await NearestStationListView(viewModel: viewModel)
    }
}

