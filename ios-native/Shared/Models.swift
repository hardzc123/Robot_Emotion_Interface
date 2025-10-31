import SwiftUI

// MARK: - Emotion Model
struct Emotion: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
    let color: Color
    let animation: EmotionAnimation

    enum EmotionAnimation {
        case pulse, bounce, shake, tilt, sway, none
    }
}

// MARK: - Emotion Data
class EmotionData {
    static let emojiEmotions: [Emotion] = [
        Emotion(id: "happy", name: "Happy", emoji: "😊", color: .yellow, animation: .pulse),
        Emotion(id: "excited", name: "Excited", emoji: "🤩", color: .red, animation: .bounce),
        Emotion(id: "love", name: "Love", emoji: "😍", color: .pink, animation: .pulse),
        Emotion(id: "cool", name: "Cool", emoji: "😎", color: .blue, animation: .none),
        Emotion(id: "thinking", name: "Thinking", emoji: "🤔", color: .purple, animation: .tilt),
        Emotion(id: "confused", name: "Confused", emoji: "😕", color: .orange, animation: .shake),
        Emotion(id: "sad", name: "Sad", emoji: "😢", color: .blue, animation: .sway),
        Emotion(id: "angry", name: "Angry", emoji: "😠", color: .red, animation: .shake),
        Emotion(id: "sleepy", name: "Sleepy", emoji: "😴", color: .gray, animation: .sway),
        Emotion(id: "surprised", name: "Surprised", emoji: "😲", color: .yellow, animation: .bounce),
        Emotion(id: "laugh", name: "Laughing", emoji: "😂", color: .orange, animation: .shake),
        Emotion(id: "wink", name: "Wink", emoji: "😉", color: .pink, animation: .none)
    ]

    static let robotEmotions: [String] = [
        "happy", "sad", "angry", "surprised", "sleepy", "wakeup", "blink", "lookLeft", "lookRight", "center"
    ]
}

// MARK: - Robot Face State
class RobotFaceState: ObservableObject {
    @Published var leftEyeX: CGFloat = 140
    @Published var leftEyeY: CGFloat = 200
    @Published var rightEyeX: CGFloat = 210
    @Published var rightEyeY: CGFloat = 200
    @Published var eyeWidth: CGFloat = 50
    @Published var eyeHeight: CGFloat = 50
    @Published var eyeRadius: CGFloat = 10
    @Published var currentEmotion: String = "center"

    func resetToCenter() {
        leftEyeX = 140
        leftEyeY = 200
        rightEyeX = 210
        rightEyeY = 200
        eyeWidth = 50
        eyeHeight = 50
        eyeRadius = 10
    }
}

// MARK: - Haptic Feedback
class HapticManager {
    static let shared = HapticManager()

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
