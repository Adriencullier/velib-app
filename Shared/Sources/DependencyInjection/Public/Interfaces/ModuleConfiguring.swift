public protocol ModuleConfiguring {
    static func registerImplementations(in registery: Registry) async
    static func start(with resolver: Resolver) async 
}
