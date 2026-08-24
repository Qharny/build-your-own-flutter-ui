# Custom Shimmer Loader

A smooth shimmering skeleton placeholder widget powered by `ShaderMask` and linear gradient translation.

---

## What we're building

We will create a lightweight shimmer loading effect from scratch. It creates a dynamic sweeping metallic highlight across skeleton placeholders, signaling content loading without requiring external packages.

<!-- [Screenshot / GIF: Sweeping gradient highlight over placeholder blocks] -->

---

## Concepts you'll learn

- How `ShaderMask` masks a child widget tree with a custom shader or gradient.
- Translating `LinearGradient` coordinates across an animation cycle using `AnimationController`.
- Designing skeleton card mockups with customizable base and highlight colors.
- Creating reusable `ShimmerLoading` wrapper widgets.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Create the Shimmer widget with AnimationController

We create an animated widget using `SingleTickerProviderStateMixin` that continuously loops an `AnimationController` from 0.0 to 1.0.

```dart
import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE2E8F0),
    this.highlightColor = const Color(0xFFF8FAFC),
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer>
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
    // ShaderMask will be applied in the next step
    return widget.child;
  }
}
```

### Step 2: Apply the ShaderMask and translate gradient

We wrap the child in `AnimatedBuilder` and `ShaderMask`. The `LinearGradient` offset is dynamically computed based on `_controller.value`.

```dart
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final double progress = _controller.value;
            // Slide the gradient from left (-1.0) to right (2.0)
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(slidePercent: progress),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
```

### Step 3: Implement GradientTransform

Flutter's `GradientTransform` allows us to shift the shader's coordinate space along the X-axis:

```dart
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    // Translate from -bounds.width to +bounds.width * 2
    final double translation = bounds.width * (slidePercent * 3 - 1.5);
    return Matrix4.translationValues(translation, 0.0, 0.0);
  }
}
```

---

## Challenges

1. **Synchronized List Loading**: Synchronize a single `AnimationController` across all list items using an `InheritedWidget` so all skeleton cards shimmer in unison.
2. **Directional Control**: Support shimmer angles (left-to-right, right-to-left, top-to-bottom, diagonal).
3. **Pulse Effect**: Add an optional subtle opacity pulse option alongside the shimmer gradient sweep.

---

## Final result

Check out the complete standalone runnable implementation in [final/custom_shimmer_loader.dart](final/custom_shimmer_loader.dart).
