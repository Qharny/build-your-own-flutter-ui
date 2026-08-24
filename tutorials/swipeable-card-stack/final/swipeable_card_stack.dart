import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const SwipeableCardApp());
}

class SwipeableCardApp extends StatelessWidget {
  const SwipeableCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipeable Card Stack Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        useMaterial3: true,
      ),
      home: const CardStackDemoScreen(),
    );
  }
}

class CardProfile {
  final String name;
  final String role;
  final String location;
  final Color primaryColor;
  final IconData icon;

  const CardProfile({
    required this.name,
    required this.role,
    required this.location,
    required this.primaryColor,
    required this.icon,
  });
}

class CardStackDemoScreen extends StatefulWidget {
  const CardStackDemoScreen({super.key});

  @override
  State<CardStackDemoScreen> createState() => _CardStackDemoScreenState();
}

class _CardStackDemoScreenState extends State<CardStackDemoScreen> {
  final List<CardProfile> _cards = [
    const CardProfile(
      name: 'Sophia Turner',
      role: 'Lead UI/UX Architect',
      location: 'San Francisco, CA',
      primaryColor: Color(0xFF6366F1),
      icon: Icons.design_services_rounded,
    ),
    const CardProfile(
      name: 'Marcus Vance',
      role: 'Senior Flutter Engineer',
      location: 'London, UK',
      primaryColor: Color(0xFFEC4899),
      icon: Icons.developer_mode_rounded,
    ),
    const CardProfile(
      name: 'Elena Rostova',
      role: 'Creative Motion Designer',
      location: 'Berlin, DE',
      primaryColor: Color(0xFF10B981),
      icon: Icons.animation_rounded,
    ),
    const CardProfile(
      name: 'Liam Chen',
      role: 'Product Specialist',
      location: 'Tokyo, JP',
      primaryColor: Color(0xFFF59E0B),
      icon: Icons.rocket_launch_rounded,
    ),
  ];

  void _removeTopCard(bool isLiked) {
    if (_cards.isNotEmpty) {
      setState(() {
        _cards.removeAt(0);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isLiked ? 'Liked! 🎉' : 'Passed 👋'),
          duration: const Duration(milliseconds: 600),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Discover Talent', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: _cards.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.white54, size: 64),
                    const SizedBox(height: 16),
                    const Text('All caught up!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _cards.addAll([
                            const CardProfile(
                              name: 'Sophia Turner',
                              role: 'Lead UI/UX Architect',
                              location: 'San Francisco, CA',
                              primaryColor: Color(0xFF6366F1),
                              icon: Icons.design_services_rounded,
                            ),
                            const CardProfile(
                              name: 'Marcus Vance',
                              role: 'Senior Flutter Engineer',
                              location: 'London, UK',
                              primaryColor: Color(0xFFEC4899),
                              icon: Icons.developer_mode_rounded,
                            ),
                          ]);
                        });
                      },
                      child: const Text('Reset Deck'),
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: List.generate(
                    math.min(3, _cards.length),
                    (i) {
                      final reversedIndex = math.min(3, _cards.length) - 1 - i;
                      final card = _cards[reversedIndex];

                      if (reversedIndex == 0) {
                        return SwipeableCard(
                          onSwipedLeft: () => _removeTopCard(false),
                          onSwipedRight: () => _removeTopCard(true),
                          child: _buildCardView(card),
                        );
                      }

                      // Underlying cards with scale down
                      final double scale = 1.0 - (reversedIndex * 0.05);
                      final double offsetY = reversedIndex * 14.0;
                      return Transform.translate(
                        offset: Offset(0, offsetY),
                        child: Transform.scale(
                          scale: scale,
                          child: _buildCardView(card),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCardView(CardProfile profile) {
    return Container(
      width: 320,
      height: 440,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [profile.primaryColor, profile.primaryColor.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(profile.icon, size: 80, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            profile.name,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            profile.role,
            style: TextStyle(color: profile.primaryColor, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.white60, size: 16),
              const SizedBox(width: 4),
              Text(
                profile.location,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final double rotation = (_dragOffset.dx / 320) * (math.pi / 12);

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
}
