import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_progress_model.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/stat_card.dart';
import '../practice/category_selection_screen.dart';

class ProgressScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const ProgressScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ProgressProvider? progressProvider;
    try {
      progressProvider = context.watch<ProgressProvider>();
    } catch (_) {
      // Fallback for tests where ProgressProvider is not supplied
    }

    StorageService storage;
    try {
      storage = context.read<StorageService>();
    } catch (_) {
      storage = context.read<SettingsProvider>().storageService;
    }

    final progress =
        progressProvider?.progress ?? storage.getPracticeProgress();
    final mockHistory = storage.getMockTestHistory();
    final mockAnalytics = MockTestAnalytics.fromResults(mockHistory);

    final bool isEmpty =
        progress.totalPracticeAnswered == 0 && mockHistory.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: isEmpty
          ? _buildEmptyState(context)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Subtitle
                  Text(
                    'Track your practice and mock exam performance.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Study Streak
                  _buildStreakSection(context, progress),
                  const SizedBox(height: 16),

                  // Overall Practice Stats
                  _buildOverallPracticeSection(context, progress),
                  const SizedBox(height: 16),

                  // Practice Coverage
                  _buildPracticeCoverageSection(context, progress),
                  const SizedBox(height: 16),

                  // Recent Practice Activity (if any)
                  if (progress.questionsPracticedToday > 0 ||
                      progress.questionsPracticedThisWeek > 0) ...[
                    _buildRecentActivitySection(context, progress),
                    const SizedBox(height: 16),
                  ],

                  // Category Performance
                  _buildCategoryPerformanceSection(context, progress),
                  const SizedBox(height: 16),

                  // Difficulty Performance
                  _buildDifficultyPerformanceSection(context, progress),
                  const SizedBox(height: 16),

                  // Mock Exam Performance
                  _buildMockPerformanceSection(context, mockAnalytics),
                  const SizedBox(height: 16),

                  // Mock Improvement Trend
                  _buildMockTrendSection(context, mockAnalytics),
                  const SizedBox(height: 16),

                  // Recent Mock Exam History
                  if (mockAnalytics.recentAttempts.isNotEmpty) ...[
                    _buildRecentMockAttemptsSection(context, mockAnalytics),
                    const SizedBox(height: 16),
                  ],

                  // Educational Disclaimer
                  const DisclaimerBanner(compact: true),
                  const SizedBox(height: 16),

                  // Passive Banner Ad
                  const AdBannerWidget(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.analytics_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Practice Activity Yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start practicing to see your progress.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (onNavigateTab != null) {
                  onNavigateTab!(1); // Practice tab
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CategorySelectionScreen(),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start Practice'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakSection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomCard(
      backgroundColor: colorScheme.surfaceContainerHigh,
      borderSide: BorderSide(
        color: AppColors.warning.withValues(alpha: 0.35),
        width: 1,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 24,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${progress.currentStreak} ${progress.currentStreak == 1 ? 'Day' : 'Days'}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'STREAK',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Best streak: ${progress.longestStreak} ${progress.longestStreak == 1 ? 'day' : 'days'} • Complete at least 1 practice question daily',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallPracticeSection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Practice',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.quiz_rounded,
                title: 'Questions Attempted',
                value: '${progress.totalPracticeAnswered}',
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.percent_rounded,
                title: 'Accuracy',
                value: progress.totalPracticeAnswered > 0
                    ? '${progress.practiceAccuracy.toStringAsFixed(1)}%'
                    : '0.0%',
                iconColor: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.check_circle_outline_rounded,
                title: 'Correct Answers',
                value: '${progress.totalPracticeCorrect}',
                iconColor: AppColors.success,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.highlight_off_rounded,
                title: 'Incorrect Answers',
                value: '${progress.totalPracticeIncorrect}',
                iconColor: AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPracticeCoverageSection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final questionCoverage = progress.uniqueQuestionsAttempted / 150;
    final categoryCoverage = progress.categoriesAttempted / 11;

    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Coverage',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Factual coverage of available questions and categories.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Questions Attempted',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${progress.uniqueQuestionsAttempted} / 150',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: questionCoverage.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories Attempted',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${progress.categoriesAttempted} / 11',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: categoryCoverage.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              color: colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.today_rounded,
                title: 'Practiced Today',
                value: '${progress.questionsPracticedToday} Qs',
                iconColor: Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.date_range_rounded,
                title: 'This Week',
                value: '${progress.questionsPracticedThisWeek} Qs',
                iconColor: Colors.purple.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryPerformanceSection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort categories: attempted first (lowest accuracy first for focus), then unattempted
    final categories = List<String>.from(AppCategories.allCategories);
    categories.sort((a, b) {
      final statA = progress.categoryStats[a];
      final statB = progress.categoryStats[b];
      final attemptedA = statA?.isAttempted ?? false;
      final attemptedB = statB?.isAttempted ?? false;

      if (attemptedA && !attemptedB) return -1;
      if (!attemptedA && attemptedB) return 1;
      if (attemptedA && attemptedB) {
        return (statA!.accuracy).compareTo(statB!.accuracy);
      }
      return a.compareTo(b);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Performance',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sorted by areas needing practice first.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomCard(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final stat = progress.categoryStats[cat];
              final isAttempted = stat?.isAttempted ?? false;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cat,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (stat != null && stat.needsMorePractice) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Needs more practice',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        isAttempted
                            ? '${stat!.accuracy.toStringAsFixed(1)}%'
                            : 'Not attempted',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isAttempted
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: isAttempted ? (stat!.accuracy / 100) : 0.0,
                      minHeight: 6,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      color: isAttempted
                          ? (stat!.accuracy >= 80
                              ? AppColors.success
                              : (stat.accuracy < 70
                                  ? Colors.amber.shade800
                                  : AppColors.primary))
                          : colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  if (isAttempted) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${stat!.attempted} attempts (${stat.correct} correct)',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyPerformanceSection(
      BuildContext context, UserProgressModel progress) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final difficulties = [
      (label: 'Easy', key: AppDifficulty.easy, color: AppColors.success),
      (label: 'Medium', key: AppDifficulty.medium, color: AppColors.warning),
      (label: 'Hard', key: AppDifficulty.hard, color: AppColors.error),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Built-in Question Difficulty',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Based on curriculum difficulty metadata.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        CustomCard(
          child: Column(
            children: difficulties.map((d) {
              final stat = progress.difficultyStats[d.key];
              final isAttempted = stat?.isAttempted ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: d.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              d.label,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          isAttempted
                              ? '${stat!.accuracy.toStringAsFixed(1)}% (${stat.correct}/${stat.attempted})'
                              : 'Not attempted',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isAttempted
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: isAttempted ? (stat!.accuracy / 100) : 0.0,
                        minHeight: 6,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        color: d.color,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMockPerformanceSection(
      BuildContext context, MockTestAnalytics analytics) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mock Exam Performance',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.assignment_turned_in_rounded,
                title: 'Mock Tests Taken',
                value: '${analytics.totalTests}',
                iconColor: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events_rounded,
                title: 'Best Score',
                value: analytics.bestPercentage != null
                    ? '${analytics.bestPercentage!.toStringAsFixed(1)}%'
                    : 'N/A',
                iconColor: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.history_rounded,
                title: 'Latest Score',
                value: analytics.latestPercentage != null
                    ? '${analytics.latestPercentage!.toStringAsFixed(1)}%'
                    : 'N/A',
                iconColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatCard(
                icon: Icons.timeline_rounded,
                title: 'Average Score',
                value: analytics.averagePercentage != null
                    ? '${analytics.averagePercentage!.toStringAsFixed(1)}%'
                    : 'N/A',
                iconColor: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMockTrendSection(
      BuildContext context, MockTestAnalytics analytics) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Improvement Trend',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (!analytics.hasEnoughDataForTrend)
            Text(
              'Complete more practice tests to see your trend.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (int i = 0; i < analytics.chronologicalAttempts.length; i++) ...[
                  Chip(
                    avatar: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    label: Text(
                      '${analytics.chronologicalAttempts[i].percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (i < analytics.chronologicalAttempts.length - 1)
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecentMockAttemptsSection(
      BuildContext context, MockTestAnalytics analytics) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Mock Attempts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: analytics.recentAttempts.take(5).length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final test = analytics.recentAttempts[index];
            final minutes = test.timeUsedSeconds ~/ 60;
            final seconds = test.timeUsedSeconds % 60;
            final dateStr =
                '${test.timestamp.year}-${test.timestamp.month.toString().padLeft(2, '0')}-${test.timestamp.day.toString().padLeft(2, '0')}';

            return CustomCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.timer_outlined,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Score: ${test.correctCount}/${test.questionCount} (${test.percentage.toStringAsFixed(1)}%)',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Practice Result',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$dateStr • Time: ${minutes}m ${seconds}s',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
