import StationFinderDomain

actor MockShowRoute: ShowRoute {
    var executeHasBeenCalled: Bool = false
    var startLocation: Location?
    var destinationLocation: Location?
    
    func execute(from start: Location, to destination: Location) throws {
        self.executeHasBeenCalled = true
        self.startLocation = start
        self.destinationLocation = destination
    }
}
