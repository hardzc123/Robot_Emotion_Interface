import SwiftUI

@main
struct DeskEmojiRobotWatchApp: App {
    var body: some Scene {
        WindowGroup {
            WatchHomeView()
        }
    }
}

struct WatchHomeView: View {
    @State private var selectedTab: WatchTab = .emoji

    enum WatchTab: Hashable {
        case emoji
        case robot
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            WatchEmojiView()
                .tag(WatchTab.emoji)

            WatchRobotView()
                .tag(WatchTab.robot)
        }
        .tabViewStyle(.verticalPage)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    WatchHomeView()
}
