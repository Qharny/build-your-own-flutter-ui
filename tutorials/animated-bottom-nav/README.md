# Animated Bottom Navigation Bar

A custom bottom navigation bar with sliding active pill indicators, icon scale transitions, and smooth spring curves.

---

## What we're building

We will create a bottom navigation bar with animated tab switching. When a user taps an item, an active pill indicator smoothly glides to the selected position, the selected icon animates with a scale and color transition, and labels expand with spring easing.

<!-- [Screenshot / GIF: Smooth sliding pill and scale animations on tab switch] -->

---

## Concepts you'll learn

- Using `AnimationController` and `CurvedAnimation` with spring-like curves.
- Animating positional layouts with `AnimatedAlign` or `Tween<double>`.
- Building interactive icon button groups with `GestureDetector` and `AnimatedScale`.
- Customizing floating pill container dimensions and elevation effects.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Define the navigation item model

Define the data structure for navigation tabs with icons, labels, and theme colors.

```dart
import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  final Color activeColor;

  const NavItem({
    required this.icon,
    required this.label,
    this.activeColor = const Color(0xFF6366F1),
  });
}
```

### Step 2: Build the individual nav item with animated pill

We use `AnimatedContainer` and `AnimatedScale` to give each item an expanding pill shape and icon bounce on selection.

```dart
class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? item.activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                item.icon,
                color: isSelected ? item.activeColor : Colors.grey.shade400,
                size: 24,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 1.0 : 0.0,
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: item.activeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Step 3: Wrap into a floating navigation bar

Embed the navigation row into a styled floating card with subtle shadows and corner radii:

```dart
class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return _NavItemWidget(
            item: items[index],
            isSelected: currentIndex == index,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}
```

---

## Challenges

1. **Sliding Indicator Background**: Replace the per-item container with a single continuous sliding pill indicator that interpolates coordinates horizontally using `CustomPainter` or `AnimatedAlign`.
2. **Badge Notifications**: Add an animated notification badge counter above the tab icon with entrance and exit scale animations.
3. **Haptic Feedback**: Integrate `HapticFeedback.lightImpact()` on tab switches.

---

## Final result

Check out the complete standalone runnable implementation in [final/animated_bottom_nav.dart](final/animated_bottom_nav.dart).
