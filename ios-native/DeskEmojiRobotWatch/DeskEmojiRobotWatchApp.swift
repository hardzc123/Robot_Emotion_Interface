import SwiftUI

@main
struct DeskEmojiRobotWatch_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            WatchContentView()
        }
    }
}

struct WatchContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            WatchEmojiView()
                .tag(0)

            WatchRobotView()
                .tag(1)
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    WatchContentView()
}
