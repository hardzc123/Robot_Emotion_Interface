# 📖 Desk-Emoji Robot - Usage Guide

## 🎯 Two Versions Available!

This project includes **TWO distinct versions** of the Desk-Emoji Robot web application, each offering a unique visual experience:

### 1. **Emoji Version** (index.html)
- Uses colorful Unicode emoji characters (😊😍🤩😎)
- 12 different emotions with vibrant colors
- Fun and expressive with pre-made emoji faces
- Best for: Colorful, playful interactions

### 2. **Robot Face Version** (index-robot.html) ⭐ **AUTHENTIC**
- Uses programmatically drawn robot faces
- Based on the **actual desk-emoji firmware code**
- Recreates the OLED display rendering system
- Eyes drawn with rounded rectangles and triangles
- 10 different robot expressions
- Best for: Authentic robot simulation

---

## 🚀 How to Use

### Quick Start

1. **Open a version:**
   - For emoji version: Open `index.html` in your browser
   - For robot face version: Open `index-robot.html` in your browser

2. **Or use a local server (recommended):**
   ```bash
   python3 -m http.server 8000
   ```
   Then visit:
   - Emoji version: `http://localhost:8000/index.html`
   - Robot version: `http://localhost:8000/index-robot.html`

3. **Switch between versions:**
   - Click the "Switch to..." button at the bottom of each page
   - No reload needed - instant switching!

---

## 🎮 Features Guide

### Selecting Emotions

**Emoji Version (12 emotions):**
- 😊 Happy - Gentle pulsing
- 🤩 Excited - Bouncing animation
- 😍 Love - Pink romantic glow
- 😎 Cool - Confident backward tilt
- 🤔 Thinking - Thoughtful head tilt
- 😕 Confused - Uncertain shake
- 😢 Sad - Downward sway
- 😠 Angry - Intense shaking
- 😴 Sleepy - Drowsy animation
- 😲 Surprised - Upward bounce
- 😂 Laughing - Joyful shake
- 😉 Wink - Playful angle

**Robot Face Version (10 emotions):**
- 😊 Happy - Upturned eyes (smiling)
- 😢 Sad - Downturned eyes
- 😠 Angry - Diagonal angry brows
- 😲 Surprised - Wide expanding eyes
- 😴 Sleepy - Eyes closed to thin lines
- 👀 Waking Up - Eyes gradually opening
- 😑 Blinking - Quick blink animation
- 👈 Look Left - Eyes shift left
- 👉 Look Right - Eyes shift right
- 😐 Center - Neutral position

### Gimbal Control (Both Versions)

Control the robot's head tilt with the joystick:

```
     ↑
     ↑  (Tilt Backward)

←  ⊙  →

     ↓
     ↓  (Tilt Forward)
```

- **↑ Up** - Tilts the display backward (-20° on X-axis)
- **↓ Down** - Tilts the display forward (+20° on X-axis)
- **← Left** - Tilts the display left (-20° on Y-axis)
- **→ Right** - Tilts the display right (+20° on Y-axis)
- **⊙ Center** - Resets to neutral position (0°, 0°)

### Animation Modes (Both Versions)

Activate autonomous behavior:

1. **🌀 Idle Animation**
   - Emoji version: Gentle bobbing with subtle rotations
   - Robot version: Periodic realistic blinking (every 3 seconds)
   - Simulates natural "breathing" behavior

2. **🎲 Random Emotions**
   - Cycles through random emotions every 2 seconds
   - Unpredictable and playful
   - Great for demonstrations!

3. **✨ Expressive Mode**
   - Emoji version: Sequences through positive emotions
   - Robot version: Wake up → Happy → Surprised → Look around
   - Dramatic movements and dynamic tilts
   - Perfect for showcasing capabilities

**To stop animations:** Click any emotion button or click the same animation button again.

---

## 🎨 Technical Comparison

### Emoji Version
| Feature | Implementation |
|---------|----------------|
| Display | Unicode emoji characters |
| Rendering | DOM text content |
| Colors | Dynamic box-shadow glow effects |
| Animations | CSS3 keyframe animations |
| File Size | Lightweight (~5KB JS) |
| Compatibility | Works in all modern browsers |

