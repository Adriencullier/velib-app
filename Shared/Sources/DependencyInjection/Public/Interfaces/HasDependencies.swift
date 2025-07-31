public protocol HasDependencies where Self: Actor {
    func setDependencies(_ dependencies: [Any])
}
