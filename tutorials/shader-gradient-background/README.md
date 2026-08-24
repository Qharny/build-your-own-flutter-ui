# Animated Shader Gradient Background

A fluid, organic multi-color animated mesh gradient background rendered via `CustomPainter` and orbital math.

---

## What we're building

We will create an ambient, continuously morphing multi-color gradient background. Multiple glowing radial color points drift in orbital trigonometric paths across the canvas, blending into a seamless, modern Aurora-like backdrop.

<!-- [Screenshot / GIF: Ambient fluid colors slowly morphing and blending on canvas] -->

---

## Concepts you'll learn

- Custom canvas painting with `CustomPainter` and `Canvas.drawPaint()`.
- Creating and blending multiple `RadialGradient` shaders with `BlendMode.screen` or `BlendMode.plus`.
- Calculating smooth continuous orbital paths using sine and cosine functions: $x = c_x + r \cdot \cos(\omega t)$.
- Linking `AnimationController` directly to continuous canvas repainting.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Create the AnimatedMeshPainter

We define the painter with the animated progress value (from 0.0 to $2\pi$):

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AmbientGradientPainter extends CustomPainter {
  final double animationValue;
  final List<Color> colors;

  AmbientGradientPainter({
    required this.animationValue,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint dark base background
    final backgroundPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final double t = animationValue * 2 * math.pi;

    // 2. Define orbital color orbs
    _drawGlowingOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.3 + math.sin(t) * (size.width * 0.2),
        size.height * 0.3 + math.cos(t) * (size.height * 0.15),
      ),
      radius: size.width * 0.6,
      color: colors[0],
    );

    _drawGlowingOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.7 + math.cos(t * 0.8) * (size.width * 0.2),
        size.height * 0.6 + math.sin(t * 0.8) * (size.height * 0.2),
      ),
      radius: size.width * 0.7,
      color: colors[1],
    );

    _drawGlowingOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.5 + math.sin(t * 1.2) * (size.width * 0.25),
        size.height * 0.8 + math.cos(t * 1.2) * (size.height * 0.15),
      ),
      radius: size.width * 0.65,
      color: colors[2],
    );
  }

  void _drawGlowingOrb({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required Color color,
  }) {
    final Paint paint = Paint()
      ..blendMode = BlendMode.screen
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.55),
          color.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant AmbientGradientPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
```

### Step 2: Build the Animated Gradient Background Widget

We hook the painter up to an `AnimationController` running on a continuous loop with `repeat()`.

```dart
class AnimatedShaderBackground extends StatefulWidget {
  final Widget? child;
  final List<Color> colors;
  final Duration duration;

  const AnimatedShaderBackground({
    super.key,
    this.child,
    this.colors = const [
      Color(0xFF6366F1), // Indigo
      Color(0xFFEC4899), // Pink
      Color(0xFF06B6D4), // Cyan
    ],
    this.duration = const Duration(seconds: 12),
  });

  @override
  State<AnimatedShaderBackground> createState() => _AnimatedShaderBackgroundState();
}

class _AnimatedShaderBackgroundState extends State<AnimatedShaderBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              size: Size.infinite,
              painter: AmbientGradientPainter(
                animationValue: _controller.value,
                colors: widget.colors,
              ),
            );
          },
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
```

---

## Challenges

1. **Custom Fragment Shaders (.frag)**: Upgrade the canvas math to a hardware-accelerated GLSL/SPIR-V fragment shader loaded via Flutter's `FragmentProgram.fromAsset()`.
2. **Interactive Touch Repulsion**: Make glowing orbs react and move away from pointer drag locations on touch devices.
3. **Noise Texture Overlay**: Draw a subtle semi-transparent film grain/noise pattern overlay over the gradient to eliminate color banding artifacts.

---

## Final result

Check out the complete standalone runnable implementation in [final/shader_gradient_background.dart](final/shader_gradient_background.dart).
