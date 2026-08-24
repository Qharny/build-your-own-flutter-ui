import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const ShaderGradientApp());
}

class ShaderGradientApp extends StatelessWidget {
  const ShaderGradientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shader Gradient Background Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ShaderGradientDemoScreen(),
    );
  }
}

class ShaderGradientDemoScreen extends StatelessWidget {
  const ShaderGradientDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedShaderBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.amberAccent, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Fluid Mesh Gradient',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ambient Living UI',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Real-time orbital radial gradients smoothly rendered on Flutter canvas with zero external packages.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
      Color(0xFF8B5CF6), // Purple
    ],
    this.duration = const Duration(seconds: 10),
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
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                painter: AmbientGradientPainter(
                  progress: _controller.value,
                  colors: widget.colors,
                ),
              );
            },
          ),
        ),
        if (widget.child != null) Positioned.fill(child: widget.child!),
      ],
    );
  }
}

class AmbientGradientPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  AmbientGradientPainter({
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Fill base background
    final bgPaint = Paint()..color = const Color(0xFF090D16);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final double t = progress * 2 * math.pi;

    // Orb 1 (Top Left orbit)
    _drawOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.3 + math.sin(t) * (size.width * 0.25),
        size.height * 0.28 + math.cos(t) * (size.height * 0.18),
      ),
      radius: size.width * 0.7,
      color: colors[0],
    );

    // Orb 2 (Right Center orbit)
    _drawOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.75 + math.cos(t * 0.8) * (size.width * 0.2),
        size.height * 0.55 + math.sin(t * 0.8) * (size.height * 0.2),
      ),
      radius: size.width * 0.75,
      color: colors[1],
    );

    // Orb 3 (Bottom Center orbit)
    _drawOrb(
      canvas: canvas,
      center: Offset(
        size.width * 0.45 + math.sin(t * 1.3) * (size.width * 0.28),
        size.height * 0.8 + math.cos(t * 1.3) * (size.height * 0.15),
      ),
      radius: size.width * 0.8,
      color: colors[2],
    );
  }

  void _drawOrb({
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
    return oldDelegate.progress != progress;
  }
}
