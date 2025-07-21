import SwiftUI
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
                }
        }
    }
}
