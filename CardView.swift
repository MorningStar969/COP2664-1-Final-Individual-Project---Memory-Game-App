import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card
    let width: Int
    @Binding var matchedCards: [Card]
    @Binding var userChoices: [Card]
    // This structure represents a card in the game. It has properties for the text displayed on the card, whether the card is face up, and its unique identifier. It also has methods for turning the card face up and down.
    
    var onMoveMade: () -> Void // This is a callback for when a move is made (2 cards are chosen) - this will be used to update the game state in the parent view.

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(card.isFaceUp || matchedCards.contains(where: { $0.id == card.id }) ? Color("CardFront") : Color("CardBack"))
                .frame(width: CGFloat(width), height: CGFloat(width)) // This sets the frame size based on the width property passed to the view.
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 4)
                ) // This add a blue border to the card.
                .rotation3DEffect(
                    .degrees(card.isFaceUp ? 0 : 180),
                    axis: (x: 0, y: 1, z: 0)
                ) // This rotate the card 180 degrees around the y-axis when it is face down.
                .animation(.easeInOut(duration: 0.3), value: card.isFaceUp) // This add an animation to the rotation effect.

            if card.isFaceUp || matchedCards.contains(where: { $0.id == card.id }) {
                Text(card.text)
                    .font(.system(size: 40))
                    .transition(.scale)
            } else {
                Text("?")
                    .font(.system(size: 40))
            }
        } // This adds a text view to display the text on the card. If the card is face up or has been matched, display the text. Otherwise, display a question mark.
        .onTapGesture {
            handleTap()
        }
    } // This adds a tap gesture recognizer to the card. When the card is tapped, call the handleTap() method.
    
    func handleTap() {
        if userChoices.count < 2 && !card.isFaceUp {
            card.turnFaceUp()
            userChoices.append(card)
            if userChoices.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    onMoveMade()
                    userChoices.removeAll()
                } // This delay the call to onMoveMade() by 0.5 seconds, so that the user can see the second card before the game state is updated.
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var matchedCards: [Card] = []
    @State static var userChoices: [Card] = []
    @StateObject static var previewCard = Card(text: "🍎") // This is a preview provider for the CardView. It creates a preview card and sets up the matchedCards and userChoices state variables.

    static var previews: some View {
        CardView(
            card: previewCard,
            width: 100,
            matchedCards: $matchedCards,
            userChoices: $userChoices,
            onMoveMade: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
} // This creates a preview of the CardView with the preview card.
