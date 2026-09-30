import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/sign_learning_provider.dart';
import '../../services/ad_service.dart';
import '../../utils/constants.dart';
import '../../widgets/ad_banner.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/road_sign_painters.dart';

class SignLearningScreen extends StatelessWidget {
  final SignLearningProvider? provider;
  const SignLearningScreen({super.key, this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider != null) {
      return ChangeNotifierProvider<SignLearningProvider>.value(
        value: provider!,
        child: const _SignLearningView(),
      );
    }
    return ChangeNotifierProvider(
      create: (_) => SignLearningProvider(),
      child: const _SignLearningView(),
    );
  }
}

class _SignLearningView extends StatelessWidget {
  const _SignLearningView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<SignLearningProvider>();

    if (provider.isSessionFinished) {
      return _buildFinishedView(context, provider);
    }

    final q = provider.currentQuestion;
    if (q == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Sign Practice')),
        body: const Center(child: Text('No signs available for practice.')),
      );
    }

    final isAnswered = provider.isAnswered;
    final isCorrect = provider.isCorrect;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Road Sign Quiz'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${provider.currentIndex + 1} / ${provider.totalQuestions}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Linear Progress Indicator
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (provider.currentIndex + 1) / provider.totalQuestions,
                minHeight: 6,
                backgroundColor: colorScheme.surfaceContainerHighest,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Sign Visual Card
            CustomCard(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: RoadSignWidget(
                  signType: q.sign.signType,
                  size: 120,
                  semanticLabel: q.sign.semanticLabel,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Question Prompt
            Text(
              'What does this road sign mean?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 4 Answer Options
            ...List.generate(q.options.length, (index) {
              final optionText = q.options[index];
              Color? btnBg;
              Color? borderCol;
              Color textCol = colorScheme.onSurface;

              if (isAnswered) {
                if (index == q.correctAnswerIndex) {
                  btnBg = AppColors.successContainer;
                  borderCol = AppColors.success;
                  textCol = Colors.green.shade900;
                } else if (index == provider.selectedAnswerIndex) {
                  btnBg = AppColors.errorContainer;
                  borderCol = AppColors.error;
                  textCol = AppColors.onErrorContainer;
                } else {
                  btnBg = colorScheme.surfaceContainerHighest.withValues(alpha: 0.4);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: isAnswered ? null : () => provider.selectAnswer(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: btnBg ?? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: borderCol ?? colorScheme.outlineVariant.withValues(alpha: 0.6),
                        width: isAnswered && (index == q.correctAnswerIndex || index == provider.selectedAnswerIndex) ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isAnswered && index == q.correctAnswerIndex
                                ? AppColors.success
                                : (isAnswered && index == provider.selectedAnswerIndex
                                    ? AppColors.error
                                    : colorScheme.surface),
                          ),
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isAnswered && (index == q.correctAnswerIndex || index == provider.selectedAnswerIndex)
                                  ? Colors.white
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            optionText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textCol,
                              fontWeight: isAnswered && index == q.correctAnswerIndex ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Immediate Feedback Card when answered
            if (isAnswered) ...[
              const SizedBox(height: 12),
              CustomCard(
                backgroundColor: isCorrect
                    ? AppColors.successContainer.withValues(alpha: 0.35)
                    : AppColors.errorContainer.withValues(alpha: 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: isCorrect ? AppColors.success : AppColors.error,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCorrect ? 'Correct!' : 'Incorrect',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isCorrect ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${q.sign.name} (${q.sign.category} Sign)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      q.sign.usage,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.nextQuestion,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  provider.currentIndex < provider.totalQuestions - 1
                      ? 'Next Sign'
                      : 'Finish Session',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinishedView(BuildContext context, SignLearningProvider provider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pct = provider.accuracy;

    return Scaffold(
      appBar: AppBar(title: const Text('Session Results')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (pct >= 80 ? AppColors.success : AppColors.warning).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  pct >= 80 ? Icons.emoji_events_rounded : Icons.school_rounded,
                  size: 56,
                  color: pct >= 80 ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sign Practice Complete!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You identified ${provider.score} out of ${provider.totalQuestions} signs correctly.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${pct.toStringAsFixed(0)}%',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: pct >= 80 ? AppColors.success : colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Passive Banner Ad
              const AdBannerWidget(),
              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: provider.restartSession,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Practice Again'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  AdService.instance.showInterstitialIfReady(
                    onComplete: () {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Back to Road Signs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
