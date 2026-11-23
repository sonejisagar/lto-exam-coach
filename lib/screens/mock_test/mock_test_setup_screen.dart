import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mock_test_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/question_repository.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/disclaimer_banner.dart';
import 'mock_test_quiz_screen.dart';

class MockTestSetupScreen extends StatefulWidget {
  const MockTestSetupScreen({super.key});

  @override
  State<MockTestSetupScreen> createState() => _MockTestSetupScreenState();
}

class _MockTestSetupScreenState extends State<MockTestSetupScreen> {
  int _selectedQuestionCount = 20;
  String? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settingsProvider = context.watch<SettingsProvider>();

    QuestionRepository repository;
    try {
      repository = context.read<QuestionRepository>();
    } catch (_) {
      repository = QuestionRepository();
    }

    _selectedVehicle ??= settingsProvider.vehicleType;

    final availableQuestions =
        repository.getQuestionsForVehicle(_selectedVehicle!).length;

    final bool hasFewerQuestions =
        availableQuestions > 0 && availableQuestions < _selectedQuestionCount;
    final int effectiveCount = availableQuestions < _selectedQuestionCount
        ? availableQuestions
        : _selectedQuestionCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mock Exam'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.base,
          AppSpacing.sm,
          AppSpacing.base,
          100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulation Overview Hero Card
            CustomCard(
              gradient: isDark
                  ? AppGradients.darkCardGlow
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
                    ),
              padding: const EdgeInsets.all(18),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.45),
                width: 1.2,
              ),
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                            Icon(
                              Icons.timer_outlined,
                              size: 13,
                              color: isDark ? AppColors.primaryLight : AppColors.primary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'TIMED SIMULATION',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.primaryLight : AppColors.primary,
                                letterSpacing: 0.5,
                                fontSize: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkBackground.withValues(alpha: 0.7)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          '80% Benchmark',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                            fontSize: 10.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Realistic Driving Exam Simulation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 17.5,
                      letterSpacing: -0.3,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Test your knowledge under official examination rules and time limits.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Practice Only Information Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
                boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice Reviewer Notice',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This mock exam is an independent study tool. It is not an official LTO examination.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
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

            // Select Question Count Section
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Question Count',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [20, 30].map((count) {
                final isSelected = _selectedQuestionCount == count;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedQuestionCount = count;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppGradients.primary : null,
                          color: isSelected
                              ? null
                              : (isDark ? AppColors.darkSurface : Colors.white),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.30),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : (isDark ? AppShadows.cardDark : AppShadows.cardLight),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              '$count Questions',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13.5,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Select Vehicle Mode Section
            Row(
              children: [
                Container(
                  width: 3.5,
                  height: 15,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Target Vehicle Mode',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                {
                  'type': AppVehicleTypes.car,
                  'label': 'Car',
                  'icon': Icons.directions_car_rounded,
                },
                {
                  'type': AppVehicleTypes.motorcycle,
                  'label': 'Motorcycle',
                  'icon': Icons.two_wheeler_rounded,
                },
                {
                  'type': AppVehicleTypes.both,
                  'label': 'Both',
                  'icon': Icons.swap_horiz_rounded,
                },
              ].map((item) {
                final type = item['type'] as String;
                final label = item['label'] as String;
                final icon = item['icon'] as IconData;
                final isSelected = _selectedVehicle == type;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedVehicle = type;
                        });
                      },
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppGradients.primary : null,
                          color: isSelected
                              ? null
                              : (isDark ? AppColors.darkSurface : Colors.white),
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.30),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : (isDark ? AppShadows.cardDark : AppShadows.cardLight),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 20,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.primaryLight
                                      : AppColors.primary),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                fontSize: 12,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.base),

            // Fewer Questions Notice if any
            if (hasFewerQuestions)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.base),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.chip),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Only $availableQuestions questions currently match this vehicle filter. Your exam will contain $effectiveCount questions.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Exam Parameters Summary
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.timer_rounded,
                    title: 'Time Limit',
                    subtitle: '$effectiveCount Minutes (1 min / question)',
                    iconColor: AppColors.primary,
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    context,
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Practice Benchmark',
                    subtitle: '80% Target Score',
                    iconColor: AppColors.success,
                  ),
                  const Divider(height: 20),
                  _buildInfoRow(
                    context,
                    icon: Icons.format_list_numbered_rounded,
                    title: 'Question Pool',
                    subtitle: '$effectiveCount Questions (Randomized)',
                    iconColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Main Start Button
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                borderRadius: BorderRadius.circular(AppRadius.button),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final questions = repository.getRandomQuestions(
                      count: effectiveCount,
                      vehicleType: _selectedVehicle,
                    );

                    if (questions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No questions available for the selected vehicle mode.',
                          ),
                        ),
                      );
                      return;
                    }

                    try {
                      context.read<MockTestProvider>().startMockTest(
                            questions: questions,
                            vehicleType: _selectedVehicle!,
                            durationSeconds: questions.length * 60,
                          );
                    } catch (_) {
                      // Fallback
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MockTestQuizScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          'Start Mock Exam',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Disclaimer Banner
            const DisclaimerBanner(compact: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: Icon(icon, color: iconColor, size: 19),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
