import SwiftUI
import WatchKit

struct WatchRobotView: View {
    @State private var currentEmotion: String = "happy"
    @State private var eyeScale: CGFloat = 1.0

    let robotEmotions: [(id: String, name: String, emoji: String)] = [
        ("happy", "Happy", "😊"),
        ("sad", "Sad", "😢"),
        ("angry", "Angry", "😠"),
        ("surprised", "Surprised", "😲"),
        ("sleepy", "Sleepy", "😴"),
        ("blink", "Blink", "😑"),
        ("lookLeft", "Left", "👈"),
        ("lookRight", "Right", "👉")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Robot")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 5)

            // Robot Face Display
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "2a2a2a"), Color(hex: "1a1a1a")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: Color(hex: "4ecca3").opacity(0.5), radius: 10)

                WatchRobotFace(emotion: currentEmotion, eyeScale: eyeScale)
                    .frame(width: 100, height: 100)
            }
            .padding(.vertical, 10)

            // Emotion Name
            Text(robotEmotions.first(where: { $0.id == currentEmotion })?.name ?? "")
                .font(.headline)
                .foregroundColor(Color(hex: "4ecca3"))

            // Emotion Selector
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(robotEmotions, id: \.id) { emotion in
                        Button(action: {
                            selectEmotion(emotion.id)
                        }) {
                            HStack {
                                Text(emotion.emoji)
                                    .font(.title3)
                                Text(emotion.name)
                                    .font(.caption)
                                Spacer()
                                if currentEmotion == emotion.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(hex: "4ecca3"))
                                }
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                currentEmotion == emotion.id ?
                                    Color(hex: "4ecca3").opacity(0.2) : Color.clear
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

    private func selectEmotion(_ emotion: String) {
        currentEmotion = emotion
        WKInterfaceDevice.current().play(.click)

        // Animate blink
        if emotion == "blink" {
            withAnimation(.easeInOut(duration: 0.15)) {
                eyeScale = 0.1
            }
            withAnimation(.easeInOut(duration: 0.15).delay(0.15)) {
                eyeScale = 1.0
            }
        }
    }
}

struct WatchRobotFace: View {
    let emotion: String
    let eyeScale: CGFloat

    var body: some View {
        Canvas { context, size in
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Eye parameters
            var leftEyeX: CGFloat = centerX - 15
            var leftEyeY: CGFloat = centerY - 5
            var rightEyeX: CGFloat = centerX + 5
            var rightEyeY: CGFloat = centerY - 5
            var eyeWidth: CGFloat = 10
            var eyeHeight: CGFloat = 10 * eyeScale

            // Adjust based on emotion
            switch emotion {
            case "sleepy":
                eyeHeight = 2

            case "lookLeft":
                leftEyeX -= 5
                rightEyeX -= 5

            case "lookRight":
                leftEyeX += 5
                rightEyeX += 5

            case "surprised":
                eyeWidth = 15
                eyeHeight = 15 * eyeScale
                leftEyeX -= 2.5
                rightEyeX -= 2.5
                leftEyeY -= 2.5
                rightEyeY -= 2.5

            default:
                break
            }

            // Draw left eye
            let leftEyeRect = CGRect(x: leftEyeX, y: leftEyeY, width: eyeWidth, height: eyeHeight)
            let leftEyePath = Path(roundedRect: leftEyeRect, cornerRadius: 3)
            context.fill(leftEyePath, with: .color(Color(hex: "4ecca3")))

            // Draw right eye
            let rightEyeRect = CGRect(x: rightEyeX, y: rightEyeY, width: eyeWidth, height: eyeHeight)
            let rightEyePath = Path(roundedRect: rightEyeRect, cornerRadius: 3)
            context.fill(rightEyePath, with: .color(Color(hex: "4ecca3")))

            // Draw emotion overlays
            switch emotion {
            case "happy":
                // Small upturned triangles
                for i in 0..<3 {
                    let offset = CGFloat(i) * 1.5

                    var leftPath = Path()
                    leftPath.move(to: CGPoint(x: leftEyeX - offset, y: leftEyeY + eyeHeight))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth / 2, y: leftEyeY + eyeHeight - offset))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth + offset, y: leftEyeY + eyeHeight))
                    context.fill(leftPath, with: .color(.black))

                    var rightPath = Path()
                    rightPath.move(to: CGPoint(x: rightEyeX - offset, y: rightEyeY + eyeHeight))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth / 2, y: rightEyeY + eyeHeight - offset))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth + offset, y: rightEyeY + eyeHeight))
                    context.fill(rightPath, with: .color(.black))
                }

            case "sad":
                // Small downturned triangles
                for i in 0..<3 {
                    let offset = CGFloat(i) * 1.5

                    var leftPath = Path()
                    leftPath.move(to: CGPoint(x: leftEyeX - offset, y: leftEyeY))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth / 2, y: leftEyeY + offset))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth + offset, y: leftEyeY))
                    context.fill(leftPath, with: .color(.black))

                    var rightPath = Path()
                    rightPath.move(to: CGPoint(x: rightEyeX - offset, y: rightEyeY))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth / 2, y: rightEyeY + offset))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth + offset, y: rightEyeY))
                    context.fill(rightPath, with: .color(.black))
                }

            case "angry":
                // Angry brows
                for i in 0..<5 {
                    let iFloat = CGFloat(i) * 0.5

                    var leftPath = Path()
                    leftPath.move(to: CGPoint(x: leftEyeX, y: leftEyeY + iFloat))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth - iFloat, y: leftEyeY))
                    leftPath.addLine(to: CGPoint(x: leftEyeX + eyeWidth, y: leftEyeY))
                    context.fill(leftPath, with: .color(.black))

                    var rightPath = Path()
                    rightPath.move(to: CGPoint(x: rightEyeX, y: rightEyeY))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + iFloat, y: rightEyeY))
                    rightPath.addLine(to: CGPoint(x: rightEyeX + eyeWidth, y: rightEyeY + iFloat))
                    context.fill(rightPath, with: .color(.black))
                }

            default:
                break
            }
        }
    }
}

#Preview {
    WatchRobotView()
}
