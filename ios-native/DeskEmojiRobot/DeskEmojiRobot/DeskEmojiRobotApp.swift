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
