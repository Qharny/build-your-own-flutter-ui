# Expandable Floating Action Button (Speed Dial)

An animated expandable Floating Action Button with rotating main trigger, staggered speed-dial action items, and backdrop overlay.

---

## What we're building

We will create a multi-action Expandable FAB (Speed Dial). Tapping the primary FAB triggers a smooth 45-degree rotation into a close icon while revealing multiple staggered action buttons that float upwards with scale, fade, and translation animations.

<!-- [Screenshot / GIF: FAB rotating and popping open 3 sub-action buttons] -->

---

## Concepts you'll learn

- Coordinating multiple staggered animations with `AnimationController` and `CurvedAnimation`.
- Transforming and rotating widgets with `Transform.rotate` and `Matrix4`.
- Animating translation offsets using `Transform.translate` or `SlideTransition`.
- Managing open/closed overlay states and backdrop dismiss taps.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Define the Speed Dial Action Item

Create a simple data class for the subsidiary action buttons:

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ActionButton {
  final Widget icon;
  final String? tooltip;
  final VoidCallback onPressed;
  final Color? color;

  const ActionButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });
}
```

### Step 2: Build the ExpandableFab widget

Manage the open/close boolean state with an `AnimationController`:

```dart
class ExpandableFab extends StatefulWidget {
  final double distance;
  final List<ActionButton> children;
  final IconData openIcon;
  final IconData closeIcon;

  const ExpandableFab({
    super.key,
    required this.distance,
    required this.children,
    this.openIcon = Icons.add,
    this.closeIcon = Icons.close,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
```

### Step 3: Position each child with animated offset and scale

Each child button is calculated at a vertical offset multiplied by its index:

```dart
  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = widget.distance;

    for (var i = 0; i < count; i++) {
      final double dy = (i + 1) * step;
      children.add(
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final double progress = _expandAnimation.value;
            return Positioned(
              right: 4,
              bottom: 4 + (dy * progress),
              child: Transform.scale(
                scale: progress,
                child: Opacity(
                  opacity: progress.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: FloatingActionButton.small(
            backgroundColor: widget.children[i].color ?? Colors.indigo,
            onPressed: () {
              _toggle();
              widget.children[i].onPressed();
            },
            child: widget.children[i].icon,
          ),
        ),
      );
    }
    return children;
  }
```

### Step 4: Add the primary rotating trigger button

Combine the action buttons and rotating trigger in a `Stack`:

```dart
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          ..._buildExpandingActionButtons(),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _expandAnimation.value * (math.pi / 4), // 45 degree rotation
                child: FloatingActionButton(
                  onPressed: _toggle,
                  backgroundColor: const Color(0xFF6366F1),
                  child: const Icon(Icons.add),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
```

---

## Challenges

1. **Radial / Fan Layout**: Instead of a vertical stack, calculate circular polar coordinates $(r \cdot \cos\theta, r \cdot \sin\theta)$ to fan buttons out in a quarter circle.
2. **Backdrop Blur / Scrim**: Add an animated semi-transparent backdrop overlay that fades in when opened and closes the menu when tapped.
3. **Action Labels**: Add animated pill text labels next to each mini FAB that slide and fade in alongside the icons.

---

## Final result

Check out the complete standalone runnable implementation in [final/expandable_fab.dart](final/expandable_fab.dart).
