// Desk-Emoji Robot - Authentic Robot Face Version
// Based on the original desk-emoji firmware implementation
// Recreates the programmatic eye drawing system

class RobotFaceRenderer {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        this.ctx = this.canvas.getContext('2d');
        this.width = this.canvas.width;
        this.height = this.canvas.height;

        // Eye properties (similar to original firmware)
        this.leftEye = {
            x: 140,
            y: 200,
            width: 50,
            height: 50,
            radius: 10
        };
        this.rightEye = {
            x: 210,
            y: 200,
            width: 50,
            height: 50,
            radius: 10
        };

        // Original dimensions for reset
        this.originalEyeHeight = 50;
        this.originalEyeWidth = 50;
        this.originalRadius = 10;

        this.currentEmotion = 'center';
        this.isAnimating = false;
        this.animationFrame = null;
    }

    clear() {
        this.ctx.fillStyle = '#000000';
        this.ctx.fillRect(0, 0, this.width, this.height);
    }

    drawRoundedRect(x, y, width, height, radius, fill = true) {
        this.ctx.beginPath();
        this.ctx.moveTo(x + radius, y);
        this.ctx.lineTo(x + width - radius, y);
        this.ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
        this.ctx.lineTo(x + width, y + height - radius);
        this.ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
        this.ctx.lineTo(x + radius, y + height);
        this.ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
        this.ctx.lineTo(x, y + radius);
        this.ctx.quadraticCurveTo(x, y, x + radius, y);
        this.ctx.closePath();

        if (fill) {
            this.ctx.fill();
        } else {
            this.ctx.stroke();
        }
    }

    drawTriangle(x1, y1, x2, y2, x3, y3) {
        this.ctx.beginPath();
        this.ctx.moveTo(x1, y1);
        this.ctx.lineTo(x2, y2);
        this.ctx.lineTo(x3, y3);
        this.ctx.closePath();
        this.ctx.fill();
    }

    drawEyes() {
        this.ctx.fillStyle = '#FFFFFF';

        // Draw left eye
        this.drawRoundedRect(
            this.leftEye.x,
            this.leftEye.y,
            this.leftEye.width,
            this.leftEye.height,
            this.leftEye.radius
        );

        // Draw right eye
        this.drawRoundedRect(
            this.rightEye.x,
            this.rightEye.y,
            this.rightEye.width,
            this.rightEye.height,
            this.rightEye.radius
        );
    }

    // Center position (neutral)
    eyeCenter() {
        this.clear();
        this.leftEye.x = 140;
        this.leftEye.y = 200;
        this.rightEye.x = 210;
        this.rightEye.y = 200;
        this.leftEye.width = this.rightEye.width = this.originalEyeWidth;
        this.leftEye.height = this.rightEye.height = this.originalEyeHeight;
        this.leftEye.radius = this.rightEye.radius = this.originalRadius;
        this.drawEyes();
    }

    // Happy expression (upturned eyes)
    eyeHappy() {
        this.eyeCenter();
        this.ctx.fillStyle = '#000000';

        // Create upturned effect with triangles (like smiling eyes)
        for (let i = 0; i < 10; i++) {
            let offset = i * 2;

            // Left eye - bottom triangles
            this.drawTriangle(
                this.leftEye.x - offset,
                this.leftEye.y + this.leftEye.height,
                this.leftEye.x + this.leftEye.width / 2,
                this.leftEye.y + this.leftEye.height - offset,
                this.leftEye.x + this.leftEye.width + offset,
                this.leftEye.y + this.leftEye.height
            );

            // Right eye - bottom triangles
            this.drawTriangle(
                this.rightEye.x - offset,
                this.rightEye.y + this.rightEye.height,
                this.rightEye.x + this.rightEye.width / 2,
                this.rightEye.y + this.rightEye.height - offset,
                this.rightEye.x + this.rightEye.width + offset,
                this.rightEye.y + this.rightEye.height
            );
        }
    }

    // Sad expression (downturned eyes)
    eyeSad() {
        this.eyeCenter();
        this.ctx.fillStyle = '#000000';

        // Create downturned effect with triangles
        for (let i = 0; i < 10; i++) {
            let offset = i * 2;

            // Left eye - top triangles
            this.drawTriangle(
                this.leftEye.x - offset,
                this.leftEye.y,
                this.leftEye.x + this.leftEye.width / 2,
                this.leftEye.y + offset,
                this.leftEye.x + this.leftEye.width + offset,
                this.leftEye.y
            );

            // Right eye - top triangles
            this.drawTriangle(
                this.rightEye.x - offset,
                this.rightEye.y,
                this.rightEye.x + this.rightEye.width / 2,
                this.rightEye.y + offset,
                this.rightEye.x + this.rightEye.width + offset,
                this.rightEye.y
            );
        }
    }

    // Angry expression (diagonal triangles)
    eyeAngry() {
        this.eyeCenter();
        this.ctx.fillStyle = '#000000';

        // Left eye - angry brow (top-left to bottom-right)
        for (let i = 0; i < 15; i++) {
            this.drawTriangle(
                this.leftEye.x,
                this.leftEye.y + i,
                this.leftEye.x + this.leftEye.width - i,
                this.leftEye.y,
                this.leftEye.x + this.leftEye.width,
                this.leftEye.y
            );
        }

        // Right eye - angry brow (top-right to bottom-left)
        for (let i = 0; i < 15; i++) {
            this.drawTriangle(
                this.rightEye.x,
                this.rightEye.y,
                this.rightEye.x + i,
                this.rightEye.y,
                this.rightEye.x + this.rightEye.width,
                this.rightEye.y + i
            );
        }
    }

    // Surprised expression (wide eyes)
    eyeSurprised() {
        this.eyeCenter();

        // Animate eyes getting bigger
        let steps = 10;
        let currentStep = 0;

        const animate = () => {
            if (currentStep < steps) {
                this.clear();
                let scale = 1 + (currentStep / steps) * 0.5;
                let radiusScale = Math.max(1, this.originalRadius - currentStep);

                this.leftEye.width = this.originalEyeWidth * scale;
                this.leftEye.height = this.originalEyeHeight * scale;
                this.rightEye.width = this.originalEyeWidth * scale;
                this.rightEye.height = this.originalEyeHeight * scale;
                this.leftEye.radius = radiusScale;
                this.rightEye.radius = radiusScale;

                // Center the expanded eyes
                this.leftEye.x = 140 - (this.leftEye.width - this.originalEyeWidth) / 2;
                this.leftEye.y = 200 - (this.leftEye.height - this.originalEyeHeight) / 2;
                this.rightEye.x = 210 - (this.rightEye.width - this.originalEyeWidth) / 2;
                this.rightEye.y = 200 - (this.rightEye.height - this.originalEyeHeight) / 2;

                this.drawEyes();
                currentStep++;
                setTimeout(animate, 50);
            }
        };
        animate();
    }

    // Sleepy expression (closed eyes)
    eyeSleepy() {
        this.clear();
        this.leftEye.height = 4;
        this.rightEye.height = 4;
        this.leftEye.y = 225;
        this.rightEye.y = 225;
        this.leftEye.radius = 2;
        this.rightEye.radius = 2;
        this.drawEyes();
    }

    // Waking up animation
    eyeWakeup() {
        let steps = 20;
        let currentStep = 0;

        const animate = () => {
            if (currentStep <= steps) {
                this.clear();
                let progress = currentStep / steps;

                this.leftEye.height = 4 + progress * (this.originalEyeHeight - 4);
                this.rightEye.height = 4 + progress * (this.originalEyeHeight - 4);
                this.leftEye.y = 225 - progress * 25;
                this.rightEye.y = 225 - progress * 25;
                this.leftEye.radius = 2 + progress * (this.originalRadius - 2);
                this.rightEye.radius = 2 + progress * (this.originalRadius - 2);

                this.drawEyes();
                currentStep++;
                setTimeout(animate, 50);
            }
        };
        animate();
    }

    // Blinking animation
    eyeBlink() {
        let closeSteps = 5;
        let currentStep = 0;
        let originalHeight = this.leftEye.height;
        let originalY = this.leftEye.y;

        const animate = () => {
            if (currentStep <= closeSteps * 2) {
                this.clear();

                if (currentStep <= closeSteps) {
                    // Closing
                    let progress = currentStep / closeSteps;
                    this.leftEye.height = originalHeight * (1 - progress);
                    this.rightEye.height = originalHeight * (1 - progress);
                    this.leftEye.y = originalY + (originalHeight * progress) / 2;
                    this.rightEye.y = originalY + (originalHeight * progress) / 2;
                } else {
                    // Opening
                    let progress = (currentStep - closeSteps) / closeSteps;
                    this.leftEye.height = originalHeight * progress;
                    this.rightEye.height = originalHeight * progress;
                    this.leftEye.y = originalY + (originalHeight * (1 - progress)) / 2;
                    this.rightEye.y = originalY + (originalHeight * (1 - progress)) / 2;
                }

                this.drawEyes();
                currentStep++;
                setTimeout(animate, 30);
            } else {
                // Restore original
                this.leftEye.height = originalHeight;
                this.rightEye.height = originalHeight;
                this.leftEye.y = originalY;
                this.rightEye.y = originalY;
                this.drawEyes();
            }
        };
        animate();
    }

    // Look left
    eyeLookLeft() {
        this.eyeCenter();
        this.leftEye.x -= 20;
        this.rightEye.x -= 20;
        this.clear();
        this.drawEyes();
    }

    // Look right
    eyeLookRight() {
        this.eyeCenter();
        this.leftEye.x += 20;
        this.rightEye.x += 20;
        this.clear();
        this.drawEyes();
    }

    setEmotion(emotion) {
        this.currentEmotion = emotion;

        switch(emotion) {
            case 'happy':
                this.eyeHappy();
                break;
            case 'sad':
                this.eyeSad();
                break;
            case 'angry':
                this.eyeAngry();
                break;
            case 'surprised':
                this.eyeSurprised();
                break;
            case 'sleepy':
                this.eyeSleepy();
                break;
            case 'wakeup':
                this.eyeWakeup();
                break;
            case 'blink':
                this.eyeBlink();
                break;
            case 'lookLeft':
                this.eyeLookLeft();
                break;
            case 'lookRight':
                this.eyeLookRight();
                break;
            case 'center':
            default:
                this.eyeCenter();
                break;
        }
    }
}

