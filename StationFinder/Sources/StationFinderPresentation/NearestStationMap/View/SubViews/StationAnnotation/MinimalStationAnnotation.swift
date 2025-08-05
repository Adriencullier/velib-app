import SwiftUI

struct MinimalStationAnnotation: View {
    var body: some View {
        Image(systemName: "bicycle")
            .font(
                .system(size: 10)
            )
            .foregroundStyle(.white)
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
