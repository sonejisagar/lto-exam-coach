import 'package:flutter/material.dart';
import '../../widgets/onboarding_illustrations.dart';
import 'vehicle_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = const [
    {
      'title': 'Prepare Smarter',
      'description':
          'Practice Philippine driving theory questions anytime, anywhere.',
      'illustration': PrepareSmarterIllustration(),
    },
    {
      'title': 'Master Road Signs',
      'description':
          'Learn traffic signs, road markings and essential driving rules.',
      'illustration': MasterRoadSignsIllustration(),
    },
    {
      'title': 'Track Your Progress',
      'description':
          'Practice regularly, find your weak topics and improve your score.',
      'illustration': TrackProgressIllustration(),
    },
  ];

  void _onFinishOnboarding() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VehicleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: _onFinishOnboarding,
              child: const Text('Skip'),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 220,
                          child: item['illustration'] as Widget,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item['title'] as String,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item['description'] as String,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators & Actions
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicator dots
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: isSelected ? 24 : 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Next or Get Started Button
                  FilledButton.icon(
                    onPressed: () {
                      if (isLastPage) {
                        _onFinishOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(
                      isLastPage
                          ? Icons.rocket_launch_rounded
                          : Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                    label: Text(isLastPage ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
