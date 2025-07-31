import DependencyInjection

public struct CoreNetworkingModuleConfiguration: ModuleConfiguring {
    
    public static func registerDependencies(in registery: any DependencyInjection.Registry) async {
        let httpClient = DefaultHTTPClient()
        await registery.register(
            type: GetHTTPClient.self,
            dependency: httpClient
        )
    }
    
    public static func registerFactories(in registery: any DependencyInjection.Registry) async {}
    public static func start(with resolver: any DependencyInjection.Resolver) async {}
}
