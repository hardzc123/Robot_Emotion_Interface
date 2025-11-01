import SwiftUI
import WatchKit

struct WatchEmojiView: View {
    @State private var currentEmotion: Emotion = EmotionData.emojiEmotions[0]
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0

    // Compact emotion list for watch
    let watchEmotions = [
        "happy", "excited", "love", "sad", "angry", "sleepy", "surprised", "laugh"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Emoji")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 5)

            // Large Emoji Display
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [currentEmotion.color.opacity(0.3), currentEmotion.color.opacity(0.1)],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)

                Text(currentEmotion.emoji)
                    .font(.system(size: 60))
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
            }
            .padding(.vertical, 10)

            // Emotion Name
            Text(currentEmotion.name)
                .font(.headline)
                .foregroundColor(currentEmotion.color)

            // Emotion Selector (Digital Crown)
            EmotionPicker(
                emotions: watchEmotions.compactMap { id in
                    EmotionData.emojiEmotions.first(where: { $0.id == id })
                },
                currentEmotion: $currentEmotion
            )
        }
        .onChange(of: currentEmotion) { _ in
            animateEmotionChange()
            WKInterfaceDevice.current().play(.click)
        }
    }

    private func animateEmotionChange() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            scale = 0.5
            rotation = 360
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.2)) {
            scale = 1.0
            rotation = 0
        }
    }
}

struct EmotionPicker: View {
    let emotions: [Emotion]
    @Binding var currentEmotion: Emotion

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(emotions) { emotion in
                    Button(action: {
                        currentEmotion = emotion
                    }) {
                        HStack {
                            Text(emotion.emoji)
                                .font(.title2)
                            Text(emotion.name)
                                .font(.caption)
                            Spacer()
                            if currentEmotion.id == emotion.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            currentEmotion.id == emotion.id ?
                                emotion.color.opacity(0.2) : Color.clear
                        )
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

#Preview {
    WatchEmojiView()
}
