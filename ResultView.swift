import SwiftUI

struct ResultView: View {
    let didWin: Bool
    let score: Int
    // This structure is used to display the result of the game. It takes two parameters: didWin and score.

    var body: some View {
        VStack(spacing: 20) {
            if didWin {
                Text("You Win!")
                    .font(.largeTitle)
                    .foregroundColor(.green) // This code displays a message if the user won the game.
            } else {
                Text("Time's Up!")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            } // This code checks if the user won or lost the game and displays the appropriate message.

            Text("Score: \(score)")
                .font(.title) // This code displays the user's score.

            NavigationLink("Play Again", destination: ContentView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .navigationBarBackButtonHidden(true)
    }
} // This code creates a button that allows the user to play the game again.

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(didWin: true, score: 100)
    }
} // This code is used to preview the ResultView structure in Xcode.
