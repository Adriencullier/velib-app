import SwiftUI

struct StationCardView: View {
    let station: StationModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading) {
                Text(station.name)
                    .font(.subheadline)
                    .lineLimit(2)
                Text("\(station.distance) (\(station.city))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Divider()
            HStack(spacing: 12) {
                VStack {
                    Image(systemName: "bicycle")
                        .font(.title2)
                    Text("\(station.availableBikes)")
                        .font(.headline)
                }
                VStack {
                    Image(systemName: "p.circle")
                        .font(.title2)
                    Text("\(station.availablePlaces)")
                        .font(.headline)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .listRowSeparator(.hidden)
        .frame(height: 100)
    }
}
