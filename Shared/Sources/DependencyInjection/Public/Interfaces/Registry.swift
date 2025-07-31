public protocol Registry: Actor {
    func register<T>(type: T.Type, dependency: Any)
    func registerFactory<T>(type: T.Type, factory: @escaping (Resolver) async -> T) async
}
