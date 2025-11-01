import SwiftUI

struct EmojiVersionView: View {
    @State private var currentEmotion: Emotion = EmotionData.emojiEmotions[0]
    @State private var isAnimating = false
    @State private var tiltX: Double = 0
    @State private var tiltY: Double = 0
    @State private var animationMode: AnimationMode = .none
    @State private var animationTimer: Timer?

    enum AnimationMode {
        case none, idle, random, expressive
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 5) {
                        Text("🤖 Desk-Emoji Robot")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)

                        Text("Vivid Robot Emotions")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("EMOJI VERSION")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.yellow)
                    }
                    .padding(.top, 20)

                    // Emoji Display
                    EmojiDisplayView(emotion: currentEmotion, tiltX: tiltX, tiltY: tiltY)
                        .frame(height: 300)
                        .padding()

                    // Emotion Grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Emotion")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            ForEach(EmotionData.emojiEmotions) { emotion in
                                EmotionButton(
                                    emotion: emotion,
                                    isSelected: currentEmotion.id == emotion.id
                                ) {
                                    selectEmotion(emotion)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(20)
                    .padding(.horizontal)

                    // Gimbal Control
                    VStack(spacing: 10) {
                        Text("Gimbal Control")
                            .font(.headline)

                        GimbalControlView(tiltX: $tiltX, tiltY: $tiltY)
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(20)
                    .padding(.horizontal)

                    // Animation Modes
                    VStack(spacing: 10) {
                        Text("Animation Mode")
                            .font(.headline)

                        HStack(spacing: 10) {
                            AnimationModeButton(
                                title: "🌀 Idle",
                                isActive: animationMode == .idle
                            ) {
                                toggleAnimationMode(.idle)
                            }

                            AnimationModeButton(
                                title: "🎲 Random",
                                isActive: animationMode == .random
                            ) {
                                toggleAnimationMode(.random)
                            }

                            AnimationModeButton(
                                title: "✨ Express",
                                isActive: animationMode == .expressive
                            ) {
                                toggleAnimationMode(.expressive)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .onDisappear {
            stopAnimation()
        }
    }

    private func selectEmotion(_ emotion: Emotion) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            currentEmotion = emotion
        }
        HapticManager.shared.impact(style: .medium)
        stopAnimation()
    }

    private func toggleAnimationMode(_ mode: AnimationMode) {
        if animationMode == mode {
            stopAnimation()
        } else {
            startAnimation(mode: mode)
        }
        HapticManager.shared.selection()
    }

    private func startAnimation(mode: AnimationMode) {
        stopAnimation()
        animationMode = mode

        switch mode {
        case .idle:
            animationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 2.0)) {
                    tiltX = Double.random(in: -10...10)
                    tiltY = Double.random(in: -10...10)
                }
            }

        case .random:
            animationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                withAnimation {
                    currentEmotion = EmotionData.emojiEmotions.randomElement()!
                }
            }

        case .expressive:
            let expressiveEmotions = ["excited", "happy", "love", "cool", "wink", "laugh"]
            var index = 0
            animationTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                let emotionId = expressiveEmotions[index]
                if let emotion = EmotionData.emojiEmotions.first(where: { $0.id == emotionId }) {
                    withAnimation {
                        currentEmotion = emotion
                    }
                }
                index = (index + 1) % expressiveEmotions.count
            }

        case .none:
            break
        }
    }

    private func stopAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
        animationMode = .none
        withAnimation {
            tiltX = 0
            tiltY = 0
        }
    }
}

// MARK: - Emoji Display View
struct EmojiDisplayView: View {
    let emotion: Emotion
    let tiltX: Double
    let tiltY: Double

    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [emotion.color.opacity(0.3), emotion.color.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 10
                )
                .frame(width: 250, height: 250)

            // Inner circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2a2a2a"), Color(hex: "1a1a1a")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 230, height: 230)
                .shadow(color: emotion.color.opacity(0.5), radius: 30, x: 0, y: 0)

            // Emoji
            Text(emotion.emoji)
                .font(.system(size: 120))
                .scaleEffect(scale)
        }
        .rotation3DEffect(
            .degrees(tiltX),
            axis: (x: 1, y: 0, z: 0)
        )
        .rotation3DEffect(
            .degrees(tiltY),
            axis: (x: 0, y: 1, z: 0)
        )
        .onAppear {
            startAnimation()
        }
        .onChange(of: emotion.id) {
            startAnimation()
        }
    }

    private func startAnimation() {
        withAnimation(.easeInOut(duration: 0.3)) {
            scale = 0.5
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5).delay(0.3)) {
            scale = 1.0
        }

        // Apply specific animation
        switch emotion.animation {
        case .pulse:
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                scale = 1.1
            }
        case .bounce:
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                scale = 1.15
            }
        default:
            break
        }
    }
}

// MARK: - Emotion Button
struct EmotionButton: View {
    let emotion: Emotion
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text(emotion.emoji)
                    .font(.system(size: 40))
                Text(emotion.name)
                    .font(.caption)
                    .bold()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                isSelected ?
                    LinearGradient(
                        colors: [emotion.color, emotion.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(15)
            .shadow(color: isSelected ? emotion.color.opacity(0.5) : .clear, radius: 10, x: 0, y: 5)
        }
    }
}

// MARK: - Gimbal Control View
struct GimbalControlView: View {
    @Binding var tiltX: Double
    @Binding var tiltY: Double

    var body: some View {
        VStack(spacing: 10) {
            // Up
            GimbalButton(icon: "arrow.up") {
                withAnimation { tiltX = -20 }
                HapticManager.shared.impact(style: .light)
            }

            HStack(spacing: 10) {
                // Left
                GimbalButton(icon: "arrow.left") {
                    withAnimation { tiltY = -20 }
                    HapticManager.shared.impact(style: .light)
                }

                // Center
                GimbalButton(icon: "circle") {
                    withAnimation {
                        tiltX = 0
                        tiltY = 0
                    }
                    HapticManager.shared.impact(style: .light)
                }

                // Right
                GimbalButton(icon: "arrow.right") {
                    withAnimation { tiltY = 20 }
                    HapticManager.shared.impact(style: .light)
                }
            }

            // Down
            GimbalButton(icon: "arrow.down") {
                withAnimation { tiltX = 20 }
                HapticManager.shared.impact(style: .light)
            }
        }
    }
}

struct GimbalButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
        }
    }
}

// MARK: - Animation Mode Button
struct AnimationModeButton: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isActive ?
                        LinearGradient(
                            colors: [.green, .green.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                )
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}

#Preview {
    EmojiVersionView()
}
