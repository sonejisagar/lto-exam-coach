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
    final colorScheme = theme.colorScheme;
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
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simulation Overview Hero Card
            CustomCard(
              backgroundColor: colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(16),
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.35),
                width: 1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 13,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'TIMED SIMULATION',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                                letterSpacing: 0.5,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: colorScheme.outline),
                        ),
                        child: Text(
                          '80% Benchmark',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Realistic Driving Exam Simulation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Test your knowledge with a timed practice exam.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Practice Only Information Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(
                  color: colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Practice only',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This mock exam is an independent study tool. It is not an official LTO examination.',
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

            // Select Question Count Section
            Text(
              'Select Question Count',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [20, 30].map((count) {
                final isSelected = _selectedQuestionCount == count;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '$count Questions',
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedQuestionCount = count;
                          });
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Select Vehicle Mode Section
            Text(
              'Target Vehicle Mode',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ChoiceChip(
                      avatar: Icon(icon, size: 16),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedVehicle = type;
                          });
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.base),

            // Fewer Questions Graceful Notice
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
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Exam Parameters Summary
            CustomCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    icon: Icons.timer_rounded,
                    title: 'Time Limit',
                    subtitle: '$effectiveCount Minutes (1 min / question)',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    icon: Icons.check_circle_outline_rounded,
                    title: 'Practice Benchmark',
                    subtitle: '80% Target Score',
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    context,
                    icon: Icons.format_list_numbered_rounded,
                    title: 'Question Pool',
                    subtitle: '$effectiveCount Questions (Randomized)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Main Start Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () {
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
                    // Fallback if not in provider tree during isolated test
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MockTestQuizScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text(
                  'Start Mock Exam',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
