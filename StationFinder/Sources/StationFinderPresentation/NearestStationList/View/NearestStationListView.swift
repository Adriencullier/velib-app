//import SwiftUI
//
//struct NearestStationListView: View {
//    private let viewModel: NearestStationListViewModel
//    
//    init(viewModel: NearestStationListViewModel) {
//        self.viewModel = viewModel
//    }
//    
//    var body: some View {
//        Group {
//            if self.viewModel.nearestStations.isEmpty {
//                ProgressView()
//            } else {
//                List {
//                    ForEach(self.viewModel.nearestStations, id: \.id) { station in
//                        Button(action: {
//                            self.viewModel.onCardPress(station)
//                        }) {
//                            StationCardView(station: station)
//                                .contentShape(Rectangle())
//                                .padding(.vertical, 8)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        .listRowSeparator(.hidden)
//                    }
//                }
//                .refreshable(action: {
//                    Task {
//                        try await self.viewModel.onRefresh()
//                    }
//                })
//            }
//        }        
//        .navigationTitle("Velib' à proximité")
//        .navigationBarTitleDisplayMode(.large)
//        .toolbar(
//            content: {
//                ToolbarItem(
//                    placement: .primaryAction) {
//                        Button(
//                            "Refresh",
//                            systemImage: "arrow.counterclockwise") {
//                                Task {
//                                    try await self.viewModel.onRefresh()
//                                }
//                            }
//                    }
//            })
//        .listStyle(.plain)
//        .task {
//            try? await self.viewModel.onViewTask()
//        }
//    }
//}
