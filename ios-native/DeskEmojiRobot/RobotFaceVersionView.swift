import SwiftUI

struct RobotFaceVersionView: View {
    @EnvironmentObject var robotState: RobotFaceState
    @State private var currentEmotion: String = "center"
    @State private var tiltX: Double = 0
    @State private var tiltY: Double = 0
    @State private var animationMode: AnimationMode = .none
    @State private var animationTimer: Timer?

    enum AnimationMode {
        case none, idle, random, expressive
    }

    var body: some View {
        ZStack {
            // Background gradient - dark theme
            LinearGradient(
                colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
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

                        Text("Authentic Robot Faces")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("ROBOT FACE VERSION")
                            .font(.caption)
                            .bold()
                            .foregroundColor(Color(hex: "4ecca3"))
                    }
                    .padding(.top, 20)

                    // Robot Face Display
                    RobotFaceCanvas(
                        emotion: currentEmotion,
                        robotState: robotState,
                        tiltX: tiltX,
                        tiltY: tiltY
                    )
                    .frame(width: 300, height: 300)
                    .padding()

                    // Emotion Grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Robot Emotion")
                            .font(.headline)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            RobotEmotionButton(title: "😊 Happy", emotion: "happy", isSelected: currentEmotion == "happy") {
                                selectEmotion("happy")
                            }
                            RobotEmotionButton(title: "😢 Sad", emotion: "sad", isSelected: currentEmotion == "sad") {
                                selectEmotion("sad")
                            }
                            RobotEmotionButton(title: "😠 Angry", emotion: "angry", isSelected: currentEmotion == "angry") {
                                selectEmotion("angry")
                            }
                            RobotEmotionButton(title: "😲 Surprised", emotion: "surprised", isSelected: currentEmotion == "surprised") {
                                selectEmotion("surprised")
                            }
                            RobotEmotionButton(title: "😴 Sleepy", emotion: "sleepy", isSelected: currentEmotion == "sleepy") {
                                selectEmotion("sleepy")
                            }
                            RobotEmotionButton(title: "👀 Wakeup", emotion: "wakeup", isSelected: currentEmotion == "wakeup") {
                                selectEmotion("wakeup")
                            }
                            RobotEmotionButton(title: "😑 Blink", emotion: "blink", isSelected: currentEmotion == "blink") {
                                selectEmotion("blink")
                            }
                            RobotEmotionButton(title: "👈 Left", emotion: "lookLeft", isSelected: currentEmotion == "lookLeft") {
                                selectEmotion("lookLeft")
                            }
                            RobotEmotionButton(title: "👉 Right", emotion: "lookRight", isSelected: currentEmotion == "lookRight") {
                                selectEmotion("lookRight")
                            }
                            RobotEmotionButton(title: "😐 Center", emotion: "center", isSelected: currentEmotion == "center") {
                                selectEmotion("center")
                            }
                        }
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
                                title: "🌀 Blink",
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

    private func selectEmotion(_ emotion: String) {
        currentEmotion = emotion
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
            animationTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                currentEmotion = "blink"
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    currentEmotion = "center"
                }
            }

        case .random:
            animationTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
                currentEmotion = EmotionData.robotEmotions.randomElement()!
            }

        case .expressive:
            let sequence = ["wakeup", "happy", "surprised", "lookLeft", "lookRight", "happy"]
            var index = 0
            animationTimer = Timer.scheduledTimer(withTimeInterval: 1.8, repeats: true) { _ in
                currentEmotion = sequence[index]
                index = (index + 1) % sequence.count
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

// MARK: - Robot Face Canvas
struct RobotFaceCanvas: View {
    let emotion: String
    @ObservedObject var robotState: RobotFaceState
    let tiltX: Double
    let tiltY: Double

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .stroke(Color(hex: "4ecca3").opacity(0.3), lineWidth: 10)
                .frame(width: 280, height: 280)

            // Inner circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "2a2a2a"), Color(hex: "1a1a1a")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 260, height: 260)
                .shadow(color: Color(hex: "4ecca3").opacity(0.5), radius: 30, x: 0, y: 0)

            // Robot face drawing
            RobotFaceShape(emotion: emotion, robotState: robotState)
                .frame(width: 260, height: 260)
        }
        .rotation3DEffect(
            .degrees(tiltX),
            axis: (x: 1, y: 0, z: 0)
        )
        .rotation3DEffect(
            .degrees(tiltY),
            axis: (x: 0, y: 1, z: 0)
        )
    }
}

// MARK: - Robot Face Shape
struct RobotFaceShape: View {
    let emotion: String
    @ObservedObject var robotState: RobotFaceState

    var body: some View {
        Canvas { context, size in
            // Scale factor to fit in the view
            let scale = size.width / 400

            // Reset to center first
            if emotion != robotState.currentEmotion {
                robotState.currentEmotion = emotion
                applyEmotion(emotion)
            }

            // Draw eyes
            drawEye(
                context: context,
                x: robotState.leftEyeX * scale,
                y: robotState.leftEyeY * scale,
                width: robotState.eyeWidth * scale,
                height: robotState.eyeHeight * scale,
                radius: robotState.eyeRadius * scale
            )

            drawEye(
                context: context,
                x: robotState.rightEyeX * scale,
                y: robotState.rightEyeY * scale,
                width: robotState.eyeWidth * scale,
                height: robotState.eyeHeight * scale,
                radius: robotState.eyeRadius * scale
            )

            // Apply emotion overlays
            drawEmotionOverlay(context: context, scale: scale)
        }
    }

