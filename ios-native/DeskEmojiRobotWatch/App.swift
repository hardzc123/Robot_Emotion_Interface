import SwiftUI

@main
struct DeskEmojiWatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            EmojiWatchView()
            RobotWatchView()
        }
        .tabViewStyle(.page)
    }
}
