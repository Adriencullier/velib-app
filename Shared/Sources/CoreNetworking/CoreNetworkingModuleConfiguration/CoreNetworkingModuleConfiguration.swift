import DependencyInjection

public struct CoreNetworkingModuleConfiguration: ModuleConfiguring {
    public static func registerImplementations(in registery: any DependencyInjection.Registry) async {
        let httpClient = DefaultHTTPClient()
        await registery.register(
            type: GetHTTPClient.self,
            service: httpClient
        )
    }
    
    public static func start(with resolver: any DependencyInjection.Resolver) async {}
}
