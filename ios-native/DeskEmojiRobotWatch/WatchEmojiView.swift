import SwiftUI
import WatchKit

struct WatchEmojiView: View {
    private let emotionIDs: [String] = ["happy", "excited", "love", "cool", "surprised", "wink", "sleepy", "angry"]
    private lazy var emotions: [Emotion] = emotionIDs.compactMap { id in
        EmotionData.emojiEmotions.first(where: { $0.id == id })
    }

    @State private var selection: Int = 0
    @State private var iconScale: CGFloat = 1.0
    @State private var iconRotation: Double = 0
    @State private var sparkle = false

    private var currentEmotion: Emotion {
        guard !emotions.isEmpty else { return EmotionData.emojiEmotions[0] }
        let upperBound = emotions.index(before: emotions.endIndex)
        let safeIndex = min(max(selection, emotions.startIndex), upperBound)
        return emotions[safeIndex]
    }

    var body: some View {
        VStack(spacing: 10) {
            header

            heroCard

            statusRow

            emotionPicker

            quickActions
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
        .onAppear(perform: animateEntry)
        .onChange(of: selection) { _ in selectionChanged() }
    }
}

private extension WatchEmojiView {
    var header: some View {
        HStack {
            Label {
                Text("Emoji Mood")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: "face.smiling")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
            }

            Spacer()

            Text(currentEmotion.name.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(currentEmotion.color)
        }
    }

    var heroCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            currentEmotion.color.opacity(0.55),
                            currentEmotion.color.opacity(0.25)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    AngularGradient(
                        colors: [
                            currentEmotion.color.opacity(0.25),
                            .clear,
                            currentEmotion.color.opacity(0.25),
                            .clear
                        ],
                        center: .center
                    )
                    .opacity(sparkle ? 0.6 : 0.2)
                )

            Text(currentEmotion.emoji)
                .font(.system(size: 68))
                .scaleEffect(iconScale)
                .rotationEffect(.degrees(iconRotation))
                .shadow(color: currentEmotion.color.opacity(0.35), radius: 8, x: 0, y: 4)
        }
        .frame(height: 120)
        .animation(.spring(response: 0.35, dampingFraction: 0.65), value: currentEmotion.id)
    }

    var statusRow: some View {
        HStack(spacing: 6) {
            MoodBadge(title: "Energy", value: energyLevel, tint: currentEmotion.color)
            MoodBadge(title: "Vibes", value: vibeScore, tint: .blue.opacity(0.8))
        }
    }

    var emotionPicker: some View {
        Picker("Emoji", selection: $selection) {
            ForEach(emotions.indices, id: \.self) { index in
                Text(emotions[index].emoji + " " + emotions[index].name)
                    .tag(index)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 68)
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.15))
        )
    }

    var quickActions: some View {
        HStack(spacing: 8) {
            QuickActionButton(
                label: "Shuffle",
                systemImage: "sparkles",
                tint: .purple.opacity(0.85),
                action: shuffleEmotion
            )

            QuickActionButton(
                label: "Calm",
                systemImage: "moon.zzz",
                tint: .teal.opacity(0.85),
                action: { setEmotion(withID: "sleepy") }
            )
        }
        .padding(.bottom, 2)
    }

    var energyLevel: Double {
        switch currentEmotion.id {
        case "happy", "excited", "love", "laugh": return 0.92
        case "surprised", "cool": return 0.78
        case "wink": return 0.65
        case "angry": return 0.55
        case "sleepy": return 0.25
        default: return 0.5
        }
    }

    var vibeScore: Double {
        switch currentEmotion.id {
        case "love", "happy": return 0.95
        case "cool", "wink": return 0.8
        case "excited", "surprised": return 0.7
        case "angry": return 0.35
        case "sleepy": return 0.4
        default: return 0.5
        }
    }

    func animateEntry() {
        sparkle = true
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
            sparkle.toggle()
        }
    }

    func selectionChanged() {
        WKInterfaceDevice.current().play(.directionUp)
        withAnimation(.spring(response: 0.25, dampingFraction: 0.55)) {
            iconScale = 0.82
            iconRotation = -10
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6).delay(0.08)) {
            iconScale = 1.0
            iconRotation = 0
        }
    }

    func shuffleEmotion() {
        guard emotions.count > 1 else { return }
        var nextIndex = selection
        while nextIndex == selection {
            nextIndex = Int.random(in: emotions.indices)
        }
        selection = nextIndex
    }

    func setEmotion(withID id: String) {
        if let index = emotions.firstIndex(where: { $0.id == id }) {
            selection = index
        }
    }
}

private extension WatchEmojiView {
    struct MoodBadge: View {
        let title: String
        let value: Double
        let tint: Color

        var body: some View {
            VStack(spacing: 4) {
                Text(title.uppercased())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Gauge(value: value) {
                    EmptyView()
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(tint)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.12))
            )
        }
    }

    struct QuickActionButton: View {
        let label: String
        let systemImage: String
        let tint: Color
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                VStack(spacing: 4) {
                    Image(systemName: systemImage)
                        .font(.headline.weight(.semibold))
                    Text(label)
                        .font(.caption2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(tint.opacity(0.2))
                )
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    WatchEmojiView()
}
