import SwiftUI

@main
struct DeskEmojiRobotApp: App {
    @StateObject private var robotFaceState = RobotFaceState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(robotFaceState)
        }
    }
}

struct ContentView: View {
    @State private var selectedVersion: AppVersion = .emoji

    enum AppVersion {
        case emoji, robot
    }

    var body: some View {
        TabView(selection: $selectedVersion) {
            EmojiVersionView()
                .tabItem {
                    Label("Emoji", systemImage: "face.smiling")
                }
                .tag(AppVersion.emoji)

            RobotFaceVersionView()
                .tabItem {
                    Label("Robot", systemImage: "eye")
                }
                .tag(AppVersion.robot)
        }
    }
}

#Preview {
    ContentView()
}
