import StationFinderDomain

actor MockGetCity: GetCity {
    var cityToReturn: City = .defaultCity
    
    func execute(userLocation: Location?) -> City {
        return cityToReturn
    }
}
