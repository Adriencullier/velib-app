public actor DependencyContainer: Registry, Resolver {
    private var dependencies: [DependencyKey: Any] = [:]
    
    public init() {}
    
    public func register<T>(type: T.Type, service: Any) {
        dependencies[DependencyKey(type)] = service
    }
    
    public func resolve<T>(type: T.Type) -> T? {
        return dependencies[DependencyKey(type)] as? T
    }
}
