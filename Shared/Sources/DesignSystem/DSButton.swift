import SwiftUI

public struct DSButton<Content: View>: View {
    @ViewBuilder private let content: () -> Content
    private let action: () -> Void
    private var feedbackGenerator: UIImpactFeedbackGenerator? = nil
    
    public init(feedbackDisabled: Bool = false,
                content: @escaping () -> Content,
                action: @escaping () -> Void) {
        self.content = content
        self.action = action
        
        if !feedbackDisabled {
            self.feedbackGenerator = UIImpactFeedbackGenerator()
            self.feedbackGenerator?.prepare()
        }
    }
    
    public var body: some View {
        Button {
            self.feedbackGenerator?.impactOccurred(intensity: 0.7)
            action()
        } label: {
            content()
        }
    }
}
