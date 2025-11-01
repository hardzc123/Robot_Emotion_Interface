import SwiftUI
import WatchKit

struct WatchRobotView: View {
    private let options: [RobotEmotionOption] = RobotEmotionOption.defaultOptions

    @State private var selection: Int = 0
    @State private var eyeScale: CGFloat = 1.0
    @State private var glowPulse: Bool = false
    @State private var diagnostics: Diagnostics = Diagnostics()

    private var currentOption: RobotEmotionOption {
        guard !options.isEmpty else { return RobotEmotionOption.placeholder }
        let safeIndex = min(max(selection, options.startIndex), options.index(before: options.endIndex))
        return options[safeIndex]
    }

    var body: some View {
        VStack(spacing: 10) {
            header

            RobotFaceCard(
                option: currentOption,
                eyeScale: eyeScale,
                glowPulse: glowPulse
            )

            statusRow

            emotionPicker

            quickActions
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 6)
        .onAppear { startGlow() }
        .onChange(of: selection) { _ in selectionChanged() }
    }
}

private extension WatchRobotView {
    var header: some View {
        HStack {
            Label {
                Text("Robot Face")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: "sparkles.rectangle.stack")
                    .font(.caption2)
                    .foregroundStyle(.mint)
            }

            Spacer()

            Text(currentOption.name.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(currentOption.accent)
        }
    }

    var statusRow: some View {
        HStack(spacing: 6) {
            RobotBadge(
                title: "Eye Focus",
                systemImage: "bolt.circle",
                value: diagnostics.focus(for: currentOption.id),
                tint: currentOption.accent
            )
            RobotBadge(
                title: "Mood",
                systemImage: "waveform.path.ecg",
                value: diagnostics.mood(for: currentOption.id),
                tint: .cyan
            )
        }
    }

    var emotionPicker: some View {
        Picker("Robot Mood", selection: $selection) {
            ForEach(options.indices, id: \.self) { index in
                Text(options[index].glyph + " " + options[index].name)
                    .tag(index)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 68)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.14))
        )
    }

    var quickActions: some View {
        HStack(spacing: 8) {
            QuickActionButton(
                label: "Blink",
                systemImage: "eye",
                tint: .indigo.opacity(0.8),
                action: triggerBlink
            )

            QuickActionButton(
                label: "Center",
                systemImage: "target",
                tint: .orange.opacity(0.8),
                action: { setEmotion(withID: "center") }
            )
        }
        .padding(.bottom, 2)
    }

    func selectionChanged() {
        WKInterfaceDevice.current().play(.click)
        diagnostics.refresh()
    }

    func triggerBlink() {
        WKInterfaceDevice.current().play(.success)
        withAnimation(.easeInOut(duration: 0.12)) {
            eyeScale = 0.05
        }
        withAnimation(.easeInOut(duration: 0.18).delay(0.12)) {
            eyeScale = 1.0
        }
        setEmotion(withID: "blink", temporary: true)
    }

    func setEmotion(withID id: String, temporary: Bool = false) {
        if let index = options.firstIndex(where: { $0.id == id }) {
            selection = index
        } else if temporary {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                selectionChanged()
            }
        }
    }

    func startGlow() {
        withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
            glowPulse.toggle()
        }
    }
}

// MARK: - Subviews

private struct RobotFaceCard: View {
    let option: RobotEmotionOption
    let eyeScale: CGFloat
    let glowPulse: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(option.accent.opacity(glowPulse ? 0.65 : 0.2), lineWidth: glowPulse ? 4 : 1)
                        .shadow(color: option.accent.opacity(glowPulse ? 0.45 : 0.1), radius: glowPulse ? 8 : 3)
                )

            WatchRobotFace(emotion: option.id, accent: option.accent, eyeScale: eyeScale)
                .frame(height: 112)
        }
        .frame(height: 118)
    }
}

private struct RobotBadge: View {
    let title: String
    let systemImage: String
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

private struct QuickActionButton: View {
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
                    .fill(tint.opacity(0.22))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Rendered Face

private struct WatchRobotFace: View {
    let emotion: String
    let accent: Color
    let eyeScale: CGFloat

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            // Base bezel
            let bezelRect = CGRect(x: center.x - 44, y: center.y - 44, width: 88, height: 88)
            let bezelPath = Path(roundedRect: bezelRect, cornerRadius: 22)
            context.stroke(bezelPath, with: .color(accent.opacity(0.3)), lineWidth: 2)

            // Inner panel
            let innerRect = bezelRect.insetBy(dx: 6, dy: 6)
            let panelPath = Path(roundedRect: innerRect, cornerRadius: 18)
            context.fill(panelPath, with: .linearGradient(
                Gradient(colors: [Color.black, Color.black.opacity(0.6)]),
                startPoint: CGPoint(x: innerRect.minX, y: innerRect.minY),
                endPoint: CGPoint(x: innerRect.maxX, y: innerRect.maxY)
            ))

            drawEyes(context: context, rect: innerRect)
            drawEmotionMarks(context: context, rect: innerRect)
        }
    }