### Robot Face Version ⭐
| Feature | Implementation |
|---------|----------------|
| Display | HTML5 Canvas programmatic drawing |
| Rendering | 2D context API (like OLED display) |
| Eyes | Rounded rectangles (fillRoundRect) |
| Expressions | Triangle overlays and transformations |
| File Size | Moderate (~10KB JS) |
| Authenticity | Based on actual firmware code |
| Source | [desk-emoji/firmware/Arduino_Esp32](https://github.com/ideamark/desk-emoji/tree/main/firmware/Arduino_Esp32/esp32_v1.2.0) |

---

## 🤖 Robot Face Version - Deep Dive

### How It Works

The Robot Face Version faithfully recreates the rendering system from the physical desk-emoji robot:

**Original Hardware:**
- 128x64 pixel OLED display (SSD1306)
- Programmatic eye drawing in C/C++
- Adafruit GFX library

**Web Recreation:**
- 400x400 pixel HTML5 Canvas
- Programmatic eye drawing in JavaScript
- Canvas 2D API

### Eye Drawing Algorithm

1. **Base Eyes:**
   ```javascript
   // Two rounded rectangle eyes
   Left Eye:  x=140, y=200, width=50, height=50, radius=10
   Right Eye: x=210, y=200, width=50, height=50, radius=10
   ```

2. **Emotion Modification:**
   - **Happy:** Black triangles overlay bottom of eyes (upturned)
   - **Sad:** Black triangles overlay top of eyes (downturned)
   - **Angry:** Diagonal triangles create angry brows
   - **Surprised:** Eyes grow larger, radius shrinks
   - **Sleepy:** Height reduces to 4px (thin lines)
   - **Blink:** Height animates: 50→0→50 pixels

### Code Correspondence

| Firmware Function | Web Version Method |
|-------------------|-------------------|
| `eye_happy()` | `eyeHappy()` |
| `eye_sad()` | `eyeSad()` |
| `eye_anger()` | `eyeAngry()` |
| `eye_surprise()` | `eyeSurprised()` |
| `eye_sleep()` | `eyeSleepy()` |
| `eye_wakeup()` | `eyeWakeup()` |
| `eye_blink()` | `eyeBlink()` |
| `eye_left()` | `eyeLookLeft()` |
| `eye_right()` | `eyeLookRight()` |

---

## 💡 Usage Scenarios

### Emoji Version - Best For:
- ✅ Presentations and demos needing color
- ✅ Fun, playful interactions
- ✅ Wide range of emotions (12 total)
- ✅ Bright, eye-catching displays
- ✅ Mobile devices (lightweight)

### Robot Face Version - Best For:
- ✅ **Authentic desk-emoji simulation**
- ✅ Educational purposes (show how robots draw faces)
- ✅ Technical demonstrations
- ✅ Understanding the original hardware project
- ✅ More subtle, robot-like expressions
- ✅ Realistic blinking and eye movements

---

## 🎯 Keyboard Shortcuts (Future)

_Currently all interactions are mouse/touch-based. Future versions may include:_
- Arrow keys for gimbal control
- Number keys for quick emotion selection
- Spacebar for random emotion
- B for blink (robot version)

---

## 🐛 Troubleshooting

### Issue: Animations not smooth
- **Solution:** Close other browser tabs, ensure hardware acceleration is enabled

### Issue: Canvas appears blank (robot version)
- **Solution:** Check browser console, ensure JavaScript is enabled
- **Check:** Canvas dimensions should be 400x400

### Issue: Version switcher not working
- **Solution:** Ensure both HTML files are in the same directory
- **Check:** Files should be accessed via HTTP (not file://)

### Issue: Gimbal controls not responding
- **Solution:** Stop any active animation mode first
- **Click:** The center ⊙ button to reset

---

## 📱 Mobile Usage

Both versions are fully responsive and work on mobile devices:

- **Touch:** Tap buttons instead of clicking
- **Gestures:** Standard touch interactions
- **Layout:** Adapts to smaller screens
- **Performance:** Emoji version recommended for older devices

---

## 🌟 Tips & Tricks

1. **Combine Features:**
   - Select an emotion, then use gimbal control for custom poses
   - Try tilting during animations for dynamic effects

2. **Presentation Mode:**
   - Use Expressive Mode for eye-catching demos
   - Robot version's blinking creates realistic idle behavior

3. **Compare Versions:**
   - Open both versions side-by-side
   - See the difference between emoji and robot faces
   - Notice how expressions are rendered differently

4. **Custom Sequences:**
   - Manually click emotions in sequence
   - Create your own emotional "stories"
   - Use gimbal between emotions for emphasis

---

## 📚 Further Reading

- [Original desk-emoji Project](https://github.com/ideamark/desk-emoji)
- [Firmware Source Code](https://github.com/ideamark/desk-emoji/tree/main/firmware/Arduino_Esp32/esp32_v1.2.0)
- [emoji.cpp](https://raw.githubusercontent.com/ideamark/desk-emoji/main/firmware/Arduino_Esp32/esp32_v1.2.0/emoji.cpp) - Original eye drawing code
- [HTML5 Canvas API](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API)

---

## 🎓 Learning Opportunities

**From Emoji Version:**
- CSS3 animations and transitions
- DOM manipulation
- Event handling
- Gradient effects

**From Robot Face Version:**
- HTML5 Canvas drawing
- Programmatic graphics rendering
- Animation with requestAnimationFrame
- Translating embedded code to web

---

**Enjoy expressing vivid robot emotions! 🤖✨**

Choose the version that best fits your needs and have fun exploring the expressive world of desk emoji robots!
