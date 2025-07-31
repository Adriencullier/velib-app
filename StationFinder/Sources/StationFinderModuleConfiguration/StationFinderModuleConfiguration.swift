import CoreNetworking
import DependencyInjection
import StationFinderDomain; import StationFinderData; import StationFinderPresentation


public struct StationFinderModuleConfiguration: ModuleConfiguring {
    public static func registerDependencies(in registery: Registry) async {
        await registery.register(
            type: AllStationsDataSource.self,
            dependency: AllStationsDataSourceImpl()
        )
        await registery.register(
            type: GetAllStationsRepository.self,
            dependency: GetAllStationsRepositoryImpl()
        )
        await registery.register(
            type: UserLocationDataSource.self,
            dependency: UserLocationDataSourceImpl()
        )
        await registery.register(
            type: GetUserLocationRepository.self,
            dependency: GetUserLocationRepositoryImpl()
        )
        await registery.register(
            type: RouteLauncherService.self,
            dependency: RouteLauncherServiceImpl()
        )
        await registery.register(
            type: GetNearestStations.self,
            dependency: DefaultGetNearestStations()
        )
        await registery.register(
            type: GetUserLocation.self,
            dependency: DefaultGetUserLocation()
        )
        await registery.register(
            type: ShowRoute.self,
            dependency: DefaultShowRoute()
        )
    }
    
    public static func registerFactories(in registery: Registry) async {
        await registery.registerFactory(type: NearestStationListViewModel.self) { resolver in
            await NearestStationListViewModel(
                getNearestStations: resolver.resolve(type: GetNearestStations.self),
                getUserLocation: resolver.resolve(type: GetUserLocation.self),
                showRoute: resolver.resolve(type: ShowRoute.self)
            )
        }
    }
    
    public static func start(with resolver: any Resolver) async {
        let getHttpClient = await resolver.resolve(type: GetHTTPClient.self)
        let allStationsDataSource = await resolver.resolve(type: AllStationsDataSource.self)
        let getAllStationsRepository = await resolver.resolve(type: GetAllStationsRepository.self)
        let userLocationDataSource = await resolver.resolve(type: UserLocationDataSource.self)
        let getUserLocationRepository = await resolver.resolve(type: GetUserLocationRepository.self)
        let getNearestStations = await resolver.resolve(type: GetNearestStations.self)
        let getUserLocation = await resolver.resolve(type: GetUserLocation.self)
        
        await (allStationsDataSource as? HasDependencies)?.setDependencies([getHttpClient])
        await (getAllStationsRepository as? HasDependencies)?.setDependencies([allStationsDataSource])
        await (getUserLocationRepository as? HasDependencies)?.setDependencies([userLocationDataSource])
        await (getNearestStations as? HasDependencies)?.setDependencies([getAllStationsRepository])
        await (getUserLocation as? HasDependencies)?.setDependencies([getUserLocationRepository])
    }
}
