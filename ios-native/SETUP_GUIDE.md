# 🔧 Fix: Creating the Xcode Project Properly

## ⚠️ Issue
The .pbxproj file is invalid and Xcode can't open it.

## ✅ Solution: Create Project in Xcode (5 minutes)

Follow these steps to create a proper Xcode project and add our Swift files:

---

### Step 1: Create New iOS App Project

1. **Open Xcode** (if not installed: [Get it here](https://apps.apple.com/app/xcode/id497799835))

2. **Create new project:**
   - File > New > Project
   - Choose **iOS** tab
   - Select **App** template
   - Click **Next**

3. **Configure project:**
   - **Product Name:** `DeskEmojiRobot`
   - **Team:** Select your Apple ID
   - **Organization Identifier:** `com.yourname.deskemoji` (or your own)
   - **Interface:** `SwiftUI`
   - **Language:** `Swift`
   - **Storage:** `None`
   - Uncheck "Include Tests"
   - Click **Next**

4. **Save location:**
   - Navigate to: `Robot_Emotion_Interface/ios-native/`
   - **IMPORTANT:** Delete the existing `DeskEmojiRobot.xcodeproj` folder first!
   - Click **Create**

---

### Step 2: Add Shared Files

1. **Create Shared group:**
   - Right-click on `DeskEmojiRobot` folder in project navigator
   - New Group
   - Name it: `Shared`

2. **Add Models.swift:**
   - Right-click on `Shared` group
   - Add Files to "DeskEmojiRobot"...
   - Navigate to: `ios-native/Shared/Models.swift`
   - Check ✅ "Copy items if needed"
   - Target: Check ✅ `DeskEmojiRobot`
   - Click **Add**

---

### Step 3: Replace ContentView

1. **Delete the default ContentView.swift:**
   - Select `ContentView.swift` in project navigator
   - Press Delete
   - Choose "Move to Trash"

2. **Add our view files:**
   - Right-click on `DeskEmojiRobot` folder
   - Add Files to "DeskEmojiRobot"...
   - Navigate to: `ios-native/DeskEmojiRobot/`
   - Select these files (⌘-click to multi-select):
     - `EmojiVersionView.swift`
     - `RobotFaceVersionView.swift`
   - Check ✅ "Copy items if needed"
   - Target: Check ✅ `DeskEmojiRobot`
   - Click **Add**

3. **Update the app file:**
   - Open `DeskEmojiRobotApp.swift` (the one Xcode created)
   - Replace its contents with the file from: `ios-native/DeskEmojiRobot/DeskEmojiRobotApp.swift`
   - Or just copy the code below:

```swift
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
```

---

### Step 4: Add watchOS App (Optional but Recommended)

1. **Add watch target:**
   - File > New > Target
   - Choose **watchOS** tab
   - Select **Watch App**
   - Click **Next**

2. **Configure watch app:**
   - **Product Name:** `DeskEmojiRobotWatch`
   - **Language:** `Swift`
   - **User Interface:** `SwiftUI`
   - Click **Finish**
   - When asked about scheme: Click **Activate**

3. **Add watch files:**
   - Find the `DeskEmojiRobotWatch` group in project navigator
   - Delete the default `ContentView.swift`
   - Right-click on `DeskEmojiRobotWatch` group
   - Add Files to "DeskEmojiRobotWatch"...
   - Navigate to: `ios-native/DeskEmojiRobotWatch/`
   - Select all 3 files:
     - `DeskEmojiRobotWatchApp.swift`
     - `WatchEmojiView.swift`
     - `WatchRobotView.swift`
   - **IMPORTANT:** Check ✅ target `DeskEmojiRobotWatch` (not iOS target!)
   - Click **Add**

4. **Add Models to watch target:**
   - Select `Models.swift` in project navigator
   - In File Inspector (right panel), check ✅ `DeskEmojiRobotWatch` target
   - Now Models.swift is shared between iOS and watchOS

---

### Step 5: Update Info.plist (iOS)

1. **Select iOS target:**
   - Click on `DeskEmojiRobot` project (blue icon at top)
   - Select `DeskEmojiRobot` target (under Targets)

2. **Update display name:**
   - Go to **Info** tab
   - Find "Bundle display name" or add it
   - Set value: `Desk-Emoji`

3. **Set supported orientations:**
   - Still in **Info** tab
   - Find "Supported interface orientations"
   - Keep: Portrait, Landscape Left, Landscape Right

---

### Step 6: Build and Run!

1. **Select iOS simulator:**
   - Top toolbar: Choose `DeskEmojiRobot` scheme
   - Choose device: `iPhone 15 Pro` (or any)

2. **Build:**
   - Click Run button (▶) or press `Cmd+R`
   - Wait for build (~30 seconds first time)
   - App should launch in simulator! 🎉

3. **Test watch app:**
   - Change scheme to `DeskEmojiRobotWatch`
   - Select a watch simulator
   - Click Run (▶)
   - Watch app launches! ⌚

---

### Step 7: Test on Real Device

1. **Connect iPhone via USB**

2. **Trust developer certificate:**
   - First run will ask you to trust
   - On iPhone: Settings > General > VPN & Device Management
   - Trust your developer certificate

3. **Select your iPhone** from device menu

4. **Run** - App installs on your iPhone! 📱

---

## ✅ Done!

Your native iOS and watchOS apps are now properly set up and running!

---

## 🐛 Troubleshooting

### "Cannot find 'Emotion' in scope"
- Make sure `Models.swift` is added to both targets

### "No such module 'SwiftUI'"
- Make sure iOS Deployment Target is 17.0+ (Project Settings > General)

### Build errors in Canvas code
- Canvas requires iOS 17+, make sure deployment target is set correctly

### Watch app won't install
- Make sure watch is paired and unlocked
- Try restarting both iPhone and Watch

### "Signing requires a development team"
- Xcode > Preferences > Accounts
- Add your Apple ID
- Select team in project settings

---

## 📝 Project Structure Should Look Like:

```
DeskEmojiRobot (project)
├── DeskEmojiRobot (iOS target)
│   ├── DeskEmojiRobotApp.swift
│   ├── EmojiVersionView.swift
│   ├── RobotFaceVersionView.swift
│   └── Assets.xcassets
├── DeskEmojiRobotWatch (watchOS target)
│   ├── DeskEmojiRobotWatchApp.swift
│   ├── WatchEmojiView.swift
│   ├── WatchRobotView.swift
│   └── Assets.xcassets
└── Shared
    └── Models.swift (both targets checked)
```

---

## 🎉 Next Steps

Now you can:
- ✅ Run on iPhone simulator
- ✅ Run on Apple Watch simulator
- ✅ Install on real devices
- ✅ Customize the code
- ✅ Build for App Store

Check [NATIVE_IOS_GUIDE.md](../NATIVE_IOS_GUIDE.md) for more details!
