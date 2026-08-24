import 'package:flutter/material.dart';

void main() {
  runApp(const NeumorphicApp());
}

class NeumorphicApp extends StatelessWidget {
  const NeumorphicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Neumorphic Button Demo',
      debugShowCheckedModeBanner: false,
      home: NeumorphicDemoScreen(),
    );
  }
}

class NeumorphicDemoScreen extends StatefulWidget {
  const NeumorphicDemoScreen({super.key});

  @override
  State<NeumorphicDemoScreen> createState() => _NeumorphicDemoScreenState();
}

class _NeumorphicDemoScreenState extends State<NeumorphicDemoScreen> {
  int _counter = 0;
  bool _isLiked = false;

  final Color _bg = const Color(0xFFE0E5EC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NEUMORPHISM',
                style: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 14,
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              // Circular Neumorphic Icon Button
              NeumorphicButton(
                isCircle: true,
                padding: const EdgeInsets.all(24),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
                child: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.redAccent : Colors.blueGrey.shade600,
                  size: 36,
                ),
              ),
              const SizedBox(height: 48),
              // Rectangular Neumorphic Action Button
              NeumorphicButton(
                onPressed: () {
                  setState(() {
                    _counter++;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app, color: Colors.blueGrey.shade700),
                    const SizedBox(width: 12),
                    Text(
                      'Tapped $_counter times',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsets padding;
  final Color backgroundColor;
  final bool isCircle;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
    this.backgroundColor = const Color(0xFFE0E5EC),
    this.isCircle = false,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final double offset = _isPressed ? 2.0 : 7.0;
    final double blur = _isPressed ? 3.0 : 14.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: widget.isCircle ? null : BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            // Dark shadow bottom-right
            BoxShadow(
              color: const Color(0xFFA3B1C6).withOpacity(0.65),
              offset: Offset(offset, offset),
              blurRadius: blur,
            ),
            // Light specular highlight top-left
            BoxShadow(
              color: Colors.white.withOpacity(0.95),
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
