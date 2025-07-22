import SwiftUI
import StationFinderDomain
import DependencyInjection

@main
struct VelibApp: App {
    private let container: (Registry & Resolver) = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await ModulesConfiguration.configureModules(
                        container: self.container
                    )
                    let useCase = await DefaultGetNearestStations(
                        getAllStationsRepository: container.resolve(type: GetAllStationsRepository.self)!
                    )
                    
                        do {
                            print(
                            try await useCase.execute(
                                longitude: 2.2966292757562434,
                                latitude: 48.962740476048246
                            )
                            )
                        } catch {
                            print(error.localizedDescription)
                        }
                }
        }
    }
}
