import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const ExpandableFabApp());
}

class ExpandableFabApp extends StatelessWidget {
  const ExpandableFabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable FAB Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
      ),
      home: const ExpandableFabDemoScreen(),
    );
  }
}

class ExpandableFabDemoScreen extends StatelessWidget {
  const ExpandableFabDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Speed Dial FAB'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF6366F1).withOpacity(0.1),
                child: Text('#${index + 1}', style: const TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
              ),
              title: Text('Project item ${index + 1}'),
              subtitle: const Text('Tap the FAB at bottom right to trigger actions'),
            ),
          );
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 64.0,
        children: [
          ActionButton(
            icon: const Icon(Icons.format_size, color: Colors.white),
            tooltip: 'Add Note',
            color: const Color(0xFF10B981),
            onPressed: () => _showSnackBar(context, 'Note action clicked'),
          ),
          ActionButton(
            icon: const Icon(Icons.insert_photo, color: Colors.white),
            tooltip: 'Add Image',
            color: const Color(0xFFEC4899),
            onPressed: () => _showSnackBar(context, 'Image action clicked'),
          ),
          ActionButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            tooltip: 'Add Video',
            color: const Color(0xFFF59E0B),
            onPressed: () => _showSnackBar(context, 'Video action clicked'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

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

class ExpandableFab extends StatefulWidget {
  final double distance;
  final List<ActionButton> children;

  const ExpandableFab({
    super.key,
    required this.distance,
    required this.children,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return IgnorePointer(
      ignoring: !_open,
      child: AnimatedOpacity(
        opacity: _open ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: 56.0,
          height: 56.0,
          child: Center(
            child: Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              elevation: 4,
              child: InkWell(
                onTap: _toggle,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close, color: Color(0xFF6366F1)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: progress.clamp(0.0, 1.0),
                  child: child,
                ),
              ),
            );
          },
          child: FloatingActionButton.small(
            backgroundColor: widget.children[i].color ?? const Color(0xFF6366F1),
            tooltip: widget.children[i].tooltip,
            heroTag: 'fab_$i',
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

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF6366F1),
            onPressed: _toggle,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
