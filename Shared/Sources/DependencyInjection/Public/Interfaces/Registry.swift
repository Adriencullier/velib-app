public protocol Registry: Actor {
    func register<T>(type: T.Type, service: Any)
}
