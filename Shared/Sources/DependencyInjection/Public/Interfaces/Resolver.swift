public protocol Resolver: Actor {
    func resolve<T>(type: T.Type) -> T?
}
