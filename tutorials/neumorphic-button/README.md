# Neumorphic Button

A soft UI tactile button with dual drop shadows and an interactive pressed-in inset state.

---

## What we're building

We will build a soft-UI Neumorphic button in Flutter. Neumorphism uses subtle light and dark dual shadows on a matching background color to give elements an extruded, extruded 3D appearance that transitions smoothly into an indented state when pressed.

<!-- [Screenshot / GIF: Soft extruded button pressing inward with realistic lighting] -->

---

## Concepts you'll learn

- Crafting realistic lighting with paired light and dark `BoxShadow` offsets.
- Handling touch interactions with `GestureDetector` (`onTapDown`, `onTapUp`, `onTapCancel`).
- Smoothly animating between elevated and pressed states with `AnimatedContainer`.
- Controlling corner radius, shape, and color contrast.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Establish background and shadow color palettes

Neumorphism works best when the button color matches the scaffold background precisely (e.g., `#E0E5EC`). The lighting is generated with a top-left white/highlight shadow and a bottom-right dark shadow.

```dart
import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsets padding;
  final Color backgroundColor;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.backgroundColor = const Color(0xFFE0E5EC),
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}
```

### Step 2: Track pressed state & shadow calculations

When elevated, shadows have positive offsets; when pressed, we reduce the shadow distance and blur radius to simulate indentation.

```dart
class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double offset = _isPressed ? 2.0 : 6.0;
    final double blur = _isPressed ? 4.0 : 12.0;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            // Dark shadow (bottom-right)
            BoxShadow(
              color: const Color(0xFFA3B1C6).withOpacity(0.6),
              offset: Offset(offset, offset),
              blurRadius: blur,
            ),
            // Light highlight (top-left)
            BoxShadow(
              color: Colors.white.withOpacity(0.9),
              offset: Offset(-offset, -offset),
              blurRadius: blur,
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}
```

---

## Challenges

1. **True Inset Shadow**: Build a custom `CustomPainter` to render inner (concave/inset) box shadows when pressed instead of flattening the outer shadows.
2. **Circular Variant**: Create an easily configurable `NeumorphicIconButton` with circular shape constraints.
3. **Toggle Switch**: Combine two neumorphic states into an interactive toggle switch or radio selector.

---

## Final result

Check out the complete standalone runnable implementation in [final/neumorphic_button.dart](final/neumorphic_button.dart).
