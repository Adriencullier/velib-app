import SwiftUI

struct BikeCountView: View {
    private let count: Int
    private let iconName: String
    private let color: Color
    
    init(count: Int,
         iconName: String,
         color: Color) {
        self.count = count
        self.iconName = iconName
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
            
            Text("\(count)")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(color)
        }
    }
}
