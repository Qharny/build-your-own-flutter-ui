# Custom Painter Charts

A smooth, animated sparkline and area curve chart built from scratch with Flutter's `CustomPainter`, cubic Bézier paths, and gradient fills.

---

## What we're building

We will create a custom line chart widget with smooth cubic Bézier curves, a semi-transparent vertical gradient fill beneath the curve, grid guide lines, data point markers, and an animated path reveal.

<!-- [Screenshot / GIF: Curved line chart drawing progressively with glowing gradient area fill] -->

---

## Concepts you'll learn

- Mapping raw numerical data $(x, y)$ onto 2D canvas pixel coordinates.
- Smoothing line segments into fluid curves using cubic Bézier paths (`Path.cubicTo`).
- Closing paths and applying vertical gradient fills with `Shader` and `Canvas.drawPath`.
- Animating the line drawing effect from 0% to 100% using `PathMetric` and `extractPath()`.

---

## Prerequisites

- Flutter SDK `3.0.0` or higher
- Dart `3.0.0` or higher
- No third-party packages required

---

## Step-by-step

### Step 1: Normalize and map data points to canvas space

We compute relative $(x, y)$ positions within the canvas dimensions:

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class ChartDataPoint {
  final double value;
  final String label;

  const ChartDataPoint(this.value, this.label);
}
```

### Step 2: Build the smooth Bézier curve painter

We iterate through the points, calculate control points between successive coordinates, and draw the smoothed path:

```dart
class SmoothLineChartPainter extends CustomPainter {
  final List<double> data;
  final double animationProgress;
  final Color lineColor;
  final Color gradientColor;

  SmoothLineChartPainter({
    required this.data,
    required this.animationProgress,
    this.lineColor = const Color(0xFF6366F1),
    this.gradientColor = const Color(0xFF818CF8),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double rangeY = (maxY - minY == 0) ? 1.0 : (maxY - minY);

    final double stepX = size.width / (data.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (data[i] - minY) / rangeY;
      // Invert Y because canvas Y increases downwards
      final double y = size.height - (normalizedY * (size.height * 0.8) + (size.height * 0.1));
      points.add(Offset(x, y));
    }

    // Build smooth cubic curve
    final Path path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p1.dx, p1.dy,
      );
    }

    // Animate path reveal
    final Path animatedPath = Path();
    for (final metric in path.computeMetrics()) {
      animatedPath.addPath(
        metric.extractPath(0.0, metric.length * animationProgress),
        Offset.zero,
      );
    }

    // Draw gradient area under curve
    if (animationProgress > 0.0) {
      final Path fillPath = Path.from(animatedPath)
        ..lineTo(points.last.dx * animationProgress, size.height)
        ..lineTo(0, size.height)
        ..close();

      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientColor.withOpacity(0.35),
            gradientColor.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw stroke line
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(animatedPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant SmoothLineChartPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.data != data;
  }
}
```

### Step 3: Wrap into an Animated Line Chart Widget

Connect the painter to an `AnimationController` for an entrance animation:

```dart
class SmoothLineChart extends StatefulWidget {
  final List<double> data;
  final double height;

  const SmoothLineChart({
    super.key,
    required this.data,
    this.height = 200,
  });

  @override
  State<SmoothLineChart> createState() => _SmoothLineChartState();
}

class _SmoothLineChartState extends State<SmoothLineChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: SmoothLineChartPainter(
              data: widget.data,
              animationProgress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}
```

---

## Challenges

1. **Touch Tooltip / Crosshair**: Add `GestureDetector` to track touch horizontal location, calculate the closest point, and paint an interactive crosshair with a floating value bubble.
2. **Multi-Series Plotting**: Extend the painter to accept multiple datasets with distinct line strokes and legend markers.
3. **Bar & Donut Charts**: Create additional painters for bar histograms and radial donut charts using `Canvas.drawRRect` and `Canvas.drawArc`.

---

## Final result

Check out the complete standalone runnable implementation in [final/custom_painter_charts.dart](final/custom_painter_charts.dart).
