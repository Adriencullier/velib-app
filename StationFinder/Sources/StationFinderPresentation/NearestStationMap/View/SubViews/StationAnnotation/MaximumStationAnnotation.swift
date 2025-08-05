import SwiftUI

struct MaximumStationAnnotation: View {
    private let name: String
    private let availableMechanicalBikes: Int
    private let availableEBikes: Int
    private let availablePlaces: Int
    private let onNavigatePress: () -> Void
    
    init(name: String,
         availableMechanicalBikes: Int,
         availableEBikes: Int,
         availablePlaces: Int,
         onNavigatePress: @escaping () -> Void) {
        self.name = name
        self.availableMechanicalBikes = availableMechanicalBikes
        self.availableEBikes = availableEBikes
        self.availablePlaces = availablePlaces
        self.onNavigatePress = onNavigatePress
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .center, spacing: 4) {
                        Text(self.name)
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .medium))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(width: 100)
                            .padding(8)
                        HStack {
                            Spacer()
                            BikeCountView(
                                count: self.availableMechanicalBikes,
                                iconName: "bicycle",
                                color: .green
                            )
                            Spacer()
                            BikeCountView(
                                count: self.availableEBikes,
                                iconName: "bolt.fill",
                                color: .blue
                            )
                            Spacer()
                            BikeCountView(
                                count: self.availablePlaces,
                                iconName: "p.circle.fill",
                                color: .orange
                            )
                            Spacer()
                        }
                        .padding(.bottom, 6)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                }
            }
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 16)
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
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.onNavigatePress()
                    }) {
                        Label("Navigate", systemImage: "arrow.trianglehead.turn.up.right.circle.fill")
                            .labelStyle(.iconOnly)
                            .font(
                                .system(
                                    size: 24,
                                    weight: .semibold
                                )
                            )
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                            .foregroundColor(.white)
                            .shadow(
                                color: .black.opacity(0.3),
                                radius: 2
                            )
                    }
                    Spacer()
                }
            }
            .offset(
                CGSize(
                    width: 14,
                    height: -14
                )
            )            
        }
    }
}
