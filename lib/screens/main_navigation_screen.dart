import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'home/home_screen.dart';
import 'mock_test/mock_test_setup_screen.dart';
import 'practice/category_selection_screen.dart';
import 'progress/progress_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigateTab: _onNavigateTab),
      const CategorySelectionScreen(),
      const MockTestSetupScreen(),
      ProgressScreen(onNavigateTab: _onNavigateTab),
    ];
  }

  void _onNavigateTab(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: _FadeIndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final bottomInset = MediaQuery.paddingOf(context).bottom;
          const navBarHeight = 64.0;
          const topFadeHeight = 28.0;
          final bottomSpacing = bottomInset > 0 ? (bottomInset + 4.0) : 12.0;
          final totalHeight = topFadeHeight + navBarHeight + bottomSpacing;

          return SizedBox(
            height: totalHeight,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // 1. Progressive Blur & Gradient Backdrop touching the bottom of screen
                // Starts completely transparent at top (no visible line) and slowly blurs to high intensity touching bottom
                Positioned.fill(
                  child: _ProgressiveBlurBackground(isDark: isDark),
                ),

                // 2. Elevated Floating Navigation Bar with crisp, distinct border
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: bottomSpacing,
                  height: navBarHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isDark
                            ? const Color(0x8038BDF8) // Defined luminous electric-sky border
                            : const Color(0xFF94A3B8).withValues(alpha: 0.65), // Crisp modern slate border
                        width: 1.5,
                      ),
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.50),
                                blurRadius: 18,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.16),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.10),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: isDark
                                ? const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xD9131B24),
                                      Color(0xEA0D131B),
                                    ],
                                  )
                                : const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xE6FFFFFF),
                                      Color(0xEEF8FAFC),
                                    ],
                                  ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _NavBarItem(
                                index: 0,
                                currentIndex: _currentIndex,
                                label: 'Home',
                                outlinedIcon: Icons.home_outlined,
                                filledIcon: Icons.home_rounded,
                                onTap: () => _onNavigateTab(0),
                              ),
                              _NavBarItem(
                                index: 1,
                                currentIndex: _currentIndex,
                                label: 'Practice',
                                outlinedIcon: Icons.menu_book_outlined,
                                filledIcon: Icons.menu_book_rounded,
                                onTap: () => _onNavigateTab(1),
                              ),
                              _NavBarItem(
                                index: 2,
                                currentIndex: _currentIndex,
                                label: 'Mock Exam',
                                outlinedIcon: Icons.assignment_outlined,
                                filledIcon: Icons.assignment_rounded,
                                onTap: () => _onNavigateTab(2),
                              ),
                              _NavBarItem(
                                index: 3,
                                currentIndex: _currentIndex,
                                label: 'Progress',
                                outlinedIcon: Icons.insights_outlined,
                                filledIcon: Icons.insights_rounded,
                                onTap: () => _onNavigateTab(3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Renders a progressive blur backdrop that starts completely transparent at the top
/// with no visible cut-off line, and gradually increases to high blur touching the bottom.
class _ProgressiveBlurBackground extends StatelessWidget {
  final bool isDark;

  const _ProgressiveBlurBackground({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          if (bounds.isEmpty || bounds.width <= 0 || bounds.height <= 0) {
            return const LinearGradient(
              colors: [Colors.transparent, Colors.transparent],
            ).createShader(const Rect.fromLTWH(0, 0, 1, 1));
          }
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent, // 0.0 stop: seamless start with NO visible line
              Color(0x0F000000),  // ~6% opacity at 20%
              Color(0x38000000),  // ~22% opacity at 42%
              Color(0x80000000),  // ~50% opacity at 65%
              Color(0xCC000000),  // ~80% opacity at 85%
              Colors.black,       // 100% full blur touching bottom edge
            ],
            stops: [0.0, 0.20, 0.42, 0.65, 0.85, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.0),
                    (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.20),
                    (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.55),
                    (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.82),
                    (isDark ? AppColors.darkBackground : AppColors.lightBackground).withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.22, 0.50, 0.78, 1.0],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A lightweight [IndexedStack] wrapper that smoothly fades in the active screen
/// without scrolling or building intermediate screens.
class _FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;

  const _FadeIndexedStack({
    required this.index,
    required this.children,
  });

  @override
  State<_FadeIndexedStack> createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<_FadeIndexedStack>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 180);
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _fadeDuration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _FadeIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.outlinedIcon,
    required this.filledIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          splashColor: primaryColor.withValues(alpha: 0.12),
          highlightColor: Colors.transparent,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 12 : 8,
                vertical: isSelected ? 6 : 5,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withValues(alpha: isDark ? 0.18 : 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.35)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    size: 22,
                    color: isSelected
                        ? primaryColor
                        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      letterSpacing: isSelected ? -0.1 : 0.0,
                      color: isSelected
                          ? primaryColor
                          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                    ),
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
