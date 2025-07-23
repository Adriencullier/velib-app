import SwiftUI

public struct NearestStationListView: View {
    private let viewModel: NearestStationListViewModel
    
    public init(viewModel: NearestStationListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(self.viewModel.nearestStations, id: \.id) { station in
                StationCardView(station: station)
                    .padding(.vertical, 8)
            }
        }
        .refreshable(action: {
            Task {
                try await self.viewModel.onRefresh()
            }
        })
        .navigationTitle("Nearest stations")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(
            content: {
                ToolbarItem(
                    placement: .primaryAction) {
                        Button(
                            "Refresh",
                            systemImage: "arrow.counterclockwise") {
                                Task {
                                    try await self.viewModel.onRefresh()
                                }
                            }
                    }
        })
        .listStyle(.plain)
        .task {
            try? await self.viewModel.onViewTask()
        }
    }
}
