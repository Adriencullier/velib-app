import CoreNetworking
import DependencyInjection
import StationFinderDomain
import StationFinderData

public struct StationFinderModuleConfiguration: ModuleConfiguring {
    public static func registerImplementations(in registery: DependencyInjection.Registry) async {
        await registery.register(
            type: AllStationsDataSource.self,
            service: AllStationsDataSourceImpl()
        )
        await registery.register(
            type: GetAllStationsRepository.self,
            service: GetAllStationsRepositoryImpl()
        )
    }
    
    public static func start(with resolver: any DependencyInjection.Resolver) async {
        guard let getHttpClient = await resolver.resolve(type: GetHTTPClient.self) else {
            fatalError("GetHTTPClient is not registered")
        }
        guard let allStationsDataSource = await resolver.resolve(type: AllStationsDataSource.self) else {
            fatalError("AllStationsDataSource is not registered")
        }
        guard let getAllStationsRepository = await resolver.resolve(type: GetAllStationsRepository.self) else {
            fatalError("GetAllStationsRepository is not registered")
        }        
        await (allStationsDataSource as? AllStationsDataSourceImpl)?.setDependencies(getHttpClient)
        await (getAllStationsRepository as? GetAllStationsRepositoryImpl)?.setDependencies(allStationsDataSource)
    }
}
