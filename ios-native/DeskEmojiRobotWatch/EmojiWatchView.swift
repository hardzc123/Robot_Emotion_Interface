import SwiftUI

struct EmojiWatchView: View {
    @State private var selectedIndex = 0
    @State private var scale: CGFloat = 1.0

    let emotions: [(emoji: String, name: String, color: Color)] = [
        ("😊", "Happy", .yellow),
        ("🤩", "Excited", .orange),
        ("😍", "Love", .pink),
        ("😎", "Cool", .blue),
        ("😢", "Sad", .blue),
        ("😠", "Angry", .red),
        ("😴", "Sleepy", .gray),
        ("😲", "Surprised", .yellow)
    ]

    var body: some View {
        VStack(spacing: 8) {
            // Header
            Text("Emoji")
                .font(.caption2)
                .foregroundColor(.gray)

            // Emoji Display
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                emotions[selectedIndex].color.opacity(0.3),
                                emotions[selectedIndex].color.opacity(0.1)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 50
                        )
                    )
                    .frame(width: 90, height: 90)

                Text(emotions[selectedIndex].emoji)
                    .font(.system(size: 50))
                    .scaleEffect(scale)
            }
            .padding(.vertical, 5)

            // Emotion Name
            Text(emotions[selectedIndex].name)
                .font(.headline)
                .foregroundColor(emotions[selectedIndex].color)

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
                                    .foregroundColor(.green)
                                    .font(.caption)
                            }
                        }
                    }
                    .listRowBackground(
                        selectedIndex == index ?
                            emotions[index].color.opacity(0.15) : Color.clear
                    )
                }
            }
            .listStyle(.plain)
        }
    }

    private func selectEmotion(_ index: Int) {
        selectedIndex = index

        // Animate selection
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            scale = 0.8
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(0.15)) {
            scale = 1.0
        }
    }
}

#Preview {
    EmojiWatchView()
}
