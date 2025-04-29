import SwiftUI // The framework that the programmer would use to build an app by using SwiftUI.

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Memory Game")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: ContentView()) {
                    Text("Start Game")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color("BackgroundColor").ignoresSafeArea())
        }
    }
} // This the structure for the HomeView which is the first view that the user will see when they open the app. It contains a navigation stack and a VStack with a text and a navigation link to the ContentView.

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
} // This is the preview provider for the HomeView. It allows the programmer to see what the view will look like in the SwiftUI preview canvas.
