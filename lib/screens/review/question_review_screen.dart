import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/questions_filipino.dart';
import '../../models/question_model.dart';
import '../../providers/settings_provider.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';

class QuestionReviewScreen extends StatefulWidget {
  final QuestionModel question;

  const QuestionReviewScreen({
    super.key,
    required this.question,
  });

  @override
  State<QuestionReviewScreen> createState() => _QuestionReviewScreenState();
}

class _QuestionReviewScreenState extends State<QuestionReviewScreen> {
  late bool _isFavorite;
  late bool _isDifficult;
  late bool _isWrong;

  @override
  void initState() {
    super.initState();
    final storage = context.read<StorageService>();
    _isFavorite = storage.isFavorite(widget.question.id);
    _isDifficult = storage.isDifficult(widget.question.id);
    _isWrong = storage.isWrongAnswer(widget.question.id);
  }

  Future<void> _toggleFavorite() async {
    final storage = context.read<StorageService>();
    await storage.toggleFavorite(widget.question.id);
    setState(() {
      _isFavorite = storage.isFavorite(widget.question.id);
    });
  }

  Future<void> _toggleDifficult() async {
    final storage = context.read<StorageService>();
    await storage.toggleDifficult(widget.question.id);
    setState(() {
      _isDifficult = storage.isDifficult(widget.question.id);
    });
  }

  Future<void> _toggleWrong() async {
    final storage = context.read<StorageService>();
    if (_isWrong) {
      await storage.removeWrongAnswer(widget.question.id);
    } else {
      await storage.addWrongAnswer(widget.question.id);
    }
    setState(() {
      _isWrong = storage.isWrongAnswer(widget.question.id);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isWrong
              ? 'Added to Wrong Answers bank'
              : 'Removed from Wrong Answers bank'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final q = widget.question;

    String langCode = 'en';
    try {
      langCode = context.watch<SettingsProvider>().languageCode;
    } catch (_) {}

    final localizedQuestion = q.getLocalizedQuestion(langCode);
    final localizedOptions = q.getLocalizedOptions(langCode);
    final localizedExplanation = q.getLocalizedExplanation(langCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            tooltip: _isDifficult ? 'Flagged as Difficult' : 'Mark as Difficult',
            icon: Icon(
              _isDifficult ? Icons.warning_rounded : Icons.warning_amber_rounded,
              color: _isDifficult ? Colors.amber.shade800 : null,
            ),
            onPressed: _toggleDifficult,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metadata badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      q.category,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(q.difficulty).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      q.difficulty.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getDifficultyColor(q.difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_isWrong)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cancel_outlined,
                              size: 14, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text(
                            'Mistake',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Question text
              Text(
                localizedQuestion,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Answer choices
              ...List.generate(localizedOptions.length, (index) {
                final isCorrect = index == q.correctAnswerIndex;
                final letter = String.fromCharCode(65 + index); // A, B, C, D

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CustomCard(
                    backgroundColor: isCorrect
                        ? AppColors.successContainer.withValues(alpha: 0.4)
                        : colorScheme.surfaceContainerLow,
                    borderSide: isCorrect
                        ? const BorderSide(color: AppColors.success, width: 2)
                        : null,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? AppColors.success.withValues(alpha: 0.15)
                                : colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isCorrect
                                  ? AppColors.success
                                  : colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            localizedOptions[index],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isCorrect ? FontWeight.bold : FontWeight.normal,
                              color: colorScheme.onSurface,
                              height: 1.35,
                            ),
                          ),
                        ),
                        if (isCorrect) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Explanation Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.successContainer.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Correct Answer Explanation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizedExplanation,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.45,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (q.sourceReference != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Reference: ${q.sourceReference!}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick toggle for Wrong Answers status
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: Icon(
                  _isWrong
                      ? Icons.delete_sweep_outlined
                      : Icons.add_circle_outline_rounded,
                  color: _isWrong ? AppColors.error : colorScheme.primary,
                ),
                label: Text(
                  _isWrong
                      ? 'Remove from Wrong Answers Bank'
                      : 'Mark as Mistake',
                  style: TextStyle(
                    color: _isWrong ? AppColors.error : colorScheme.primary,
                  ),
                ),
                onPressed: _toggleWrong,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
