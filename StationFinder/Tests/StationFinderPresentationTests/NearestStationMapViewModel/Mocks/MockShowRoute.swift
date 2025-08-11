import StationFinderDomain

actor MockShowRoute: ShowRoute {
    var executeCallCount = 0
    var error: Error?
    
    func execute(from start: Location, to destination: Location) throws {
        executeCallCount += 1
        if let error = error {
            throw error
        }
    }
}
