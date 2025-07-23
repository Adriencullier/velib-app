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
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    VStack {
                        Image(systemName: "bicycle")
                            .font(.title3)
                            .foregroundStyle(.green)
                        Text("\(station.availableMechanicalBikes)")
                            .font(.subheadline)
                            .foregroundStyle(.green)
                    }
                    VStack {
                        Image(systemName: "bicycle")
                            .font(.title3)
                            .foregroundStyle(.blue)
                        Text("\(station.availableEBikes)")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
                VStack {
                    Image(systemName: "p.circle")
                        .font(.title3)
                        .foregroundStyle(.yellow)
                    Text("\(station.availablePlaces)")
                        .font(.subheadline)
                        .foregroundStyle(.yellow)
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
