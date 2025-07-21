import DependencyInjection
import StationFinderDomain
import StationFinderData

public struct StationFinderModuleConfiguration: ModuleConfiguring {
    public static func registerImplementations(in registery: DependencyInjection.Registry) async {
        await registery.register(
            type: GetNearestStations.self,
            service: DefaultGetNearestStations()
        )
    }
    
    public static func start(with resolver: any DependencyInjection.Resolver) async {
        
    }
}
