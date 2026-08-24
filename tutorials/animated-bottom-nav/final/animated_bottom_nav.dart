import 'package:flutter/material.dart';

void main() {
  runApp(const AnimatedNavApp());
}

class AnimatedNavApp extends StatelessWidget {
  const AnimatedNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Bottom Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<NavItem> _navItems = const [
    NavItem(icon: Icons.home_rounded, label: 'Home', activeColor: Color(0xFF6366F1)),
    NavItem(icon: Icons.search_rounded, label: 'Explore', activeColor: Color(0xFFEC4899)),
    NavItem(icon: Icons.bookmark_rounded, label: 'Saved', activeColor: Color(0xFF10B981)),
    NavItem(icon: Icons.person_rounded, label: 'Profile', activeColor: Color(0xFFF59E0B)),
  ];

  final List<String> _pageTitles = ['Home Feed', 'Explore Trends', 'Saved Articles', 'Your Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Column(
            key: ValueKey<int>(_currentIndex),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _navItems[_currentIndex].icon,
                size: 72,
                color: _navItems[_currentIndex].activeColor,
              ),
              const SizedBox(height: 16),
              Text(
                _pageTitles[_currentIndex],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: AnimatedBottomNav(
          currentIndex: _currentIndex,
          items: _navItems,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutQuint,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? item.activeColor.withOpacity(0.14) : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
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
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
