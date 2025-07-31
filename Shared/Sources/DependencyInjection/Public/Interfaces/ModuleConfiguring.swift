public protocol ModuleConfiguring {
    static func registerDependencies(in registery: Registry) async
    static func registerFactories(in registery: Registry) async
    static func start(with resolver: Resolver) async
}
