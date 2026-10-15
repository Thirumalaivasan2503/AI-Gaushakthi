import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/custom_painters.dart';

class OnboardingItem {
  final String title;
  final String subtitle;
  final String description;
  final Widget graphic;

  const OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.graphic,
  });
}

/// 3-Screen Onboarding Flow with Page Indicators and CTA controls
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: 'Artificial Intelligence',
      subtitle: 'Smart Breed Recommendation',
      description:
          'Utilize advanced machine learning to select native indigenous cattle and goat breeds perfectly suited for your agro-climatic zone.',
      graphic: CustomPaint(
        size: const Size(200, 160),
        painter: IndigenousCowPainter(
          primaryColor: AppColors.primary,
          accentColor: AppColors.secondary,
        ),
      ),
    ),
    OnboardingItem(
      title: 'Sustainable Farming',
      subtitle: 'Climate-Based Recommendations',
      description:
          'Empower your farm with high thermal tolerance, low disease vulnerability, and optimized natural fodder consumption.',
      graphic: CustomPaint(
        size: const Size(200, 160),
        painter: AiNodesPainter(
          nodeColor: AppColors.primary,
          lineColor: AppColors.secondary,
        ),
      ),
    ),
    OnboardingItem(
      title: 'Veterinary Assistance',
      subtitle: 'Economic Sustainability',
      description:
          'Access expert veterinary tele-guidance, disease prevention guides, and clear economic ROI forecasting for your herd.',
      graphic: CustomPaint(
        size: const Size(200, 160),
        painter: IndigenousGoatPainter(
          color: AppColors.secondaryDark,
        ),
      ),
    ),
  ];

  void _onNext() {
    if (_currentIndex < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/auth/role');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PasuMitra AI',
                        style: AppTypography.titleLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.go('/auth/role'),
                    child: Text(
                      'Skip',
                      style: AppTypography.buttonText.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            // PageView Slider
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 180,
                          alignment: Alignment.center,
                          child: item.graphic,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          item.title.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.secondaryDark,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.subtitle,
                          style: AppTypography.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.description,
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Indicators and Navigation Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Modern Page Indicators
                  Row(
                    children: List.generate(
                      _items.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // Next / Get Started CTA
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.borderRadiusPill,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentIndex == _items.length - 1 ? 'Get Started' : 'Next',
                          style: AppTypography.buttonText.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
