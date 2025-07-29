public actor DependencyContainer: Registry, Resolver {
    private var dependencies: [DependencyKey: Any] = [:]
    
    public init() {}
    
    public func register<T>(type: T.Type, dependency: Any) {
        dependencies[DependencyKey(type)] = dependency
    }
    
    public func resolve<T>(type: T.Type) -> T {
        guard let dependency = dependencies[DependencyKey(type)] as? T else {
            fatalError("Dependency of type \(type) is not registered")
        }
        return dependency
    }
}
