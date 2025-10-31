// Desk-Emoji Robot - Emotion Interface
class DeskEmojiRobot {
    constructor() {
        this.currentEmotion = 'happy';
        this.robotBody = document.getElementById('robotBody');
        this.faceContainer = document.getElementById('faceContainer');
        this.emojiDisplay = document.getElementById('emojiDisplay');
        this.isAnimating = false;
        this.animationInterval = null;

        // Emotion configurations with emojis and animations
        this.emotions = {
            happy: {
                emoji: '😊',
                color: '#FFD700',
                animation: 'emotionPulse',
                tiltX: 0,
                tiltY: 0
            },
            excited: {
                emoji: '🤩',
                color: '#FF6B6B',
                animation: 'bounce',
                tiltX: 0,
                tiltY: 5
            },
            love: {
                emoji: '😍',
                color: '#FF1493',
                animation: 'emotionPulse',
                tiltX: 0,
                tiltY: 0
            },
            cool: {
                emoji: '😎',
                color: '#4169E1',
                animation: 'none',
                tiltX: 0,
                tiltY: -5
            },
            thinking: {
                emoji: '🤔',
                color: '#9370DB',
                animation: 'tilt',
                tiltX: 15,
                tiltY: 0
            },
            confused: {
                emoji: '😕',
                color: '#DAA520',
                animation: 'shake',
                tiltX: -10,
                tiltY: 0
            },
            sad: {
                emoji: '😢',
                color: '#4682B4',
                animation: 'sway',
                tiltX: 0,
                tiltY: -10
            },
            angry: {
                emoji: '😠',
                color: '#DC143C',
                animation: 'shake',
                tiltX: 10,
                tiltY: 0
            },
            sleepy: {
                emoji: '😴',
                color: '#778899',
                animation: 'sway',
                tiltX: -15,
                tiltY: -10
            },
            surprised: {
                emoji: '😲',
                color: '#FFD700',
                animation: 'bounce',
                tiltX: 0,
                tiltY: 10
            },
            laugh: {
                emoji: '😂',
                color: '#FF8C00',
                animation: 'shake',
                tiltX: 0,
                tiltY: 0
            },
            wink: {
                emoji: '😉',
                color: '#FF69B4',
                animation: 'none',
                tiltX: 5,
                tiltY: 5
            }
        };

        this.init();
    }

    init() {
        // Set initial emotion
        this.setEmotion('happy');

        // Emotion button listeners
        document.querySelectorAll('.emotion-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const emotion = e.currentTarget.dataset.emotion;
                this.setEmotion(emotion);
                this.updateActiveButton(e.currentTarget);
            });
        });

        // Movement button listeners
        document.querySelectorAll('.move-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const direction = e.currentTarget.dataset.direction;
                this.moveRobot(direction);
            });
        });

        // Animation mode listeners
        document.getElementById('idleMode').addEventListener('click', () => {
            this.startIdleAnimation();
        });

        document.getElementById('randomMode').addEventListener('click', () => {
            this.startRandomEmotions();
        });

        document.getElementById('expressiveMode').addEventListener('click', () => {
            this.startExpressiveMode();
        });

        // Add subtle idle breathing animation
        this.startSubtleIdle();
    }

    setEmotion(emotionName) {
        const emotion = this.emotions[emotionName];
        if (!emotion) return;

        this.currentEmotion = emotionName;

        // Remove all animation classes
        this.faceContainer.className = 'face-container';

        // Update emoji with transition
        this.faceContainer.style.transform = 'scale(0)';

        setTimeout(() => {
            this.faceContainer.textContent = emotion.emoji;
            this.faceContainer.style.transform = 'scale(1)';

            // Add specific emotion animation class
            if (emotion.animation !== 'none') {
                this.faceContainer.classList.add(`emotion-${emotionName}`);
            }

            // Update display glow color
            this.emojiDisplay.style.boxShadow = `
                0 20px 60px rgba(0, 0, 0, 0.5),
                inset 0 -5px 20px ${emotion.color}33,
                0 0 0 10px ${emotion.color}22,
                0 0 40px ${emotion.color}66,
                0 0 80px ${emotion.color}44
            `;

            // Apply emotion-specific tilt
            this.applyTilt(emotion.tiltX, emotion.tiltY);
        }, 150);
    }

    moveRobot(direction) {
        const moves = {
            up: { x: -20, y: 0 },
            down: { x: 20, y: 0 },
            left: { x: 0, y: -20 },
            right: { x: 0, y: 20 },
            center: { x: 0, y: 0 }
        };

        const move = moves[direction];
        if (move) {
            this.applyTilt(move.x, move.y);
        }
    }

    applyTilt(x, y) {
        this.emojiDisplay.style.transform = `rotateX(${x}deg) rotateY(${y}deg)`;
    }

    updateActiveButton(activeBtn) {
        document.querySelectorAll('.emotion-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        activeBtn.classList.add('active');
    }

    startSubtleIdle() {
        // Gentle breathing animation for the display
        let angle = 0;
        setInterval(() => {
            angle += 0.02;
            const scale = 1 + Math.sin(angle) * 0.02;
            if (!this.isAnimating) {
                this.faceContainer.style.transform = `scale(${scale})`;
            }
        }, 50);
    }

    startIdleAnimation() {
        this.stopAllAnimations();
        const idleBtn = document.getElementById('idleMode');
        idleBtn.classList.add('active');

        this.isAnimating = true;

        // Gentle bobbing and slight rotations
        let angle = 0;
        this.animationInterval = setInterval(() => {
            angle += 0.03;
            const tiltX = Math.sin(angle) * 5;
            const tiltY = Math.cos(angle * 0.7) * 5;
            this.applyTilt(tiltX, tiltY);
        }, 50);
    }

    startRandomEmotions() {
        this.stopAllAnimations();
        const randomBtn = document.getElementById('randomMode');
        randomBtn.classList.add('active');

        this.isAnimating = true;

        // Change emotion randomly every 2 seconds
        const emotionNames = Object.keys(this.emotions);
        this.animationInterval = setInterval(() => {
            const randomEmotion = emotionNames[Math.floor(Math.random() * emotionNames.length)];
            this.setEmotion(randomEmotion);
        }, 2000);
    }

    startExpressiveMode() {
        this.stopAllAnimations();
        const expressiveBtn = document.getElementById('expressiveMode');
        expressiveBtn.classList.add('active');

        this.isAnimating = true;

        // Cycle through emotions with dramatic movements
        const emotionSequence = ['excited', 'happy', 'love', 'cool', 'wink', 'laugh', 'surprised'];
        let index = 0;

        this.animationInterval = setInterval(() => {
            this.setEmotion(emotionSequence[index]);

            // Add dramatic movement
            setTimeout(() => {
                const randomTiltX = (Math.random() - 0.5) * 30;
                const randomTiltY = (Math.random() - 0.5) * 30;
                this.applyTilt(randomTiltX, randomTiltY);
            }, 500);

            index = (index + 1) % emotionSequence.length;
        }, 1500);
    }

    stopAllAnimations() {
        this.isAnimating = false;
        if (this.animationInterval) {
            clearInterval(this.animationInterval);
            this.animationInterval = null;
        }

        // Remove active state from all animation buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.classList.remove('active');
        });

        // Reset to center position
        this.applyTilt(0, 0);
    }
}

// Initialize the robot when page loads
document.addEventListener('DOMContentLoaded', () => {
    const robot = new DeskEmojiRobot();

    // Add welcome animation
    setTimeout(() => {
        robot.setEmotion('excited');
        setTimeout(() => {
            robot.setEmotion('happy');
        }, 1000);
    }, 500);
});
