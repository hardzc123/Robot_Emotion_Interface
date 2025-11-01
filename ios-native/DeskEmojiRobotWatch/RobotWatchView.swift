import SwiftUI

struct RobotWatchView: View {
    @State private var selectedIndex = 0
    @State private var eyeScale: CGFloat = 1.0

    let emotions: [(id: String, name: String, emoji: String)] = [
        ("happy", "Happy", "😊"),
        ("sad", "Sad", "😢"),
        ("angry", "Angry", "😠"),
        ("surprised", "Surprised", "😲"),
        ("sleepy", "Sleepy", "😴"),
        ("lookLeft", "Left", "👈"),
        ("lookRight", "Right", "👉"),
        ("center", "Center", "😐")
    ]

    let robotColor = Color(red: 0.31, green: 0.8, blue: 0.64) // #4ecca3

    var body: some View {
        VStack(spacing: 8) {
            // Header
            Text("Robot")
                .font(.caption2)
                .foregroundColor(.gray)

            // Robot Face Display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(white: 0.16),
                                Color(white: 0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: robotColor.opacity(0.5), radius: 8)

                RobotFaceView(
                    emotion: emotions[selectedIndex].id,
                    eyeScale: eyeScale
                )
                .frame(width: 90, height: 90)
            }
            .padding(.vertical, 5)

            // Emotion Name
            Text(emotions[selectedIndex].name)
                .font(.headline)
                .foregroundColor(robotColor)

            // Emotion List
            List {
                ForEach(0..<emotions.count, id: \.self) { index in
                    Button(action: {
                        selectEmotion(index)
                    }) {
                        HStack {
                            Text(emotions[index].emoji)
                                .font(.title3)
                            Text(emotions[index].name)
                                .font(.caption)
                            Spacer()
                            if selectedIndex == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(robotColor)
                                    .font(.caption)
                            }
                        }
                    }
                    .listRowBackground(
                        selectedIndex == index ?
                            robotColor.opacity(0.15) : Color.clear
                    )
                }
            }
            .listStyle(.plain)
        }
    }

    private func selectEmotion(_ index: Int) {
        selectedIndex = index

        // Animate blink for blink action
        if emotions[index].id == "blink" || emotions[index].id == "sleepy" {
            withAnimation(.easeInOut(duration: 0.2)) {
                eyeScale = 0.1
            }
            withAnimation(.easeInOut(duration: 0.2).delay(0.2)) {
                eyeScale = 1.0
            }
        }
    }
}

struct RobotFaceView: View {
    let emotion: String
    let eyeScale: CGFloat
    let robotColor = Color(red: 0.31, green: 0.8, blue: 0.64)

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Base eye parameters
            var leftEyeX: CGFloat = centerX - 13
            var leftEyeY: CGFloat = centerY - 4
            var rightEyeX: CGFloat = centerX + 3
            var rightEyeY: CGFloat = centerY - 4
            var eyeWidth: CGFloat = 10
            var eyeHeight: CGFloat = 10 * eyeScale

            // Adjust based on emotion
            switch emotion {
            case "sleepy":
                eyeHeight = 2

            case "lookLeft":
                leftEyeX -= 4
                rightEyeX -= 4

            case "lookRight":
                leftEyeX += 4
                rightEyeX += 4

            case "surprised":
                eyeWidth = 14
                eyeHeight = 14 * eyeScale
                leftEyeX -= 2
                rightEyeX -= 2
                leftEyeY -= 2
                rightEyeY -= 2

            default:
                break
            }

            // Draw left eye
            let leftRect = CGRect(x: leftEyeX, y: leftEyeY, width: eyeWidth, height: eyeHeight)
            context.fill(
                Path(roundedRect: leftRect, cornerRadius: 2.5),
                with: .color(robotColor)
            )

            // Draw right eye
            let rightRect = CGRect(x: rightEyeX, y: rightEyeY, width: eyeWidth, height: eyeHeight)
            context.fill(
                Path(roundedRect: rightRect, cornerRadius: 2.5),
                with: .color(robotColor)
            )

            // Draw emotion overlays
            drawEmotionOverlay(
                context: context,
                emotion: emotion,
                leftEyeX: leftEyeX,
                leftEyeY: leftEyeY,
                rightEyeX: rightEyeX,
                rightEyeY: rightEyeY,
                eyeWidth: eyeWidth,
                eyeHeight: eyeHeight
            )
        }
    }

    private func drawEmotionOverlay(
        context: GraphicsContext,
        emotion: String,
        leftEyeX: CGFloat,
        leftEyeY: CGFloat,
        rightEyeX: CGFloat,
        rightEyeY: CGFloat,
        eyeWidth: CGFloat,
        eyeHeight: CGFloat
    ) {
        switch emotion {
        case "happy":
            // Upturned eyes
            for i in 0..<3 {
                let offset = CGFloat(i) * 1.2

                // Left eye smile
                var leftPath = Path()
                leftPath.move(to: CGPoint(x: leftEyeX - offset, y: leftEyeY + eyeHeight))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth / 2, y: leftEyeY + eyeHeight - offset))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth + offset, y: leftEyeY + eyeHeight))
                leftPath.closeSubpath()
                context.fill(leftPath, with: .color(.black))

                // Right eye smile
                var rightPath = Path()
                rightPath.move(to: CGPoint(x: rightEyeX - offset, y: rightEyeY + eyeHeight))
                rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth / 2, y: rightEyeY + eyeHeight - offset))
                rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth + offset, y: rightEyeY + eyeHeight))
                rightPath.closeSubpath()
                context.fill(rightPath, with: .color(.black))
            }

        case "sad":
            // Downturned eyes
            for i in 0..<3 {
                let offset = CGFloat(i) * 1.2

                var leftPath = Path()
                leftPath.move(to: CGPoint(x: leftEyeX - offset, y: leftEyeY))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth / 2, y: leftEyeY + offset))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth + offset, y: leftEyeY))
                leftPath.closeSubpath()
                context.fill(leftPath, with: .color(.black))

                var rightPath = Path()
                rightPath.move(to: CGPoint(x: rightEyeX - offset, y: rightEyeY))
                rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth / 2, y: rightEyeY + offset))
                rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth + offset, y: rightEyeY))
                rightPath.closeSubpath()
                context.fill(rightPath, with: .color(.black))
            }

        case "angry":
            // Angry brows
            for i in 0..<4 {
                let offset = CGFloat(i) * 0.6

                var leftPath = Path()
                leftPath.move(to: CGPoint(x: leftEyeX, y: leftEyeY + offset))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth - offset, y: leftEyeY))
                leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth, y: leftEyeY))
                leftPath.closeSubpath()
                context.fill(leftPath, with: .color(.black))

                var rightPath = Path()
                rightPath.move(to: CGPoint(x: rightEyeX, y: rightEyeY))
                rightPath.addLine(to: CGPoint(x: rightEyeX + offset, y: rightEyeY))
                rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth, y: rightEyeY + offset))
                rightPath.closeSubpath()
                context.fill(rightPath, with: .color(.black))
            }

        default:
            break
        }
    }
}

#Preview {
    RobotWatchView()
}
