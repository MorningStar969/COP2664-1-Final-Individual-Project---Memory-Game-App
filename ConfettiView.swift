import SwiftUI

struct ConfettiView: View {
    @State private var counter = 0 // This is just to trigger the animation on appear and repeat forever animation loop for the confetti particles animation.

    var body: some View {
        VStack {
            Spacer()
            ForEach(0..<30) { _ in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.random)
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -400...400)
                    ) // This is to spread the confetti particles randomly in the view.
            }
            Spacer()
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                counter += 1
            } // This is to animate the confetti particles forever.
        }
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0.3...1),
            green: .random(in: 0.3...1),
            blue: .random(in: 0.3...1)
        ) // This is to generate random colors for the confetti particles.
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiView()
    }
} // This is to preview the confetti view in Xcode.
