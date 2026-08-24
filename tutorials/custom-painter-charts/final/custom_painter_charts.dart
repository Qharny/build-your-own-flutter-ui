import 'package:flutter/material.dart';

void main() {
  runApp(const ChartsApp());
}

class ChartsApp extends StatelessWidget {
  const ChartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Painter Charts Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        useMaterial3: true,
      ),
      home: const ChartsDemoScreen(),
    );
  }
}

class ChartsDemoScreen extends StatefulWidget {
  const ChartsDemoScreen({super.key});

  @override
  State<ChartsDemoScreen> createState() => _ChartsDemoScreenState();
}

class _ChartsDemoScreenState extends State<ChartsDemoScreen> {
  List<double> _chartData = [24, 38, 29, 45, 62, 54, 78, 85, 92];
  int _selectedDataset = 0;

  final List<List<double>> _datasets = [
    [24, 38, 29, 45, 62, 54, 78, 85, 92],
    [80, 72, 65, 50, 48, 60, 75, 90, 110],
    [15, 25, 40, 35, 50, 45, 60, 70, 80],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Painter Charts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL REVENUE',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '\$92,450.00',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_upward_rounded, color: Color(0xFF10B981), size: 16),
                              SizedBox(width: 4),
                              Text(
                                '+18.4%',
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SmoothLineChart(
                      key: ValueKey(_selectedDataset),
                      data: _chartData,
                      height: 180,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final labels = ['Monthly', 'Weekly', 'Daily'];
                  final isSelected = _selectedDataset == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ChoiceChip(
                      label: Text(labels[index]),
                      selected: isSelected,
                      selectedColor: const Color(0xFF6366F1),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: const Color(0xFF1E293B),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedDataset = index;
                            _chartData = _datasets[index];
                          });
                        }
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmoothLineChart extends StatefulWidget {
  final List<double> data;
  final double height;
  final Color lineColor;
  final Color gradientColor;

  const SmoothLineChart({
    super.key,
    required this.data,
    this.height = 200,
    this.lineColor = const Color(0xFF6366F1),
    this.gradientColor = const Color(0xFF6366F1),
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
      duration: const Duration(milliseconds: 1100),
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
              lineColor: widget.lineColor,
              gradientColor: widget.gradientColor,
            ),
          );
        },
      ),
    );
  }
}

class SmoothLineChartPainter extends CustomPainter {
  final List<double> data;
  final double animationProgress;
  final Color lineColor;
  final Color gradientColor;

  SmoothLineChartPainter({
    required this.data,
    required this.animationProgress,
    required this.lineColor,
    required this.gradientColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    // Background horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double rangeY = (maxY - minY == 0) ? 1.0 : (maxY - minY);

    final double stepX = size.width / (data.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double normalizedY = (data[i] - minY) / rangeY;
      final double y = size.height - (normalizedY * (size.height * 0.75) + (size.height * 0.12));
      points.add(Offset(x, y));
    }

    // Build smooth cubic bezier curve
    final Path path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Compute progress path
    final Path animatedPath = Path();
    for (final metric in path.computeMetrics()) {
      animatedPath.addPath(
        metric.extractPath(0.0, metric.length * animationProgress),
        Offset.zero,
      );
    }

    // Gradient fill under the curve
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

    // Draw line stroke
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(animatedPath, linePaint);

    // Draw point markers
    final dotPaint = Paint()..color = Colors.white;
    final dotRingPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final int visiblePointsCount = (points.length * animationProgress).ceil();
    for (int i = 0; i < visiblePointsCount; i++) {
      canvas.drawCircle(points[i], 4.5, dotPaint);
      canvas.drawCircle(points[i], 4.5, dotRingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SmoothLineChartPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.data != data;
  }
}
