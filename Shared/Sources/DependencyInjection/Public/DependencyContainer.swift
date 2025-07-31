public actor DependencyContainer: Registry, Resolver {
    private var dependencies: [DependencyKey: Any] = [:]
    private var factories: [DependencyKey: Any] = [:]
    
    public init() {}
    
    public func register<T>(type: T.Type, dependency: Any) {
        dependencies[DependencyKey(type)] = dependency
    }
    
    public func resolve<T: Sendable>(type: T.Type) async -> T {
        // Check if we have a factory for this type
        if let factory = factories[DependencyKey(type)] as? (any Resolver) async -> T {
            // Create a new instance using the factory
            return await factory(self)
        }
        
        // Otherwise resolve from registered dependencies
        guard let dependency = dependencies[DependencyKey(type)] as? T else {
            fatalError("Dependency of type \(type) is not registered")
        }
        return dependency
    }
    
    public func registerFactory<T>(type: T.Type, factory: @escaping (any Resolver) async -> T) async {
        factories[DependencyKey(type)] = factory
    }
}