class DeskEmojiRobotFace {
    constructor() {
        this.renderer = new RobotFaceRenderer('robotCanvas');
        this.robotBody = document.getElementById('robotBody');
        this.emojiDisplay = document.getElementById('emojiDisplay');
        this.isAnimating = false;
        this.animationInterval = null;

        this.init();
    }

    init() {
        // Set initial emotion
        this.renderer.setEmotion('center');

        // Add glow effect
        this.updateGlowColor('#4ecca3');

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

        // Welcome animation
        setTimeout(() => {
            this.setEmotion('wakeup');
            setTimeout(() => {
                this.setEmotion('happy');
            }, 1500);
        }, 500);
    }

    setEmotion(emotion) {
        this.renderer.setEmotion(emotion);

        // Update glow based on emotion
        const glowColors = {
            happy: '#FFD700',
            sad: '#4682B4',
            angry: '#DC143C',
            surprised: '#FFD700',
            sleepy: '#778899',
            wakeup: '#4ecca3',
            blink: '#4ecca3',
            lookLeft: '#667eea',
            lookRight: '#667eea',
            center: '#4ecca3'
        };

        this.updateGlowColor(glowColors[emotion] || '#4ecca3');
    }

    updateGlowColor(color) {
        this.emojiDisplay.style.boxShadow = `
            0 20px 60px rgba(0, 0, 0, 0.5),
            inset 0 -5px 20px ${color}33,
            0 0 0 10px ${color}22,
            0 0 40px ${color}66,
            0 0 80px ${color}44
        `;
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
            this.emojiDisplay.style.transform = `rotateX(${move.x}deg) rotateY(${move.y}deg)`;
        }
    }

    updateActiveButton(activeBtn) {
        document.querySelectorAll('.emotion-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        activeBtn.classList.add('active');
    }

    startIdleAnimation() {
        this.stopAllAnimations();
        const idleBtn = document.getElementById('idleMode');
        idleBtn.classList.add('active');

        this.isAnimating = true;

        // Periodic blinking
        this.animationInterval = setInterval(() => {
            this.renderer.eyeBlink();
        }, 3000);
    }

    startRandomEmotions() {
        this.stopAllAnimations();
        const randomBtn = document.getElementById('randomMode');
        randomBtn.classList.add('active');

        this.isAnimating = true;

        const emotions = ['happy', 'sad', 'angry', 'surprised', 'sleepy', 'lookLeft', 'lookRight'];
        this.animationInterval = setInterval(() => {
            const randomEmotion = emotions[Math.floor(Math.random() * emotions.length)];
            this.setEmotion(randomEmotion);
        }, 2000);
    }

    startExpressiveMode() {
        this.stopAllAnimations();
        const expressiveBtn = document.getElementById('expressiveMode');
        expressiveBtn.classList.add('active');

        this.isAnimating = true;

        const sequence = ['wakeup', 'happy', 'surprised', 'lookLeft', 'lookRight', 'happy'];
        let index = 0;

        this.animationInterval = setInterval(() => {
            this.setEmotion(sequence[index]);
            index = (index + 1) % sequence.length;
        }, 1800);
    }

    stopAllAnimations() {
        this.isAnimating = false;
        if (this.animationInterval) {
            clearInterval(this.animationInterval);
            this.animationInterval = null;
        }

        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.classList.remove('active');
        });

        this.emojiDisplay.style.transform = 'rotateX(0deg) rotateY(0deg)';
    }
}

// Initialize when page loads
document.addEventListener('DOMContentLoaded', () => {
    new DeskEmojiRobotFace();
});