    private func drawEyes(context: GraphicsContext, rect: CGRect) {
        let eyeWidth: CGFloat = 20
        let eyeHeight: CGFloat = 14 * eyeScale
        let verticalOffset: CGFloat = 10
        var leftEyeOrigin = CGPoint(x: rect.midX - 28, y: rect.midY - verticalOffset)
        var rightEyeOrigin = CGPoint(x: rect.midX + 8, y: rect.midY - verticalOffset)

        switch emotion {
        case "lookLeft":
            leftEyeOrigin.x -= 6
            rightEyeOrigin.x -= 6
        case "lookRight":
            leftEyeOrigin.x += 6
            rightEyeOrigin.x += 6
        case "surprised":
            leftEyeOrigin.y -= 4
            rightEyeOrigin.y -= 4
        case "sleepy":
            leftEyeOrigin.y += 8
            rightEyeOrigin.y += 8
        default:
            break
        }

        let eyeCornerRadius: CGFloat = emotion == "surprised" ? eyeWidth / 2 : 6
        let leftEyeRect = CGRect(origin: leftEyeOrigin, size: CGSize(width: emotion == "surprised" ? 24 : eyeWidth, height: eyeHeight))
        let rightEyeRect = CGRect(origin: rightEyeOrigin, size: CGSize(width: emotion == "surprised" ? 24 : eyeWidth, height: eyeHeight))

        let eyeColor = accent.opacity(0.9)
        context.fill(Path(roundedRect: leftEyeRect, cornerRadius: eyeCornerRadius), with: .color(eyeColor))
        context.fill(Path(roundedRect: rightEyeRect, cornerRadius: eyeCornerRadius), with: .color(eyeColor))
    }

    private func drawEmotionMarks(context: GraphicsContext, rect: CGRect) {
        switch emotion {
        case "happy":
            drawArc(context: context, rect: rect, isUpturned: true)
        case "sad":
            drawArc(context: context, rect: rect, isUpturned: false)
        case "angry":
            drawBrows(context: context, rect: rect, inverted: false)
        case "blink":
            drawBlink(context: context, rect: rect)
        case "center":
            drawFocusTarget(context: context, rect: rect)
        default:
            break
        }
    }

    private func drawArc(context: GraphicsContext, rect: CGRect, isUpturned: Bool) {
        let startY = rect.midY + (isUpturned ? 12 : -12)
        let controlY = rect.midY + (isUpturned ? 4 : -4)
        let path = Path { path in
            path.move(to: CGPoint(x: rect.minX + 22, y: startY))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - 22, y: startY),
                control: CGPoint(x: rect.midX, y: controlY)
            )
        }
        context.stroke(path, with: .color(.black.opacity(0.6)), lineWidth: 3)
    }

    private func drawBrows(context: GraphicsContext, rect: CGRect, inverted: Bool) {
        let offset: CGFloat = inverted ? -6 : 6
        let leftStart = CGPoint(x: rect.minX + 12, y: rect.minY + 18 + offset)
        let leftEnd = CGPoint(x: rect.midX - 4, y: rect.minY + 14)
        let rightStart = CGPoint(x: rect.maxX - 12, y: rect.minY + 18 + offset)
        let rightEnd = CGPoint(x: rect.midX + 4, y: rect.minY + 14)

        context.stroke(Path { $0.addLines([leftStart, leftEnd]) }, with: .color(.black.opacity(0.6)), lineWidth: 3)
        context.stroke(Path { $0.addLines([rightStart, rightEnd]) }, with: .color(.black.opacity(0.6)), lineWidth: 3)
    }

    private func drawBlink(context: GraphicsContext, rect: CGRect) {
        let path = Path { path in
            path.move(to: CGPoint(x: rect.minX + 16, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX - 16, y: rect.midY))
        }
        context.stroke(path, with: .color(.black.opacity(0.65)), lineWidth: 4)
    }

    private func drawFocusTarget(context: GraphicsContext, rect: CGRect) {
        let targetRect = rect.insetBy(dx: 24, dy: 24)
        context.stroke(Path(roundedRect: targetRect, cornerRadius: 14), with: .color(accent.opacity(0.25)), lineWidth: 2)
    }
}

// MARK: - Supporting Types

private struct RobotEmotionOption: Identifiable {
    let id: String
    let name: String
    let glyph: String
    let accent: Color

    static let placeholder = RobotEmotionOption(id: "center", name: "Center", glyph: "◎", accent: Color(hex: "4ecca3"))

    static let defaultOptions: [RobotEmotionOption] = [
        RobotEmotionOption(id: "happy", name: "Delight", glyph: "😊", accent: Color(hex: "4ecca3")),
        RobotEmotionOption(id: "lookLeft", name: "Tracking", glyph: "👈", accent: .blue),
        RobotEmotionOption(id: "lookRight", name: "Sweep", glyph: "👉", accent: .purple),
        RobotEmotionOption(id: "surprised", name: "Alert", glyph: "😲", accent: .yellow),
        RobotEmotionOption(id: "sleepy", name: "Rest", glyph: "😴", accent: .mint),
        RobotEmotionOption(id: "angry", name: "Guard", glyph: "😠", accent: .red),
        RobotEmotionOption(id: "blink", name: "Blink", glyph: "😑", accent: .gray),
        RobotEmotionOption(id: "center", name: "Center", glyph: "◎", accent: Color(hex: "4ecca3"))
    ]
}

private struct Diagnostics {
    mutating func refresh() {}

    func focus(for id: String) -> Double {
        switch id {
        case "lookLeft", "lookRight": return 0.95
        case "surprised": return 0.85
        case "sleepy": return 0.4
        default: return 0.7
        }
    }

    func mood(for id: String) -> Double {
        switch id {
        case "happy": return 0.92
        case "surprised": return 0.78
        case "sleepy": return 0.35
        case "angry": return 0.42
        default: return 0.6
        }
    }
}

#Preview {
    WatchRobotView()
}
