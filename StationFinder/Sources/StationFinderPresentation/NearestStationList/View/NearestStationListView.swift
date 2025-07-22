import SwiftUI

public struct NearestStationListView: View {
    private let viewModel: NearestStationListViewModel
    
    public init(viewModel: NearestStationListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.nearestStations, id: \.id) { station in
                HStack {
                    Text(station.name)
                    Spacer()
                    Text(station.address)
                }
            }
        }
        .task {
            try? await self.viewModel.onViewTask()
        }
    }
}
