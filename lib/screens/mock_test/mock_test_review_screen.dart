import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/questions_filipino.dart';
import '../../models/question_model.dart';
import '../../providers/mock_test_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';

class MockTestReviewScreen extends StatefulWidget {
  const MockTestReviewScreen({super.key});

  @override
  State<MockTestReviewScreen> createState() => _MockTestReviewScreenState();
}

class _MockTestReviewScreenState extends State<MockTestReviewScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<MockTestProvider>();

    final questions = provider.questions;
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review Answers')),
        body: const Center(child: Text('No questions to review.')),
      );
    }

    final QuestionModel question = questions[_currentIndex];
    final int? userAnswer = provider.getAnswerForQuestion(_currentIndex);
    final bool isAnswered = userAnswer != null;
    final bool isCorrect = isAnswered && userAnswer == question.correctAnswerIndex;

    String langCode = 'en';
    try {
      langCode = context.watch<SettingsProvider>().languageCode;
    } catch (_) {}

    final localizedQuestionText = question.getLocalizedQuestion(langCode);
    final localizedOptions = question.getLocalizedOptions(langCode);
    final localizedExplanation = question.getLocalizedExplanation(langCode);

    return Scaffold(
      appBar: AppBar(
        title: Text('Review (${_currentIndex + 1}/${questions.length})'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isCorrect
                  ? AppColors.successContainer
                  : (isAnswered
                      ? AppColors.errorContainer
                      : colorScheme.surfaceContainerHighest),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle_rounded
                      : (isAnswered
                          ? Icons.cancel_rounded
                          : Icons.help_outline_rounded),
                  size: 16,
                  color: isCorrect
                      ? AppColors.success
                      : (isAnswered
                          ? AppColors.error
                          : colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 4),
                Text(
                  isCorrect
                      ? 'Correct'
                      : (isAnswered ? 'Incorrect' : 'Unanswered'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isCorrect
                        ? AppColors.success
                        : (isAnswered
                            ? AppColors.error
                            : colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      question.category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Question Card
                  CustomCard(
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    child: Text(
                      localizedQuestionText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Options with review indicators
                  ...List.generate(localizedOptions.length, (optIdx) {
                    final optionText = localizedOptions[optIdx];
                    final isCorrectOpt = optIdx == question.correctAnswerIndex;
                    final isUserOpt = userAnswer == optIdx;
                    final optionLetters = ['A', 'B', 'C', 'D'];

                    Color tileBg = colorScheme.surface;
                    Color borderColor = colorScheme.outlineVariant;
                    Color badgeBg = colorScheme.surfaceContainerHighest;
                    Color badgeFg = colorScheme.onSurface;

                    if (isCorrectOpt) {
                      tileBg = AppColors.successContainer.withValues(alpha: 0.5);
                      borderColor = AppColors.success;
                      badgeBg = AppColors.success;
                      badgeFg = Colors.white;
                    } else if (isUserOpt && !isCorrectOpt) {
                      tileBg = AppColors.errorContainer.withValues(alpha: 0.5);
                      borderColor = AppColors.error;
                      badgeBg = AppColors.error;
                      badgeFg = Colors.white;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomCard(
                        backgroundColor: tileBg,
                        borderSide: BorderSide(
                          color: borderColor,
                          width: (isCorrectOpt || isUserOpt) ? 2 : 1,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: badgeBg,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                optionLetters[optIdx],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: badgeFg,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                optionText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: (isCorrectOpt || isUserOpt)
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isCorrectOpt)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 20,
                              )
                            else if (isUserOpt)
                              const Icon(
                                Icons.cancel_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),

                  // Explanation Card
                  CustomCard(
                    backgroundColor: colorScheme.surfaceContainerLowest,
                    borderSide: BorderSide(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Explanation',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizedExplanation,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                          ),
                        ),
                        if (question.sourceReference != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Source: ${question.sourceReference}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Question navigation strip
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: questions.length,
              itemBuilder: (context, idx) {
                final isCurrent = idx == _currentIndex;
                final userAns = provider.getAnswerForQuestion(idx);
                final q = questions[idx];
                final isQCorrect = userAns != null && userAns == q.correctAnswerIndex;
                final isQAnswered = userAns != null;

                Color bg;
                Color fg;

                if (isCurrent) {
                  bg = colorScheme.primary;
                  fg = colorScheme.onPrimary;
                } else if (isQCorrect) {
                  bg = AppColors.successContainer;
                  fg = AppColors.success;
                } else if (isQAnswered) {
                  bg = AppColors.errorContainer;
                  fg = AppColors.error;
                } else {
                  bg = colorScheme.surfaceContainerHigh;
                  fg = colorScheme.onSurfaceVariant;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentIndex = idx;
                      });
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 32,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(6),
                        border: isCurrent
                            ? Border.all(color: colorScheme.primary, width: 1.5)
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${idx + 1}',
                        style: TextStyle(
                          color: fg,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Navigation buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex > 0
                          ? () => setState(() => _currentIndex--)
                          : null,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _currentIndex < questions.length - 1
                          ? () => setState(() => _currentIndex++)
                          : null,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
