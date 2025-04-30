# COP2664-1-Final-Individual-Project---Memory-Game-App
This is a GitHub repository link for the Final Individual Project for IOS App Programming

import SwiftUI

struct ContentView: View {
    private var fourColumnGrid = Array(repeating: GridItem(.flexible()), count: 4)
    private var sixColumnGrid = Array(repeating: GridItem(.flexible()), count: 6)
    // This structure is used to create a grid layout with 6 columns for the matched cards section.

    @State private var difficulty: Difficulty = .easy
    @State private var selectedTheme = "Fruits"
    @State private var cards: [Card] = []
    @State private var matchedCards = [Card]()
    @State private var userChoices = [Card]() // These arrays are used to keep track of the cards that the user has matched and the cards that the user has chosen.

    @State private var timeRemaining: Int = 90
    @State private var score: Int = 0
    @State private var isGameOver: Bool = false
    @State private var didWin: Bool = false
    @State private var showWinAlert = false // These variables are used to keep track of the game state, including the time remaining, the score, whether the game is over, whether the user won, and whether to show the win alert.

    @AppStorage("highScore") private var highScore = 0
    @State private var showNewHighScoreBanner = false // This variable is used to keep track of whether to show the new high score banner.

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // This timer is used to update the time remaining every second.

    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.ignoresSafeArea() // This sets the background color of the view to orange.

                GeometryReader { geometry in
                    let cardWidth = geometry.size.width / 4 - 10 // This calculates the width of each card based on the size of the screen.

                    ScrollView {
                        VStack(spacing: 15) {
                            Text("🤓 Memory Game 🧐")
                                .font(.largeTitle)
                                .padding() // This sets the title of the game and adds some padding around it.

                            Picker("Difficulty", selection: $difficulty) {
                                ForEach(Difficulty.allCases) { level in
                                    Text(level.rawValue.capitalized)
                                        .tag(level)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal) // This creates a picker for the difficulty level of the game.

                            Picker("Theme", selection: $selectedTheme) {
                                ForEach(themes.keys.sorted(), id: \.self) { theme in
                                    Text(theme)
                                }
                            } // This creates a picker for the theme of the game.
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)

                            HStack {
                                Text("Time: \(timeRemaining)s")
                                Spacer()
                                Text("Score: \(score)")
                                Spacer()
                                Text("High: \(highScore)")
                            } // This displays the time remaining, the score, and the high score.
                            .padding(.horizontal)
                            .font(.headline)

                            if showNewHighScoreBanner {
                                Text("New High Score!")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.green)
                                    .cornerRadius(10)
                                    .transition(.scale)
                            } // This displays a banner if the user has set a new high score.

                            LazyVGrid(columns: fourColumnGrid, spacing: 10) {
                                ForEach(cards) { card in
                                    CardView(
                                        card: card,
                                        width: Int(cardWidth),
                                        matchedCards: $matchedCards,
                                        userChoices: $userChoices,
                                        onMoveMade: checkMove
                                    )
                                    .animation(.easeInOut(duration: 0.3), value: card.isFaceUp)
                                }
                            }
                            .padding() // This creates a grid of cards based on the difficulty level.

                            VStack(spacing: 10) {
                                Text("Match these cards to win")
                                    .font(.headline)

                                LazyVGrid(columns: sixColumnGrid, spacing: 5) {
                                    ForEach(themes[selectedTheme] ?? [], id: \.self) { value in
                                        if !matchedCards.contains(where: { $0.text == value }) {
                                            Text(value)
                                                .font(.system(size: 40))
                                        }
                                    }
                                }
                            }
                            .padding() // This creates a grid of the cards that the user needs to match. It only displays the cards that the user has not yet matched.

                            HStack(spacing: 20) {
                                Button("Restart") {
                                    withAnimation(.easeInOut) {
                                        resetGame()
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8) // This creates a button that restarts the game. It also adds some padding, background color, foreground color, and corner radius to the button.

                                Button("Reset High Score") {
                                    highScore = 0
                                }
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .padding()
                        }
                        .padding(.bottom, 30)
                    } // This creates a scroll view that contains the game content. It also adds some padding to the bottom of the scroll view.

                    if didWin {
                        ConfettiView()
                            .transition(.opacity)
                            .ignoresSafeArea()
                    } // This displays confetti if the user has won the game. It also adds some padding to the bottom of the scroll view.
                }
            }
        }
        .onAppear {
            resetGame()
        }
        .onChange(of: difficulty) { _, _ in
            resetGame()
        }
        .onChange(of: selectedTheme) { _, _ in
            resetGame()
        }
        .onReceive(timer) { _ in
            updateTimer()
        }
        .alert("You Win!", isPresented: $showWinAlert) {
            Button("Play Again") {
                withAnimation {
                    resetGame()
                }
            }
        } message: {
            Text("Congratulations! You matched all the cards!")
        }
        .navigationDestination(isPresented: $isGameOver) {
            ResultView(didWin: didWin, score: score)
        }
    } // This sets up the navigation destination for the game. It also sets up the alert that is displayed when the user wins the game. It also sets up the timer that is used to update the time remaining every second.

    private func resetGame() {
        guard let values = themes[selectedTheme] else { return }
        let selectedValues = Array(values.shuffled().prefix(difficulty.pairCount))
        cards = (selectedValues + selectedValues).map { Card(text: $0) }.shuffled()
        matchedCards.removeAll()
        userChoices.removeAll()
        score = 0
        timeRemaining = timerForDifficulty()
        isGameOver = false
        didWin = false
        showNewHighScoreBanner = false
    } // This function is used to reset the game. It also sets the time remaining based on the difficulty level.

    private func timerForDifficulty() -> Int {
        switch difficulty {
        case .easy: return 90
        case .medium: return 150
        case .hard: return 210
        }
    } // This function is used to set the time remaining based on the difficulty level.

    private func checkMove() {
        if userChoices.count == 2 {
            let first = userChoices[0]
            let second = userChoices[1]
            if first.text == second.text {
                matchedCards.append(first)
                matchedCards.append(second)
                score += 10
            } else {
                score -= 2
            }
        } // This function is used to check if the user has made a move. It also updates the score based on whether the user has matched the cards or not.

        if matchedCards.count == cards.count {
            didWin = true
            isGameOver = true
            showWinAlert = true // This checks if the user has matched all the cards and updates the game state accordingly.

            if score > highScore {
                highScore = score
                withAnimation {
                    showNewHighScoreBanner = true
                } // This checks if the user has matched all the cards and updates the game state accordingly. It also checks if the user has set a new high score and updates the high score banner.
            }
        }
    }

    private func updateTimer() {
        if !isGameOver {
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                isGameOver = true
                didWin = false
            } // This updates the timer and checks if the game is over.
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} // This is the preview provider for the ContentView.
