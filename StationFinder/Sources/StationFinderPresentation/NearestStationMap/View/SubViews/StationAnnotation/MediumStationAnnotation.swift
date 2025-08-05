import SwiftUI

struct MediumStationAnnotation: View {
    private let allAvailableBikes: Int
    private let stationCapacity: Int
    
    init(allAvailableBikes: Int, stationCapacity: Int) {
        self.allAvailableBikes = allAvailableBikes
        self.stationCapacity = stationCapacity
    }
    
    var body: some View {
        HStack {
            Image(systemName: "bicycle")
                .font(
                    .system(size: 10)
                )
                .foregroundStyle(.white)
            Text(
                String(self.allAvailableBikes)
                + " / "
                + String(self.stationCapacity)
            )
            .font(
                .system(
                    size: 10,
                    weight: .bold
                )
            )
            .foregroundStyle(.white)
        }
        .padding(8)
        .background {
            Capsule()
                .fill(
                    Color.black.opacity(0.75)
                )
                .strokeBorder(
                    Color.gray.opacity(0.3),
                    lineWidth: 0.5
                )
                .shadow(
                    color: .black.opacity(0.4),
                    radius: 2,
                    x: 0,
                    y: 1
                )
        }
    }
}
