import CoreNetworking
import DependencyInjection
import StationFinderDomain
import StationFinderData

public struct StationFinderModuleConfiguration: ModuleConfiguring {
    public static func registerImplementations(in registery: Registry) async {
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
    }
    
    public static func start(with resolver: any Resolver) async {
        let getHttpClient = await resolver.resolve(type: GetHTTPClient.self)
        let allStationsDataSource = await resolver.resolve(type: AllStationsDataSource.self)
        let getAllStationsRepository = await resolver.resolve(type: GetAllStationsRepository.self)
        let userLocationDataSource = await resolver.resolve(type: UserLocationDataSource.self)
        let getUserLocationRepository = await resolver.resolve(type: GetUserLocationRepository.self)
        
        (allStationsDataSource as? HasDependencies)?.setDependencies([getHttpClient])
        (getAllStationsRepository as? HasDependencies)?.setDependencies([allStationsDataSource])
        (getUserLocationRepository as? HasDependencies)?.setDependencies([userLocationDataSource])
    }
}
