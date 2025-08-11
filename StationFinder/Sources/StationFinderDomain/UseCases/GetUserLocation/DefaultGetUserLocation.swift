import DependencyInjection

public actor DefaultGetUserLocation: GetUserLocation, HasDependencies {
    weak var getUserLocationRepository: GetUserLocationRepository?
    
    public init() {}
    
    public func execute() async -> Location? {
        guard let getUserLocationRepository = self.getUserLocationRepository else {
            fatalError("GetUserLocationRepository is not set")
        }
        return await getUserLocationRepository.getUserLocation()
    }
    
    public func setDependencies(_ dependencies: [Any]) {
        self.getUserLocationRepository = dependencies.first(where: { $0 is GetUserLocationRepository }) as? GetUserLocationRepository
    }
}
