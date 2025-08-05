import DependencyInjection
import SwiftUICore

public struct NearestStationMapBuilder {
    @ViewBuilder
    public static func build(_ resolver: Resolver) async -> some View {
        await NearestStationMapView(
            viewModel: resolver.resolve(type: NearestStationMapViewModel.self)
        )
    }
}
