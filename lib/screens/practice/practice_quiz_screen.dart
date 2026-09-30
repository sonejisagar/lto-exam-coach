import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/questions_filipino.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/settings_provider.dart';
import '../../services/ad_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';

class PracticeQuizScreen extends StatelessWidget {
  const PracticeQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    if (quizProvider.isCompleted) {
      return const _PracticeCompletionView();
    }

    final question = quizProvider.currentQuestion;
    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Practice')),
        body: const Center(
          child: Text('No questions available for this category.'),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentIndex = quizProvider.currentIndex;
    final total = quizProvider.totalQuestions;

    String langCode = 'en';
    try {
      langCode = context.watch<SettingsProvider>().languageCode;
    } catch (_) {}

    final localizedQuestionText = question.getLocalizedQuestion(langCode);
    final localizedOptions = question.getLocalizedOptions(langCode);
    final localizedExplanation = question.getLocalizedExplanation(langCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(quizProvider.currentCategory ?? 'Practice Quiz'),
        actions: [
          // Favorite button
          IconButton(
            tooltip: quizProvider.isCurrentFavorite
                ? 'Remove from Favorites'
                : 'Add to Favorites',
            icon: Icon(
              quizProvider.isCurrentFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: quizProvider.isCurrentFavorite ? Colors.red : null,
            ),
            onPressed: () {
              context.read<QuizProvider>().toggleCurrentFavorite();
            },
          ),
          // Difficult button
          IconButton(
            tooltip: quizProvider.isCurrentDifficult
                ? 'Marked as Difficult'
                : 'Mark as Difficult',
            icon: Icon(
              quizProvider.isCurrentDifficult
                  ? Icons.warning_rounded
                  : Icons.warning_amber_rounded,
              color: quizProvider.isCurrentDifficult ? Colors.amber.shade800 : null,
            ),
            onPressed: () {
              context.read<QuizProvider>().toggleCurrentDifficult();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (currentIndex + 1) / total,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              color: colorScheme.primary,
              minHeight: 3,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Counter & Difficulty Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${currentIndex + 1} of $total',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: colorScheme.outline),
                          ),
                          child: Text(
                            question.difficulty.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Question Text Card
                    CustomCard(
                      backgroundColor: colorScheme.surfaceContainerHigh,
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        localizedQuestionText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),

                    // Options List
                    ...List.generate(localizedOptions.length, (optionIndex) {
                      return _buildOptionTile(
                        context,
                        optionIndex: optionIndex,
                        optionText: localizedOptions[optionIndex],
                        quizProvider: quizProvider,
                      );
                    }),

                    // Feedback and Explanation Card
                    if (quizProvider.isAnswered) ...[
                      const SizedBox(height: AppSpacing.md),
                      _buildExplanationCard(context, quizProvider, explanation: localizedExplanation),
                    ],
                    const SizedBox(height: AppSpacing.base),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: quizProvider.isAnswered
                      ? () {
                          context.read<QuizProvider>().nextQuestion();
                        }
                      : null,
                  icon: Icon(
                    currentIndex == total - 1
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                  label: Text(
                    currentIndex == total - 1
                        ? 'Finish Practice'
                        : 'Next Question',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required int optionIndex,
    required String optionText,
    required QuizProvider quizProvider,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAnswered = quizProvider.isAnswered;
    final isSelected = quizProvider.selectedAnswerIndex == optionIndex;
    final isCorrectOption =
        quizProvider.currentQuestion?.correctAnswerIndex == optionIndex;

    Color? backgroundColor;
    BorderSide? borderSide;
    Color optionLetterColor = colorScheme.primary;

    if (isAnswered) {
      if (isCorrectOption) {
        backgroundColor = AppColors.successContainer.withValues(alpha: 0.3);
        borderSide = const BorderSide(color: AppColors.success, width: 1.5);
        optionLetterColor = AppColors.success;
      } else if (isSelected) {
        backgroundColor = AppColors.errorContainer.withValues(alpha: 0.3);
        borderSide = const BorderSide(color: AppColors.error, width: 1.5);
        optionLetterColor = AppColors.error;
      }
    }

    final String letter = String.fromCharCode(65 + optionIndex); // A, B, C, D

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomCard(
        onTap: isAnswered
            ? null
            : () {
                context.read<QuizProvider>().selectAnswer(optionIndex);
              },
        backgroundColor: backgroundColor ?? colorScheme.surfaceContainerLow,
        borderSide: borderSide,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: optionLetterColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: optionLetterColor,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                optionText,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: colorScheme.onSurface,
                  height: 1.35,
                ),
              ),
            ),
            if (isAnswered) ...[
              const SizedBox(width: 8),
              if (isCorrectOption)
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20)
              else if (isSelected)
                const Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard(
    BuildContext context,
    QuizProvider quizProvider, {
    required String explanation,
  }) {
    final theme = Theme.of(context);
    final isCorrect = quizProvider.isCorrect;
    final question = quizProvider.currentQuestion!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.successContainer.withValues(alpha: 0.25)
            : AppColors.errorContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isCorrect
              ? AppColors.success.withValues(alpha: 0.4)
              : AppColors.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Incorrect',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            explanation,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (question.sourceReference != null) ...[
            const SizedBox(height: 8),
            Text(
              'Reference: ${question.sourceReference!}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (quizProvider.isCurrentWrongAnswer) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded, size: 15),
              label: const Text('Remove from Mistakes', style: TextStyle(fontSize: 12)),
              onPressed: () async {
                await context
                    .read<QuizProvider>()
                    .removeCurrentFromWrongAnswers();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from Wrong Answers'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _PracticeCompletionView extends StatelessWidget {
  const _PracticeCompletionView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final quizProvider = context.watch<QuizProvider>();
    final score = quizProvider.score;
    final total = quizProvider.totalQuestions;
    final accuracy = quizProvider.accuracy;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Complete'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Practice Complete!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Great job practicing driving knowledge!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),

                // Score Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '$score / $total',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Score',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      Column(
                        children: [
                          Text(
                            '${accuracy.toStringAsFixed(0)}%',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: accuracy >= 80
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Accuracy',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Disclaimer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Educational practice result only. This reviewer is independent and does not guarantee passing the official LTO examination.',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                // Passive Banner Ad
                const AdBannerWidget(),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<QuizProvider>().restartPractice();
                        },
                        child: const Text('Practice Again'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          AdService.instance.showInterstitialIfReady(
                            onComplete: () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                        child: const Text('Back to Topics'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
