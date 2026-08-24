# Swipeable Card Stack

A Tinder-style swipeable card deck with drag gestures, dynamic rotation tilt, threshold detection, and dismissal animations.

---

## What we're building

We will create a swipeable card stack (Tinder-style deck). Users can drag the topmost card in any direction; as it is dragged, the card smoothly translates and tilts proportionally to the horizontal displacement. When released past a swipe threshold, it flies off-screen and reveals the card beneath it.

<!-- [Screenshot / GIF: Card being dragged, rotating dynamically, and flying off screen] -->

---

## Concepts you'll learn

- Tracking drag coordinates with `GestureDetector` (`onPanStart`, `onPanUpdate`, `onPanEnd`).
- Applying dynamic 2D transforms with `Transform.translate` and `Transform.rotate`.
- Calculating rotation angle and opacity overlay cues based on horizontal drag delta.
- Programmatic fling/dismissal animations with `AnimationController` and `Tween<Offset>`.
- Stacking background cards with scaling and vertical offset layers.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Model the card data

Define the properties each card will render:

```dart
class CardItem {
  final String title;
  final String subtitle;
  final Color color;

  const CardItem({
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
```

### Step 2: Handle pan drag gestures and tilt calculations

We track the card's position via an `Offset _dragOffset`. The rotation angle is proportional to `_dragOffset.dx`.

```dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

class SwipeableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipedLeft;
  final VoidCallback onSwipedRight;

  const SwipeableCard({
    super.key,
    required this.child,
    required this.onSwipedLeft,
    required this.onSwipedRight,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  late final AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.35;

    if (_dragOffset.dx > threshold) {
      _animateOut(Offset(screenWidth * 1.5, _dragOffset.dy), widget.onSwipedRight);
    } else if (_dragOffset.dx < -threshold) {
      _animateOut(Offset(-screenWidth * 1.5, _dragOffset.dy), widget.onSwipedLeft);
    } else {
      // Snap back to center
      _animateTo(Offset.zero);
    }
  }

  void _animateOut(Offset target, VoidCallback onComplete) {
    _slideAnimation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() => _dragOffset = _slideAnimation.value);
      });

    _animController.forward(from: 0.0).then((_) {
      _dragOffset = Offset.zero;
      _animController.reset();
      onComplete();
    });
  }

  void _animateTo(Offset target) {
    _slideAnimation = Tween<Offset>(begin: _dragOffset, end: target).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    )..addListener(() {
        setState(() => _dragOffset = _slideAnimation.value);
      });
    _animController.forward(from: 0.0);
  }
```

### Step 3: Render transformed card with rotation tilt

Use `Transform.translate` and `Transform.rotate` to render the interactive motion:

```dart
  @override
  Widget build(BuildContext context) {
    final double rotation = (_dragOffset.dx / 300) * (math.pi / 12);

    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: rotation,
          child: widget.child,
        ),
      ),
    );
  }
```

---

## Challenges

1. **Like / Nope Stamp Overlays**: Add "LIKE" (green) and "NOPE" (red) stamp indicators whose opacity fades in proportionally as the card is dragged left or right.
2. **Rewind / Undo**: Keep track of swiped cards in a history stack and animate the previous card back into the deck on tap.
3. **Card Stack Depth Effect**: Scale down the underlying cards (e.g. 0.95x, 0.90x) and slightly offset them vertically so they feel like a physical 3D deck.

---

## Final result

Check out the complete standalone runnable implementation in [final/swipeable_card_stack.dart](final/swipeable_card_stack.dart).
