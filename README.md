# 🤖 Desk-Emoji Robot - Web Edition

A vivid, interactive web application that reproduces the **desk-emoji** robot project with expressive animated emotions and simulated gimbal movements.

## 🎯 Two Versions Available!

### 1. **Emoji Version** (index.html)
- 12 colorful Unicode emoji emotions (😊😍🤩😎)
- Vibrant colors and playful animations
- Perfect for demonstrations and fun interactions

### 2. **Robot Face Version** (index-robot.html) ⭐ **AUTHENTIC**
- Programmatically drawn robot faces using HTML5 Canvas
- Based on the **actual desk-emoji firmware code**
- Faithfully recreates the OLED display rendering
- 10 robot expressions with realistic eye movements
- Perfect for authentic robot simulation

**📖 [Read the Complete Usage Guide](USAGE.md)** for detailed instructions!

## 🎯 Overview

This web app brings the charm of a physical desk emoji robot to your browser, featuring:

- **Two distinct visual styles** - Emoji and Robot Face versions
- **Authentic robot face rendering** based on original firmware
- **Simulated Gimbal Control** with 2-axis tilt movements
- **3 Animation Modes** for dynamic emotional expressions
- **Beautiful UI** with gradient backgrounds and smooth animations
- **Easy version switching** with one-click toggle
- **Fully Responsive** design that works on desktop and mobile

## ✨ Features

### Emotion Systems

**Emoji Version (12 emotions):**
- 😊 Happy - Gentle pulsing animation
- 🤩 Excited - Energetic bouncing
- 😍 Love - Warm pulsing with pink glow
- 😎 Cool - Confident slight backward tilt
- 🤔 Thinking - Contemplative head tilt
- 😕 Confused - Uncertain shake
- 😢 Sad - Downward sway
- 😠 Angry - Intense shaking
- 😴 Sleepy - Drowsy swaying
- 😲 Surprised - Upward bounce
- 😂 Laughing - Joyful shaking
- 😉 Wink - Playful angled pose

**Robot Face Version (10 emotions):**
- 😊 Happy - Upturned eyes (drawn with triangles)
- 😢 Sad - Downturned eyes
- 😠 Angry - Diagonal angry brows
- 😲 Surprised - Wide expanding eyes
- 😴 Sleepy - Eyes closed to thin lines
- 👀 Waking Up - Eyes gradually opening
- 😑 Blinking - Realistic blink animation
- 👈 Look Left - Eyes shift left
- 👉 Look Right - Eyes shift right
- 😐 Center - Neutral robot face

### Gimbal Control

Use the directional controls to tilt the robot's "head" in any direction:
- **↑ Up** - Tilt backward
- **↓ Down** - Tilt forward
- **← Left** - Tilt left
- **→ Right** - Tilt right
- **⊙ Center** - Reset to neutral position

### Animation Modes

1. **🌀 Idle Animation**
   - Gentle bobbing motion with subtle rotations
   - Creates a "breathing" effect for the robot

2. **🎲 Random Emotions**
   - Cycles through random emotions every 2 seconds
   - Unpredictable and playful behavior

3. **✨ Expressive Mode**
   - Sequenced emotional journey through positive emotions
   - Dramatic movements and dynamic tilts
   - Perfect for demonstrations

## 🚀 Getting Started

### Installation

1. Clone or download this repository
2. No dependencies or build process required!

### Running the App

**Option 1: Local Server (Recommended)**
```bash
# Using Python's built-in server
python3 -m http.server 8000
```

Then open in your browser:
- **Emoji Version:** `http://localhost:8000/index.html`
- **Robot Face Version:** `http://localhost:8000/index-robot.html`

**Option 2: Direct Open**
- Double-click `index.html` for Emoji version
- Double-click `index-robot.html` for Robot Face version

**Switching Versions:**
- Click the "Switch to..." button at the bottom of each page!

### Supported Browsers

- Chrome/Edge (recommended)
- Firefox
- Safari
- Opera

## 🎨 Technical Details

### Architecture

