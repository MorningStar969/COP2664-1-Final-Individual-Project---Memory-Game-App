import Foundation
import SwiftUI
// This is the file that contains the main code for the memory card game.

class Card: Identifiable, ObservableObject {
    var id = UUID()
    @Published var isFaceUp: Bool = false
    @Published var isMatched: Bool = false
    var text: String
    // This is the class that represents a card in the memory card game.
    
    init (text: String) {
        self.text = text
    } // This is the initializer for the Card class.
    
    func turnFaceUp() {
        self.isFaceUp.toggle()
    }
} // This is the function that turns a card face up.

let cardValues : [String] = [
    "🍎", "🍓", "🍊", "🍋", "🍌", "🍉", "🍇", "🍒", "🍑", "🍐", "🥝", "🫐"
] // This is the array that contains the values of the cards in the memory card game.

func createCardList() -> [Card] {
    var cardList : [Card] = []
    for cardValue in cardValues {
        cardList.append(Card(text: cardValue))
        cardList.append(Card(text: cardValue))
    } // This is the function that returns the list of cards in the memory card game.
    
    return cardList
} // This is the card that is face down in the memory card game.

let faceDownCard = Card(text: "?")

struct MemoryView: View {
    var body: some View {
        Text("Hello, Memory Card Game!")
    }
} // This is the view that displays the memory card game.

struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryView()
    }
} // This is the preview provider for the memory card game.
