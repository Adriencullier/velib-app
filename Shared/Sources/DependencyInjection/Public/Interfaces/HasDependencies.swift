public protocol HasDependencies where Self: AnyObject & Sendable {
    func setDependencies(_ dependencies: [Any])
}
