# 🤖 Desk-Emoji Robot - Web Edition

A vivid, interactive web application that reproduces the **desk-emoji** robot project with expressive animated emotions and simulated gimbal movements.

## 🎯 Overview

This web app brings the charm of a physical desk emoji robot to your browser, featuring:

- **12 Vivid Emotions** with smooth transitions and unique animations
- **Simulated Gimbal Control** with 2-axis tilt movements
- **3 Animation Modes** for dynamic emotional expressions
- **Beautiful UI** with gradient backgrounds and smooth animations
- **Fully Responsive** design that works on desktop and mobile

## ✨ Features

### Emotion System

The robot supports 12 distinct emotional states, each with its own:
- Unique emoji character
- Custom color scheme and glow effects
- Specific animation pattern
- Characteristic tilt angle

**Available Emotions:**
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

Simply open `index.html` in any modern web browser:

```bash
# Using Python's built-in server (recommended)
python3 -m http.server 8000

# Or just double-click index.html
```

Then navigate to `http://localhost:8000` in your browser.

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
├── index.html          # Main HTML structure
├── style.css           # Styling and animations
├── app.js             # Robot logic and interactions
└── README.md          # Documentation
```

### Key Technologies

- **3D Transforms** - `transform: rotateX() rotateY()` for gimbal simulation
- **CSS Animations** - Keyframe-based emotion animations
- **Gradient Effects** - Dynamic box-shadow and color gradients
- **Event Handling** - Responsive button interactions

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

## 🌟 Inspiration

This project is inspired by the open-source **[desk-emoji](https://github.com/ideamark/desk-emoji)** hardware robot, which features:
- Physical emoji display screen
- 2-DOF gimbal mechanism
- LLM-powered voice chat
- Gesture recognition

Our web version aims to capture the expressive charm and emotional range of the physical robot in a browser-accessible format.

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
