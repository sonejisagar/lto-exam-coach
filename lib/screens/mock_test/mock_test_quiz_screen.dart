import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/questions_filipino.dart';
import '../../models/question_model.dart';
import '../../providers/mock_test_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import 'mock_test_result_screen.dart';

class MockTestQuizScreen extends StatefulWidget {
  const MockTestQuizScreen({super.key});

  @override
  State<MockTestQuizScreen> createState() => _MockTestQuizScreenState();
}

class _MockTestQuizScreenState extends State<MockTestQuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final provider = context.read<MockTestProvider>();
        provider.onAutoSubmit = () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MockTestResultScreen(),
              ),
            );
          }
        };
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    try {
      final provider = context.read<MockTestProvider>();
      provider.onAutoSubmit = null;
    } catch (_) {}
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Mock Exam?'),
        content: const Text('Your current answers will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (shouldLeave == true) {
      if (mounted) {
        try {
          context.read<MockTestProvider>().cancelExam();
        } catch (_) {}
      }
      return true;
    }
    return false;
  }

  void _showSubmitConfirmationDialog(MockTestProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Mock Exam?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you sure you want to finish and submit your exam?',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Answered:'),
                      Text(
                        '${provider.answeredCount}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Unanswered:'),
                      Text(
                        '${provider.unansweredCount}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: provider.unansweredCount > 0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining time:'),
                      Text(
                        provider.formattedRemainingTime,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continue Exam'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await provider.submitTest();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MockTestResultScreen(),
                  ),
                );
              }
            },
            child: const Text('Submit Exam'),
          ),
        ],
      ),
    );
  }

  void _showQuestionGridSheet(MockTestProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final colorScheme = theme.colorScheme;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question Navigator',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Legend
              Row(
                children: [
                  _buildLegendItem(
                    colorScheme.primaryContainer,
                    colorScheme.onPrimaryContainer,
                    'Answered',
                  ),
                  const SizedBox(width: 12),
                  _buildLegendItem(
                    colorScheme.surfaceContainerHighest,
                    colorScheme.onSurfaceVariant,
                    'Unanswered',
                  ),
                  const SizedBox(width: 12),
                  _buildLegendItem(
                    colorScheme.primary,
                    colorScheme.onPrimary,
                    'Current',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: provider.totalQuestions,
                  itemBuilder: (context, index) {
                    final isCurrent = provider.currentIndex == index;
                    final isAnswered = provider.isQuestionAnswered(index);

                    Color bg;
                    Color text;
                    Border? border;

                    if (isCurrent) {
                      bg = colorScheme.primary;
                      text = colorScheme.onPrimary;
                    } else if (isAnswered) {
                      bg = colorScheme.primaryContainer;
                      text = colorScheme.onPrimaryContainer;
                    } else {
                      bg = colorScheme.surfaceContainerHighest;
                      text = colorScheme.onSurfaceVariant;
                      border = Border.all(
                        color: colorScheme.outlineVariant,
                      );
                    }

                    return InkWell(
                      onTap: () {
                        provider.navigateToQuestion(index);
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: bg,
                          border: border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: text,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color bg, Color text, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<MockTestProvider>();

    final QuestionModel? question = provider.currentQuestion;

    if (question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mock Exam')),
        body: const Center(child: Text('No questions available in this exam.')),
      );
    }

    final int currentIndex = provider.currentIndex;
    final int totalQuestions = provider.totalQuestions;
    final int? selectedAnswer = provider.currentSelectedAnswer;
    final bool isLowTime = provider.isLowTime;

    String langCode = 'en';
    try {
      langCode = context.watch<SettingsProvider>().languageCode;
    } catch (_) {}

    final localizedQuestionText = question.getLocalizedQuestion(langCode);
    final localizedOptions = question.getLocalizedOptions(langCode);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'Leave Exam',
            onPressed: () async {
              final shouldLeave = await _onWillPop();
              if (shouldLeave && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text(
            'Question ${currentIndex + 1} of $totalQuestions',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            // Timer Badge
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isLowTime
                    ? AppColors.errorContainer
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLowTime ? AppColors.error : colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_rounded,
                    size: 16,
                    color: isLowTime ? AppColors.error : colorScheme.onSurface,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    provider.formattedRemainingTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color:
                          isLowTime ? AppColors.error : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // Question Grid Button
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Question List',
              onPressed: () => _showQuestionGridSheet(provider),
            ),
          ],
        ),
        body: Column(
          children: [
            // Linear Progress Indicator
            LinearProgressIndicator(
              value: (currentIndex + 1) / totalQuestions,
              backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
              color: colorScheme.primary,
              minHeight: 3,
            ),

            // Question & Options Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Vehicle Badge
                    Row(
                      children: [
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
                            question.category,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Answered: ${provider.answeredCount} / $totalQuestions',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
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
                    ...List.generate(localizedOptions.length, (optIdx) {
                      final optionText = localizedOptions[optIdx];
                      final isSelected = selectedAnswer == optIdx;
                      final optionLetters = ['A', 'B', 'C', 'D'];

                      // Exam mode: no green/red feedback! Only selected state.
                      Color tileBg = colorScheme.surfaceContainerLow;
                      BorderSide border = BorderSide(
                        color: isSelected ? colorScheme.primary : colorScheme.outline,
                        width: isSelected ? 1.5 : 1,
                      );

                      if (isSelected) {
                        tileBg = colorScheme.primary.withValues(alpha: 0.12);
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomCard(
                          backgroundColor: tileBg,
                          borderSide: border,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          onTap: () {
                            provider.selectAnswer(optIdx);
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  optionLetters[optIdx],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  optionText,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: colorScheme.onSurface,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Horizontal Question Number Strip
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
                itemCount: totalQuestions,
                itemBuilder: (context, idx) {
                  final isCurrent = idx == currentIndex;
                  final isAnswered = provider.isQuestionAnswered(idx);

                  Color bg;
                  Color fg;
                  Border? border;

                  if (isCurrent) {
                    bg = colorScheme.primary;
                    fg = colorScheme.onPrimary;
                  } else if (isAnswered) {
                    bg = colorScheme.primaryContainer;
                    fg = colorScheme.onPrimaryContainer;
                  } else {
                    bg = colorScheme.surfaceContainerHigh;
                    fg = colorScheme.onSurfaceVariant;
                    border = Border.all(color: colorScheme.outlineVariant);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: () => provider.navigateToQuestion(idx),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 32,
                        decoration: BoxDecoration(
                          color: bg,
                          border: border,
                          borderRadius: BorderRadius.circular(6),
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

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 0.5,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Previous Button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: currentIndex > 0
                            ? () => provider.previousQuestion()
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded, size: 16),
                        label: const Text(
                          'Previous',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Submit Button
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => _showSubmitConfirmationDialog(provider),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                        ),
                        icon: const Icon(Icons.check_rounded, size: 16),
                        label: const Text(
                          'Submit',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Next / Finish Button
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: currentIndex < totalQuestions - 1
                            ? () => provider.nextQuestion()
                            : () => _showSubmitConfirmationDialog(provider),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 10,
                          ),
                        ),
                        icon: Icon(
                          currentIndex < totalQuestions - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.done_all_rounded,
                          size: 16,
                        ),
                        label: Text(
                          currentIndex < totalQuestions - 1 ? 'Next' : 'Finish',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
