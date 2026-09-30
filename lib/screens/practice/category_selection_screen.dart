import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/routes/app_routes.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/question_repository.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import '../difficult_questions/difficult_questions_screen.dart';
import '../favorites/favorites_screen.dart';
import '../wrong_answers/wrong_answers_screen.dart';
import 'practice_quiz_screen.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    QuestionRepository repository;
    try {
      repository = context.read<QuestionRepository>();
    } catch (_) {
      repository = QuestionRepository();
    }
    final settingsProvider = context.watch<SettingsProvider>();
    final userVehicle = settingsProvider.vehicleType;

    StorageService storage;
    try {
      storage = context.read<StorageService>();
    } catch (_) {
      storage = settingsProvider.storageService;
    }
    final wrongCount = storage.getWrongAnswerIds().length;
    final favCount = storage.getFavorites().length;
    final diffCount = storage.getDifficult().length;

    final categories = [
      {
        'name': AppCategories.trafficRules,
        'icon': Icons.gavel_rounded,
        'color': Colors.blue,
      },
      {
        'name': AppCategories.roadSigns,
        'icon': Icons.warning_amber_rounded,
        'color': Colors.amber.shade800,
      },
      {
        'name': AppCategories.roadMarkings,
        'icon': Icons.alt_route_rounded,
        'color': Colors.orange,
      },
      {
        'name': AppCategories.rightOfWay,
        'icon': Icons.merge_type_rounded,
        'color': Colors.teal,
      },
      {
        'name': AppCategories.overtaking,
        'icon': Icons.double_arrow_rounded,
        'color': Colors.purple,
      },
      {
        'name': AppCategories.parking,
        'icon': Icons.local_parking_rounded,
        'color': Colors.indigo,
      },
      {
        'name': AppCategories.turning,
        'icon': Icons.turn_right_rounded,
        'color': Colors.deepOrange,
      },
      {
        'name': AppCategories.defensiveDriving,
        'icon': Icons.security_rounded,
        'color': Colors.green,
      },
      {
        'name': AppCategories.vehicleBasics,
        'icon': Icons.build_rounded,
        'color': Colors.blueGrey,
      },
      {
        'name': AppCategories.safety,
        'icon': Icons.health_and_safety_rounded,
        'color': Colors.red,
      },
      {
        'name': AppCategories.expresswayRules,
        'icon': Icons.speed_rounded,
        'color': Colors.cyan,
      },
    ];

    void startQuiz({String? category}) {
      context.read<QuizProvider>().startPractice(
            category: category,
            vehicleType: userVehicle,
          );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
      );
    }

    final totalAvailable = repository.getQuestionsForVehicle(userVehicle).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice by Topic'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle_rounded),
            tooltip: 'Random Practice',
            onPressed: () => startQuiz(category: null),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Filter Banner (Interactive)
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.button),
              onTap: () => Navigator.pushNamed(context, AppRoutes.vehicleSelect),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 15,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Preparing for: ${settingsProvider.vehicleTypeLabel}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$totalAvailable Questions',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // All Questions Hero Card
            CustomCard(
              backgroundColor: colorScheme.surfaceContainerHigh,
              borderSide: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.35),
                width: 1,
              ),
              padding: const EdgeInsets.all(14),
              onTap: () => startQuiz(category: null),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.all_inclusive_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Questions',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Comprehensive review across all 11 topics ($totalAvailable Qs)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Targeted Practice Section
            Text(
              'Targeted Practice',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    onTap: () {
                      if (wrongCount > 0) {
                        final qs = repository.getQuestionsByIds(
                          storage.getWrongAnswerIds(),
                        );
                        context.read<QuizProvider>().startTargetedPractice(
                              questions: qs,
                              title: 'Practice Mistakes',
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PracticeQuizScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WrongAnswersScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mistakes',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '$wrongCount Qs',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    onTap: () {
                      if (favCount > 0) {
                        final qs = repository.getQuestionsByIds(
                          storage.getFavorites(),
                        );
                        context.read<QuizProvider>().startTargetedPractice(
                              questions: qs,
                              title: 'Practice Favorites',
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PracticeQuizScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FavoritesScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Favorites',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '$favCount Qs',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    onTap: () {
                      if (diffCount > 0) {
                        final qs = repository.getQuestionsByIds(
                          storage.getDifficult(),
                        );
                        context.read<QuizProvider>().startTargetedPractice(
                              questions: qs,
                              title: 'Practice Difficult',
                            );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PracticeQuizScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DifficultQuestionsScreen(),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Difficult',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          '$diffCount Qs',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Road Signs Learning & Visual Catalog Card
            CustomCard(
              backgroundColor: colorScheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(12),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.roadSigns);
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.traffic_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Road Signs Visual Guide',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Explore 45 vector signs & practice sign recognition',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Select a Topic',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Categories List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final categoryName = cat['name'] as String;
                final color = cat['color'] as Color;
                final count = repository.getCategoryCount(
                  categoryName,
                  vehicleType: userVehicle,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CustomCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    onTap: () => startQuiz(category: categoryName),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            cat['icon'] as IconData,
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                '$count Questions',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.base),

            // Passive Banner Ad
            const AdBannerWidget(),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
