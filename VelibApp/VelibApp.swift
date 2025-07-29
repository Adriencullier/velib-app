import SwiftUI
import DependencyInjection
import StationFinderPresentation

@main
struct VelibApp: App {
    private let container: (Registry & Resolver) = DependencyContainer()
    
    @State var nearestListView: AnyView?
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if let nearestListView = self.nearestListView {
                    nearestListView
                } else {
                    ProgressView()
                }
            }
            .task {
                await ModulesConfiguration.configureModules(
                    container: self.container
                )
                await self.setupRootView()
            }
        }
    }
    
    private func setupRootView() async {
        self.nearestListView = AnyView(
            await NearestStationListBuilder.build(self.container)
        )
    }
}
