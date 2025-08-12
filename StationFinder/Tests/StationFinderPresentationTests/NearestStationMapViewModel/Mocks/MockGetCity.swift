import StationFinderDomain

actor MockGetCity: GetCity {
    private(set) var cityToReturn: City = .defaultCity
    
    func execute(userLocation: Location?) -> City {
        return cityToReturn
    }
    
    func setCityToReturn(_ city: City) {
        self.cityToReturn = city
    }
}
