import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/routes/app_routes.dart';
import '../../data/tips_data.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/stat_card.dart';
import '../progress/progress_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const HomeScreen({
    super.key,
    this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _tipIndex;

  @override
  void initState() {
    super.initState();
    // Select a random daily tip from TipsData
    _tipIndex = Random().nextInt(TipsData.tips.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final settingsProvider = context.watch<SettingsProvider>();
    final tip = TipsData.tips[_tipIndex];

    StorageService storage;
    try {
      storage = context.read<StorageService>();
    } catch (_) {
      storage = settingsProvider.storageService;
    }
    final wrongCount = storage.getWrongAnswerIds().length;
    final favoritesCount = storage.getFavorites().length;
    final difficultCount = storage.getDifficult().length;

    ProgressProvider? progressProvider;
    try {
      progressProvider = context.watch<ProgressProvider>();
    } catch (_) {
      // Fallback if ProgressProvider is not in the tree
    }
    final progress = progressProvider?.progress ?? storage.getPracticeProgress();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.directions_car_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    AppStrings.appTagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined, size: 22),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting & Vehicle Mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ready to practice?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Philippines Driver\'s License Reviewer',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ActionChip(
                  avatar: const Icon(Icons.tune_rounded, size: 15),
                  label: Text(
                    'Preparing for: ${settingsProvider.vehicleTypeLabel}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.vehicleSelect);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),

            // Continue Practice Hero Card
            CustomCard(
              backgroundColor: colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(16),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.35),
                width: 1,
              ),
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1); // Practice tab
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'DAILY STUDY',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Text(
                        '${((progress.uniqueQuestionsAttempted / 150) * 100).toInt()}% Covered',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Continue Practice',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    150 - progress.uniqueQuestionsAttempted > 0
                        ? '${150 - progress.uniqueQuestionsAttempted} Questions Left to Review'
                        : 'All 150 Questions Completed!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: (progress.uniqueQuestionsAttempted / 150).clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: colorScheme.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () {
                      if (widget.onNavigateTab != null) {
                        widget.onNavigateTab!(1); // Practice tab
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Start Practice'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Today's Progress Stats Section
            Text(
              "Today's Summary",
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
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Today',
                    value: '${progress.questionsPracticedToday}',
                    iconColor: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    icon: Icons.analytics_rounded,
                    title: 'Accuracy',
                    value: progress.totalPracticeAnswered > 0
                        ? '${progress.practiceAccuracy.toStringAsFixed(0)}%'
                        : '0%',
                    iconColor: AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatCard(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Streak',
                    value:
                        '${progress.currentStreak} ${progress.currentStreak == 1 ? 'Day' : 'Days'}',
                    iconColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Study Modes & Review Section
            Text(
              l10n?.studyModesTitle ?? 'Study Modes & Review',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modePracticeTitle ?? 'Practice Questions',
              subtitle: l10n?.modePracticeDesc ?? 'Topic Practice',
              icon: Icons.menu_book_rounded,
              color: colorScheme.primary,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1); // Practice tab
                }
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeMockExamTitle ?? 'Mock Exam',
              subtitle: l10n?.modeMockExamDesc ?? 'Timed Simulation',
              icon: Icons.timer_outlined,
              color: AppColors.secondary,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(2); // Mock Test tab
                }
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeWrongAnswersTitle ?? 'Wrong Answers',
              subtitle: l10n?.modeWrongAnswersDesc ?? 'Mistake Bank',
              icon: Icons.history_edu_rounded,
              color: wrongCount > 0 ? AppColors.error : colorScheme.outline,
              badgeCount: wrongCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.wrongAnswers)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeFavoritesTitle ?? 'Favorites',
              subtitle: l10n?.modeFavoritesDesc ?? 'Saved Questions',
              icon: Icons.bookmark_outline_rounded,
              color: favoritesCount > 0 ? Colors.amber.shade800 : colorScheme.outline,
              badgeCount: favoritesCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.favorites)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeDifficultTitle ?? 'Difficult Questions',
              subtitle: l10n?.modeDifficultDesc ?? 'Flagged Questions',
              icon: Icons.flag_outlined,
              color: difficultCount > 0 ? Colors.deepOrange : colorScheme.outline,
              badgeCount: difficultCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.difficult)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeRoadSignsTitle ?? 'Road Signs',
              subtitle: l10n?.modeRoadSignsDesc ?? '45 Visual Signs',
              icon: Icons.traffic_rounded,
              color: Colors.teal,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3); // Road Signs tab
                } else {
                  Navigator.pushNamed(context, AppRoutes.roadSigns);
                }
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeProgressTitle ?? 'Progress & Analytics',
              subtitle: l10n?.modeProgressDesc ?? 'Analytics & Streak',
              icon: Icons.insights_rounded,
              color: Colors.indigo,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(4); // Progress tab
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProgressScreen(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tip of the Day Card
            CustomCard(
              backgroundColor: colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.warning,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tip of the Day: ${tip.title}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tip.content,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Educational Disclaimer Footer
            const DisclaimerBanner(compact: true),
            const SizedBox(height: AppSpacing.base),

            // Passive Banner Ad
            const AdBannerWidget(),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyModeRow({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.chip),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeCount != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (badgeCount > 0 ? color : colorScheme.surfaceContainerHighest)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                ),
                child: Text(
                  '$badgeCount',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: badgeCount > 0 ? color : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
