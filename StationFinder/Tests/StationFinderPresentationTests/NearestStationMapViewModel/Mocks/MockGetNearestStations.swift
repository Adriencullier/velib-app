import StationFinderDomain

actor MockGetNearestStations: GetNearestStations {
    var executeCalled = false
    var stationsToReturn: [StationFinderDomain.Station] = []
    var error: Error?
    
    func execute(longitude: Double, latitude: Double, city: City) async throws -> [StationFinderDomain.Station] {
        executeCalled = true
        if let error = error {
            throw error
        }
        return stationsToReturn
    }
}
