import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/mock_test_result.dart';
import '../../providers/mock_test_provider.dart';
import '../../services/ad_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import 'mock_test_review_screen.dart';
import 'mock_test_setup_screen.dart';

class MockTestResultScreen extends StatelessWidget {
  const MockTestResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<MockTestProvider>();

    final MockTestResult? result = provider.result;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice Result')),
        body: const Center(
          child: Text('No exam result found.'),
        ),
      );
    }

    final bool isPassed = result.isPassed;
    final int correct = result.correctCount;
    final int total = result.questionCount;
    final double pct = result.percentage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Exam Complete'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Hero Card
            CustomCard(
              backgroundColor: isPassed
                  ? AppColors.successContainer.withValues(alpha: 0.3)
                  : colorScheme.surfaceContainerHigh,
              borderSide: BorderSide(
                color: isPassed
                    ? AppColors.success.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant,
                width: 1.5,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? AppColors.success.withValues(alpha: 0.15)
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Practice Result',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPassed
                            ? AppColors.success
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$correct / $total',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isPassed ? AppColors.success : colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use your result to identify topics that need more practice.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Statistics Grid (Correct, Incorrect, Unanswered, Time Used)
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    context,
                    label: 'Correct',
                    value: '$correct',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    containerColor: AppColors.successContainer,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatTile(
                    context,
                    label: 'Incorrect',
                    value: '${result.incorrectCount}',
                    icon: Icons.cancel_rounded,
                    color: AppColors.error,
                    containerColor: AppColors.errorContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    context,
                    label: 'Unanswered',
                    value: '${result.unansweredCount}',
                    icon: Icons.help_outline_rounded,
                    color: colorScheme.onSurfaceVariant,
                    containerColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatTile(
                    context,
                    label: 'Time Used',
                    value: provider.formattedTimeUsed,
                    icon: Icons.timer_rounded,
                    color: colorScheme.primary,
                    containerColor: colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Performance Section
            if (result.categoryPerformance.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Topic Breakdown',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomCard(
                child: Column(
                  children: result.categoryPerformance.entries.map((entry) {
                    final categoryName = entry.key;
                    final categoryPct = entry.value;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  categoryName,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                '${categoryPct.toStringAsFixed(0)}%',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: categoryPct >= 80
                                      ? AppColors.success
                                      : (categoryPct >= 50
                                          ? AppColors.warning
                                          : AppColors.error),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: categoryPct / 100,
                              minHeight: 6,
                              backgroundColor:
                                  colorScheme.surfaceContainerHighest,
                              color: categoryPct >= 80
                                  ? AppColors.success
                                  : (categoryPct >= 50
                                      ? AppColors.warning
                                      : AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons: Review Answers, Try Again, Back to Home
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MockTestReviewScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.assignment_turned_in_rounded),
                label: const Text(
                  'Review Answers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MockTestSetupScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        AdService.instance.showInterstitialIfReady(
                          onComplete: () {
                            if (context.mounted) {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          },
                        );
                      },
                      icon: const Icon(Icons.home_rounded),
                      label: const Text('Back to Home'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Independent Reviewer Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is an independent educational reviewer and is not affiliated with or endorsed by the Land Transportation Office (LTO).',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Passive Banner Ad
            const AdBannerWidget(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color containerColor,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: containerColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
