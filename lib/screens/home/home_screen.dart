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
    _tipIndex = Random().nextInt(TipsData.tips.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
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
      // Fallback
    }
    final progress = progressProvider?.progress ?? storage.getPracticeProgress();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppSpacing.base,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
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
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    AppStrings.appTagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.base),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkElevatedSurface
                  : AppColors.lightElevatedSurface,
              borderRadius: BorderRadius.circular(AppRadius.chip),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 1,
              ),
            ),
            child: IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.settings_outlined, size: 20),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.settings);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          100, // Extra bottom padding for floating nav bar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Greeting & Vehicle Pill Header
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
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Master the Philippine LTO written exam',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.vehicleSelect);
                  },
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryContainer.withValues(alpha: 0.6)
                          : const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.primaryLight
                              : AppColors.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          settingsProvider.vehicleTypeLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11.5,
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),

            // Continue Practice Hero Card with Gradient Depth
            CustomCard(
              gradient: isDark
                  ? AppGradients.darkCardGlow
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                    ),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: isDark ? 0.30 : 0.40),
                width: 1.2,
              ),
              boxShadow: isDark
                  ? [
                      const BoxShadow(
                        color: Color(0x300284C7),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ]
                  : [
                      const BoxShadow(
                        color: Color(0x150284C7),
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
              padding: const EdgeInsets.all(18),
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
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
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryLight,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'DAILY REVIEW',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.primaryLight
                                    : AppColors.primary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground.withValues(alpha: 0.6)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          '${((progress.uniqueQuestionsAttempted / 150) * 100).toInt()}% Done',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? AppColors.primaryLight
                                : AppColors.primaryDark,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Continue Practice',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    150 - progress.uniqueQuestionsAttempted > 0
                        ? '${150 - progress.uniqueQuestionsAttempted} Questions left to complete reviewer'
                        : 'Awesome! All 150 official questions completed!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    child: Container(
                      height: 8,
                      color: isDark
                          ? const Color(0xFF1E2D3B)
                          : const Color(0xFFBAE6FD).withValues(alpha: 0.5),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (progress.uniqueQuestionsAttempted / 150)
                            .clamp(0.02, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: AppGradients.primary,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(1);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.button),
                          ),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Start Practice'),
                      ),
                      const Spacer(),
                      Text(
                        '${progress.uniqueQuestionsAttempted}/150 Questions',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Today's Progress Stats Section
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Today's Summary",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Practiced',
                    value: '${progress.questionsPracticedToday}',
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
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
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    icon: Icons.local_fire_department_rounded,
                    title: 'Day Streak',
                    value:
                        '${progress.currentStreak} ${progress.currentStreak == 1 ? 'Day' : 'Days'}',
                    iconColor: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // High-Visibility Inline Banner Ad (Placed mid-design between Summary & Study Modes)
            const AdBannerWidget(
              margin: EdgeInsets.symmetric(vertical: 6),
            ),
            const SizedBox(height: AppSpacing.md),

            // Study Modes & Review Section
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n?.studyModesTitle ?? 'Study Modes & Review',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modePracticeTitle ?? 'Practice Questions',
              subtitle: l10n?.modePracticeDesc ?? 'Topic by topic review',
              icon: Icons.menu_book_rounded,
              color: AppColors.primary,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(1);
                }
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeMockExamTitle ?? 'Mock Exam',
              subtitle: l10n?.modeMockExamDesc ?? 'Full timed official simulation',
              icon: Icons.timer_outlined,
              color: AppColors.secondary,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(2);
                }
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeWrongAnswersTitle ?? 'Wrong Answers',
              subtitle: l10n?.modeWrongAnswersDesc ?? 'Review past mistakes',
              icon: Icons.history_edu_rounded,
              color: wrongCount > 0 ? AppColors.error : AppColors.error.withValues(alpha: 0.6),
              badgeCount: wrongCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.wrongAnswers)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeFavoritesTitle ?? 'Favorites',
              subtitle: l10n?.modeFavoritesDesc ?? 'Bookmarked questions for quick review',
              icon: Icons.bookmark_outline_rounded,
              color: favoritesCount > 0 ? AppColors.warning : AppColors.warning.withValues(alpha: 0.6),
              badgeCount: favoritesCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.favorites)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeDifficultTitle ?? 'Difficult Questions',
              subtitle: l10n?.modeDifficultDesc ?? 'Questions flagged as tricky',
              icon: Icons.flag_outlined,
              color: difficultCount > 0 ? Colors.deepOrange : Colors.deepOrange.withValues(alpha: 0.6),
              badgeCount: difficultCount,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.difficult)
                    .then((_) => setState(() {}));
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeRoadSignsTitle ?? 'Road Signs Gallery',
              subtitle: l10n?.modeRoadSignsDesc ?? '45 Philippine visual signs with guide',
              icon: Icons.traffic_rounded,
              color: Colors.teal,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.roadSigns);
              },
            ),
            _buildStudyModeRow(
              context: context,
              title: l10n?.modeProgressTitle ?? 'Progress & Analytics',
              subtitle: l10n?.modeProgressDesc ?? 'In-depth performance breakdown',
              icon: Icons.insights_rounded,
              color: AppColors.tertiary,
              onTap: () {
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3);
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

            // Tip of the Day Card with Warm Amber Glow
            CustomCard(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF221A0C), Color(0xFF161208)],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                    ),
              borderSide: BorderSide(
                color: AppColors.warning.withValues(alpha: isDark ? 0.35 : 0.40),
                width: 1,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: isDark ? 0.25 : 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: AppColors.warning,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tip of the Day: ${tip.title}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tip.content,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF78350F),
                            height: 1.4,
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
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.20 : 0.12),
                borderRadius: BorderRadius.circular(AppRadius.chip),
                border: Border.all(
                  color: color.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeCount != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeCount > 0
                      ? color.withValues(alpha: isDark ? 0.25 : 0.15)
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: badgeCount > 0
                        ? color.withValues(alpha: 0.4)
                        : Colors.transparent,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$badgeCount',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: badgeCount > 0
                        ? color
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark
                  ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                  : AppColors.lightTextSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
