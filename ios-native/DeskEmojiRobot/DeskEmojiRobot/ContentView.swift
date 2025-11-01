//
//  ContentView.swift
//  DeskEmojiRobot
//
//  Created by Chi on 31.10.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedVersion: AppVersion = .emoji

    enum AppVersion: Hashable {
        case emoji
        case robot
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
        .environmentObject(RobotFaceState())
}
