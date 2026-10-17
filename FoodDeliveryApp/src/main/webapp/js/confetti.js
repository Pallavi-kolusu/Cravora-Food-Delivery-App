/**
 * CRAVORA FOOD DELIVERY - ULTRA CELEBRATION CONFETTI ENGINE
 * Pure Vanilla JavaScript (ES5) - No classes, No arrow functions,
 * No template literals, No optional chaining. Maximum compatibility.
 */

(function (window, document) {

    // Default vibrant Cravora color palette
    var CRAVORA_PALETTE = [
        '#FF5400',
        '#FF7A00',
        '#10B981',
        '#059669',
        '#F59E0B',
        '#FBBF24',
        '#8B5CF6',
        '#EC4899',
        '#3B82F6',
        '#06B6D4'
    ];

    var FOOD_EMOJIS = ['\uD83C\uDF55', '\uD83C\uDF54', '\uD83C\uDF2E', '\uD83C\uDF70', '\uD83C\uDF69', '\uD83C\uDF66', '\uD83C\uDF5F', '\uD83E\uDD51', '\uD83C\uDF5C', '\u2B50', '\uD83C\uDF89', '\u2728', '\uD83E\uDD73'];

    // Canvas & Animation State
    var canvas = null;
    var ctx = null;
    var particles = [];
    var animationFrameId = null;
    var dpr = window.devicePixelRatio || 1;

    // ─── Canvas Setup ────────────────────────────────────────────────────────────

    function getCanvas() {
        if (!canvas) {
            canvas = document.createElement('canvas');
            canvas.id = 'cravora-confetti-canvas';
            canvas.setAttribute('aria-hidden', 'true');
            canvas.style.position = 'fixed';
            canvas.style.top = '0';
            canvas.style.left = '0';
            canvas.style.width = '100vw';
            canvas.style.height = '100vh';
            canvas.style.pointerEvents = 'none';
            canvas.style.zIndex = '999999';
            document.body.appendChild(canvas);
            ctx = canvas.getContext('2d');
            resizeCanvas();
            window.addEventListener('resize', resizeCanvas);
        }
        return canvas;
    }

    function resizeCanvas() {
        if (!canvas) return;
        dpr = window.devicePixelRatio || 1;
        canvas.width = window.innerWidth * dpr;
        canvas.height = window.innerHeight * dpr;
        if (ctx) {
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.scale(dpr, dpr);
        }
    }

    // ─── Victory Chime (Web Audio API) ──────────────────────────────────────────

    function playVictoryChime() {
        try {
            var AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (!AudioCtx) return;
            var audioCtx = new AudioCtx();
            if (audioCtx.state === 'suspended') {
                audioCtx.resume();
            }

            var now = audioCtx.currentTime;
            var notes = [
                { freq: 523.25, time: 0.00, dur: 0.4 },
                { freq: 659.25, time: 0.08, dur: 0.4 },
                { freq: 783.99, time: 0.16, dur: 0.4 },
                { freq: 1046.50, time: 0.24, dur: 0.7 }
            ];

            for (var i = 0; i < notes.length; i++) {
                var n = notes[i];
                var osc = audioCtx.createOscillator();
                var gain = audioCtx.createGain();

                osc.type = 'triangle';
                osc.frequency.setValueAtTime(n.freq, now + n.time);

                gain.gain.setValueAtTime(0.001, now + n.time);
                gain.gain.exponentialRampToValueAtTime(0.12, now + n.time + 0.03);
                gain.gain.exponentialRampToValueAtTime(0.0001, now + n.time + n.dur);

                osc.connect(gain);
                gain.connect(audioCtx.destination);

                osc.start(now + n.time);
                osc.stop(now + n.time + n.dur);
            }
        } catch (e) {
            // Audio not supported — ignore silently
        }
    }

    // ─── Particle (Confetti Piece) ───────────────────────────────────────────────

    function ConfettiParticle(opts) {
        var originX = (opts.origin && opts.origin.x !== undefined)
            ? opts.origin.x * window.innerWidth
            : window.innerWidth * 0.5;
        var originY = (opts.origin && opts.origin.y !== undefined)
            ? opts.origin.y * window.innerHeight
            : window.innerHeight * 0.5;

        this.x = originX;
        this.y = originY;

        var angle = (opts.angle !== undefined ? opts.angle : 90) * (Math.PI / 180);
        var spread = (opts.spread !== undefined ? opts.spread : 70) * (Math.PI / 180);
        var startVelocity = opts.startVelocity || 45;

        var randomAngle = angle + (Math.random() - 0.5) * spread;
        var speed = startVelocity * (0.6 + Math.random() * 0.8);

        this.vx = Math.cos(randomAngle) * speed;
        this.vy = -Math.sin(randomAngle) * speed;

        this.gravity = opts.gravity !== undefined ? opts.gravity : 0.7;
        this.drag    = opts.drag    !== undefined ? opts.drag    : 0.95;
        this.wind    = opts.wind    !== undefined ? opts.wind    : (Math.random() - 0.5) * 0.4;

        this.shape = opts.shape || (Math.random() > 0.4 ? 'square' : (Math.random() > 0.5 ? 'circle' : 'ribbon'));
        this.color = opts.color || CRAVORA_PALETTE[Math.floor(Math.random() * CRAVORA_PALETTE.length)];
        this.emoji = opts.emoji || FOOD_EMOJIS[Math.floor(Math.random() * FOOD_EMOJIS.length)];

        this.scalar = opts.scalar || 1;
        this.size   = (this.shape === 'ribbon'
            ? (12 + Math.random() * 10)
            : (6  + Math.random() * 8)) * this.scalar;

        this.rotation      = Math.random() * 360;
        this.rotationSpeed = (Math.random() - 0.5) * 15;
        this.wobble        = Math.random() * 10;
        this.wobbleSpeed   = 0.08 + Math.random() * 0.07;

        this.opacity     = 1;
        this.ticks       = opts.ticks || (180 + Math.random() * 100);
        this.currentTick = 0;
        this.decay       = opts.decay || 0.007;
    }

    ConfettiParticle.prototype.update = function () {
        this.currentTick++;
        this.vx += this.wind;
        this.vx *= this.drag;
        this.vy *= this.drag;
        this.vy += this.gravity;

        this.x += this.vx;
        this.y += this.vy;

        this.rotation += this.rotationSpeed;
        this.wobble   += this.wobbleSpeed;

        if (this.currentTick > this.ticks * 0.6) {
            this.opacity -= this.decay;
        }

        return this.opacity > 0 && this.y < window.innerHeight + 100;
    };

    ConfettiParticle.prototype.draw = function (c) {
        c.save();
        c.translate(this.x, this.y);
        c.rotate((this.rotation * Math.PI) / 180);
        c.scale(Math.cos(this.wobble), 1);
        c.globalAlpha = Math.max(0, Math.min(1, this.opacity));

        if (this.shape === 'square') {
            c.fillStyle = this.color;
            c.fillRect(-this.size / 2, -this.size / 2, this.size, this.size);

        } else if (this.shape === 'circle') {
            c.fillStyle = this.color;
            c.beginPath();
            c.arc(0, 0, this.size / 2, 0, Math.PI * 2);
            c.fill();

        } else if (this.shape === 'ribbon') {
            c.fillStyle = this.color;
            c.fillRect(-this.size * 0.25, -this.size * 0.8, this.size * 0.5, this.size * 1.6);

        } else if (this.shape === 'star') {
            c.fillStyle = this.color;
            drawStar(c, 0, 0, 5, this.size * 0.8, this.size * 0.4);

        } else if (this.shape === 'emoji') {
            c.font = Math.floor(this.size * 1.8) + 'px "Segoe UI Emoji", "Apple Color Emoji", sans-serif';
            c.textAlign = 'center';
            c.textBaseline = 'middle';
            c.fillText(this.emoji, 0, 0);
        }

        c.restore();
    };

    // ─── Star Draw Helper ────────────────────────────────────────────────────────

    function drawStar(c, cx, cy, spikes, outerRadius, innerRadius) {
        var rot  = (Math.PI / 2) * 3;
        var x    = cx;
        var y    = cy;
        var step = Math.PI / spikes;
        var i;

        c.beginPath();
        c.moveTo(cx, cy - outerRadius);
        for (i = 0; i < spikes; i++) {
            x = cx + Math.cos(rot) * outerRadius;
            y = cy + Math.sin(rot) * outerRadius;
            c.lineTo(x, y);
            rot += step;

            x = cx + Math.cos(rot) * innerRadius;
            y = cy + Math.sin(rot) * innerRadius;
            c.lineTo(x, y);
            rot += step;
        }
        c.lineTo(cx, cy - outerRadius);
        c.closePath();
        c.fill();
    }

    // ─── Animation Loop ──────────────────────────────────────────────────────────

    function render() {
        if (!canvas || !ctx) return;

        ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);

        var alive = [];
        for (var i = 0; i < particles.length; i++) {
            var p = particles[i];
            if (p.update()) {
                p.draw(ctx);
                alive.push(p);
            }
        }
        particles = alive;

        if (particles.length > 0) {
            animationFrameId = requestAnimationFrame(render);
        } else {
            animationFrameId = null;
            if (canvas && canvas.parentNode) {
                ctx.clearRect(0, 0, window.innerWidth, window.innerHeight);
            }
        }
    }

    function ensureRenderLoop() {
        getCanvas();
        if (!animationFrameId) {
            animationFrameId = requestAnimationFrame(render);
        }
    }

    // ─── Public Confetti API ─────────────────────────────────────────────────────

    var Confetti = {

        burst: function (options) {
            options = options || {};
            var count  = options.particleCount || 60;
            var shapes = options.shapes || ['square', 'circle', 'ribbon'];
            var colors = options.colors || CRAVORA_PALETTE;
            var emojis = options.emojis || FOOD_EMOJIS;

            for (var i = 0; i < count; i++) {
                var shape = shapes[Math.floor(Math.random() * shapes.length)];
                var color = colors[Math.floor(Math.random() * colors.length)];
                var emoji = emojis[Math.floor(Math.random() * emojis.length)];

                var particleOpts = {};
                for (var key in options) {
                    if (options.hasOwnProperty(key)) {
                        particleOpts[key] = options[key];
                    }
                }
                particleOpts.shape = shape;
                particleOpts.color = color;
                particleOpts.emoji = emoji;

                particles.push(new ConfettiParticle(particleOpts));
            }

            ensureRenderLoop();
        },

        doubleCannon: function (options) {
            options = options || {};
            var count = options.particleCount || 45;

            this.burst({
                particleCount: count,
                angle: 60,
                spread: 65,
                startVelocity: 55,
                origin: { x: 0.05, y: 0.95 },
                shapes: ['square', 'circle', 'ribbon', 'star', 'emoji'],
                scalar: 1.1
            });

            this.burst({
                particleCount: count,
                angle: 120,
                spread: 65,
                startVelocity: 55,
                origin: { x: 0.95, y: 0.95 },
                shapes: ['square', 'circle', 'ribbon', 'star', 'emoji'],
                scalar: 1.1
            });
        },

        firework: function (x, y, options) {
            x = (x !== undefined) ? x : 0.5;
            y = (y !== undefined) ? y : 0.5;
            options = options || {};
            this.burst({
                particleCount: 50,
                angle: 90,
                spread: 360,
                startVelocity: 35,
                gravity: 0.5,
                origin: { x: x, y: y },
                shapes: ['square', 'star', 'circle']
            });
        },

        foodBlast: function (x, y, count) {
            x     = (x !== undefined) ? x : 0.5;
            y     = (y !== undefined) ? y : 0.5;
            count = count || 25;
            this.burst({
                particleCount: count,
                angle: 90,
                spread: 360,
                startVelocity: 32,
                gravity: 0.45,
                origin: { x: x, y: y },
                shapes: ['emoji', 'star'],
                scalar: 1.3
            });
        },

        starShower: function (x, y, count) {
            x     = (x !== undefined) ? x : 0.5;
            y     = (y !== undefined) ? y : 0.4;
            count = count || 35;
            this.burst({
                particleCount: count,
                angle: 90,
                spread: 140,
                startVelocity: 38,
                gravity: 0.5,
                origin: { x: x, y: y },
                colors: ['#F59E0B', '#FBBF24', '#FEF08A', '#FF5400', '#FFFFFF'],
                shapes: ['star', 'circle'],
                scalar: 1.2
            });
        },

        rain: function (durationMs) {
            durationMs = durationMs || 3000;
            var end = Date.now() + durationMs;
            var interval = setInterval(function () {
                if (Date.now() > end) {
                    clearInterval(interval);
                    return;
                }
                Confetti.burst({
                    particleCount: 6,
                    angle: 270,
                    spread: 45,
                    startVelocity: 15,
                    gravity: 0.4,
                    origin: { x: Math.random(), y: 0.0 },
                    shapes: ['square', 'circle', 'ribbon', 'emoji'],
                    scalar: 0.9
                });
            }, 100);
        },

        orderSuccess: function () {
            var self = this;

            // Wave 1: Left & Right Cannons
            self.doubleCannon({ particleCount: 50, startVelocity: 60 });

            // Wave 2: Center burst with emojis (+350ms)
            setTimeout(function () {
                self.burst({
                    particleCount: 60,
                    angle: 90,
                    spread: 120,
                    startVelocity: 48,
                    origin: { x: 0.5, y: 0.65 },
                    shapes: ['emoji', 'star', 'ribbon', 'square'],
                    scalar: 1.25
                });
            }, 350);

            // Wave 3: Corner boost (+750ms)
            setTimeout(function () {
                self.doubleCannon({ particleCount: 35, startVelocity: 50 });
            }, 750);

            // Wave 4: Gentle rain for 3.2 seconds (+1000ms)
            setTimeout(function () {
                self.rain(3200);
            }, 1000);

            playVictoryChime();
        },

        profileSuccess: function () {
            this.burst({
                particleCount: 40,
                angle: 90,
                spread: 100,
                startVelocity: 35,
                origin: { x: 0.5, y: 0.25 },
                shapes: ['star', 'circle', 'square', 'emoji'],
                colors: ['#10B981', '#059669', '#FF5400', '#F59E0B'],
                scalar: 1.1
            });
            playVictoryChime();
        },

        playChime: playVictoryChime
    };

    // ─── Declarative data-confetti click binding ─────────────────────────────────

    document.addEventListener('DOMContentLoaded', function () {
        document.body.addEventListener('click', function (e) {
            var target = e.target;
            while (target && target !== document.body) {
                if (target.getAttribute && target.getAttribute('data-confetti')) {
                    break;
                }
                target = target.parentNode;
            }
            if (!target || !target.getAttribute) return;

            var mode = target.getAttribute('data-confetti');
            if (!mode) return;

            var rect   = target.getBoundingClientRect();
            var clickX = (rect.left + rect.width  / 2) / window.innerWidth;
            var clickY = (rect.top  + rect.height / 2) / window.innerHeight;

            if (mode === 'food') {
                Confetti.foodBlast(clickX, clickY);
            } else if (mode === 'stars') {
                Confetti.starShower(clickX, clickY);
            } else if (mode === 'cannon') {
                Confetti.doubleCannon();
            } else {
                Confetti.firework(clickX, clickY);
            }
        });
    });

    // Expose globally
    window.CravoraConfetti = Confetti;

})(window, document);
