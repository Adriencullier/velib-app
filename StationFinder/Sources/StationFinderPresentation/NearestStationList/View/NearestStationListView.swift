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
            }
        }
        .listStyle(.plain)
        .task {
            try? await self.viewModel.onViewTask()
        }
    }
}