- **Pure Vanilla JavaScript** - No frameworks or libraries required
- **CSS3 Animations** - Hardware-accelerated smooth transitions
- **Responsive Design** - Adapts to any screen size
- **Object-Oriented** - Clean `DeskEmojiRobot` class structure

### File Structure

```
Robot_Emotion_Interface/
├── index.html          # Emoji version HTML
├── index-robot.html    # Robot face version HTML
├── style.css           # Emoji version styling
├── style-robot.css     # Robot face version styling
├── app.js             # Emoji version logic
├── app-robot.js       # Robot face rendering and logic
├── README.md          # Main documentation
└── USAGE.md           # Detailed usage guide
```

### Key Technologies

**Emoji Version:**
- **3D Transforms** - `transform: rotateX() rotateY()` for gimbal simulation
- **CSS Animations** - Keyframe-based emotion animations
- **Gradient Effects** - Dynamic box-shadow and color gradients
- **Event Handling** - Responsive button interactions

**Robot Face Version:**
- **HTML5 Canvas** - Programmatic 2D drawing API
- **Rounded Rectangles** - Eye rendering (like OLED fillRoundRect)
- **Triangle Overlays** - Emotion modification technique
- **Animation Loops** - Smooth eye transitions and blinking
- **Authentic Algorithm** - Based on desk-emoji firmware code

## 🎭 Customization

### Adding New Emotions

Edit the `emotions` object in `app.js`:

```javascript
newEmotion: {
    emoji: '😀',           // Unicode emoji
    color: '#FF6B6B',      // Glow color (hex)
    animation: 'bounce',   // CSS animation class
    tiltX: 0,             // X-axis tilt (-30 to 30)
    tiltY: 0              // Y-axis tilt (-30 to 30)
}
```

### Creating Custom Animations

Add new animations in `style.css`:

```css
@keyframes customAnimation {
    0% { transform: translateY(0); }
    50% { transform: translateY(-20px); }
    100% { transform: translateY(0); }
}

.emotion-custom {
    animation: customAnimation 1s ease-in-out infinite;
}
```

## 🌟 Inspiration & Authenticity

This project is inspired by and directly based on the open-source **[desk-emoji](https://github.com/ideamark/desk-emoji)** hardware robot:

**Original Hardware Robot:**
- Physical 128x64 OLED display (SSD1306)
- 2-DOF gimbal mechanism
- LLM-powered voice chat
- Gesture recognition
- Programmatic eye drawing in C/C++

**Our Web Version:**
- **Emoji Version:** Fun, colorful interpretation with Unicode emojis
- **Robot Face Version:** Faithful recreation of the firmware's eye drawing system
  - Source: [emoji.cpp](https://raw.githubusercontent.com/ideamark/desk-emoji/main/firmware/Arduino_Esp32/esp32_v1.2.0/emoji.cpp)
  - Uses the same eye rendering techniques
  - Recreates rounded rectangle eyes with triangle overlays
  - Implements the same 10 emotion functions from the firmware

The Robot Face version translates the embedded C++ code to JavaScript Canvas API, providing an authentic simulation of how the physical robot renders expressions!

## 🎯 Future Enhancements

Potential features for future versions:

- [ ] Voice recognition for emotion detection
- [ ] Webcam-based facial expression mirroring
- [ ] Sound effects for each emotion
- [ ] Custom emoji upload capability
- [ ] Emotion timeline recording and playback
- [ ] Multi-robot synchronization
- [ ] Integration with LLM APIs for conversational responses
- [ ] Save/load emotional sequences
- [ ] Customizable color themes

## 📝 License

This project is inspired by the open-source desk-emoji project and is provided as-is for educational and entertainment purposes.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add new emotions
- Create custom animations
- Improve the UI/UX
- Add new features
- Fix bugs

## 💡 Usage Ideas

- **Desktop Companion** - Keep it open while working for mood expression
- **Presentations** - Show emotions during video calls or presentations
- **Education** - Teach children about emotions and expressions
- **Development** - Use as a notification system for build status
- **Fun** - Simply enjoy the expressive animations!

---

**Made with ❤️ for vivid robot emotions**
