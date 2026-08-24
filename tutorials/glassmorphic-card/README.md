# Glassmorphic Card

A frosted-glass card UI component featuring Gaussian blur, translucent gradient backgrounds, and subtle specular borders.

---

## What we're building

We will build a modern glassmorphic (frosted glass) card widget in Flutter. When placed on top of colorful backgrounds or images, the card creates an authentic translucent frosted glass effect with blurred backdrop pixels, semi-transparent gradient fills, and subtle border highlights.

<!-- [Screenshot / GIF: Glassmorphic card over a vibrant gradient background] -->

---

## Concepts you'll learn

- Using `BackdropFilter` and `ImageFilter.blur` to blur background pixels.
- Using `ClipRRect` to constrain the backdrop blur within rounded corners.
- Applying semi-transparent `LinearGradient` inside `BoxDecoration` for specular glass reflections.
- Adding delicate inner and outer borders with gradient strokes.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required (pure Flutter framework widgets)

---

## Step-by-step

### Step 1: Clip the container bounds

`BackdropFilter` by default blurs everything under the entire parent layer. To constrain the blur strictly to the card's rounded shape, we must wrap it with a `ClipRRect`.

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.15,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          // Card content goes here
        ),
      ),
    );
  }
}
```

### Step 2: Add translucent gradient decoration

To mimic real glass, we use a top-left to bottom-right `LinearGradient` with subtle white opacity variations, paired with a thin gradient border.

```dart
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity + 0.1),
                Colors.white.withOpacity(opacity * 0.5),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(24.0),
          child: child,
        ),
```

### Step 3: Put it all together

Combine the frosted glass card with a colorful background stack to preview the frosted glass refraction in action:

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.opacity = 0.15,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity + 0.12),
                Colors.white.withOpacity(opacity * 0.4),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## Challenges

1. **Dynamic Lighting**: Animate the gradient angles or colors in response to device gyroscope or mouse cursor hover position.
2. **Dark Mode Adaptation**: Support an adaptive glass color palette that switches to dark tinted acrylic glass on dark backgrounds.
3. **Inner Shadows**: Implement an inner border glow using a custom `BoxDecoration` or `CustomPainter`.

---

## Final result

Check out the complete standalone runnable implementation in [final/glassmorphic_card.dart](final/glassmorphic_card.dart).