    private func drawEye(context: GraphicsContext, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, radius: CGFloat) {
        let rect = CGRect(x: x, y: y, width: width, height: height)
        let path = Path(roundedRect: rect, cornerRadius: radius)
        context.fill(path, with: .color(.white))
    }

    private func drawEmotionOverlay(context: GraphicsContext, scale: CGFloat) {
        switch emotion {
        case "happy":
            // Draw upturned triangles for happy eyes
            for i in 0..<10 {
                let offset = CGFloat(i) * 2 * scale

                // Left eye
                var leftPath = Path()
                leftPath.move(to: CGPoint(
                    x: (robotState.leftEyeX - offset) * scale,
                    y: (robotState.leftEyeY + robotState.eyeHeight) * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth / 2) * scale,
                    y: (robotState.leftEyeY + robotState.eyeHeight - offset) * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth + offset) * scale,
                    y: (robotState.leftEyeY + robotState.eyeHeight) * scale
                ))
                context.fill(leftPath, with: .color(.black))

                // Right eye
                var rightPath = Path()
                rightPath.move(to: CGPoint(
                    x: (robotState.rightEyeX - offset) * scale,
                    y: (robotState.rightEyeY + robotState.eyeHeight) * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + robotState.eyeWidth / 2) * scale,
                    y: (robotState.rightEyeY + robotState.eyeHeight - offset) * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + robotState.eyeWidth + offset) * scale,
                    y: (robotState.rightEyeY + robotState.eyeHeight) * scale
                ))
                context.fill(rightPath, with: .color(.black))
            }

        case "sad":
            // Draw downturned triangles for sad eyes
            for i in 0..<10 {
                let offset = CGFloat(i) * 2 * scale

                // Left eye
                var leftPath = Path()
                leftPath.move(to: CGPoint(
                    x: (robotState.leftEyeX - offset) * scale,
                    y: robotState.leftEyeY * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth / 2) * scale,
                    y: (robotState.leftEyeY + offset) * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth + offset) * scale,
                    y: robotState.leftEyeY * scale
                ))
                context.fill(leftPath, with: .color(.black))

                // Right eye
                var rightPath = Path()
                rightPath.move(to: CGPoint(
                    x: (robotState.rightEyeX - offset) * scale,
                    y: robotState.rightEyeY * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + robotState.eyeWidth / 2) * scale,
                    y: (robotState.rightEyeY + offset) * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + robotState.eyeWidth + offset) * scale,
                    y: robotState.rightEyeY * scale
                ))
                context.fill(rightPath, with: .color(.black))
            }

        case "angry":
            // Draw diagonal angry brows
            for i in 0..<15 {
                let iFloat = CGFloat(i) * scale

                // Left eye - top-left to bottom-right
                var leftPath = Path()
                leftPath.move(to: CGPoint(
                    x: robotState.leftEyeX * scale,
                    y: (robotState.leftEyeY + iFloat) * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth - iFloat) * scale,
                    y: robotState.leftEyeY * scale
                ))
                leftPath.addLine(to: CGPoint(
                    x: (robotState.leftEyeX + robotState.eyeWidth) * scale,
                    y: robotState.leftEyeY * scale
                ))
                context.fill(leftPath, with: .color(.black))

                // Right eye - top-right to bottom-left
                var rightPath = Path()
                rightPath.move(to: CGPoint(
                    x: robotState.rightEyeX * scale,
                    y: robotState.rightEyeY * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + iFloat) * scale,
                    y: robotState.rightEyeY * scale
                ))
                rightPath.addLine(to: CGPoint(
                    x: (robotState.rightEyeX + robotState.eyeWidth) * scale,
                    y: (robotState.rightEyeY + iFloat) * scale
                ))
                context.fill(rightPath, with: .color(.black))
            }

        default:
            break
        }
    }

    private func applyEmotion(_ emotion: String) {
        robotState.resetToCenter()

        switch emotion {
        case "sleepy":
            robotState.eyeHeight = 4
            robotState.leftEyeY = 225
            robotState.rightEyeY = 225
            robotState.eyeRadius = 2

        case "lookLeft":
            robotState.leftEyeX -= 20
            robotState.rightEyeX -= 20

        case "lookRight":
            robotState.leftEyeX += 20
            robotState.rightEyeX += 20

        case "surprised":
            robotState.eyeWidth = 75
            robotState.eyeHeight = 75
            robotState.eyeRadius = 5
            robotState.leftEyeX -= 12.5
            robotState.leftEyeY -= 12.5
            robotState.rightEyeX -= 12.5
            robotState.rightEyeY -= 12.5

        default:
            break
        }
    }
}

// MARK: - Robot Emotion Button
struct RobotEmotionButton: View {
    let title: String
    let emotion: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    isSelected ?
                        LinearGradient(
                            colors: [Color(hex: "4ecca3"), Color(hex: "3ab88a")],
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
                .cornerRadius(12)
        }
    }
}

#Preview {
    RobotFaceVersionView()
        .environmentObject(RobotFaceState())
}
