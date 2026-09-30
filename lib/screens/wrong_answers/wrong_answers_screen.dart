import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/question_model.dart';
import '../../providers/quiz_provider.dart';
import '../../services/question_repository.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_card.dart';
import '../practice/practice_quiz_screen.dart';
import '../review/question_review_screen.dart';

class WrongAnswersScreen extends StatefulWidget {
  const WrongAnswersScreen({super.key});

  @override
  State<WrongAnswersScreen> createState() => _WrongAnswersScreenState();
}

class _WrongAnswersScreenState extends State<WrongAnswersScreen> {
  List<QuestionModel> _wrongQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final storage = context.read<StorageService>();
    final repository = context.read<QuestionRepository>();
    final wrongIds = storage.getWrongAnswerIds();
    final questions = repository.getQuestionsByIds(wrongIds);
    setState(() {
      _wrongQuestions = questions;
    });
  }

  Future<void> _removeQuestion(String id) async {
    final storage = context.read<StorageService>();
    await storage.removeWrongAnswer(id);
    _loadQuestions();
  }

  Future<void> _confirmClearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Wrong Answers?'),
        content: const Text(
          'This will clear your saved mistakes bank. Your favorites, difficult bookmarks, and exam history will remain untouched.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final storage = context.read<StorageService>();
      await storage.clearWrongAnswers();
      _loadQuestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong answers bank cleared'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _startPractice() {
    if (_wrongQuestions.isEmpty) return;
    context.read<QuizProvider>().startTargetedPractice(
          questions: _wrongQuestions,
          title: 'Practice Mistakes',
          shuffle: true,
        );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PracticeQuizScreen()),
    ).then((_) => _loadQuestions());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final storage = context.read<StorageService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Wrong Answers (${_wrongQuestions.length})'),
        actions: [
          if (_wrongQuestions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear All Mistakes',
              onPressed: _confirmClearAll,
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: _wrongQuestions.isEmpty
          ? _buildEmptyState(context)
          : SafeArea(
              child: Column(
                children: [
                  // Practice Mistakes Banner Action
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: colorScheme.surfaceContainerLow,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_wrongQuestions.length} Question${_wrongQuestions.length == 1 ? '' : 's'} to Review',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Randomized practice with instant explanations',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: _startPractice,
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: const Text('Practice Mistakes'),
                        ),
                      ],
                    ),
                  ),

                  // Questions List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _wrongQuestions.length,
                      itemBuilder: (context, index) {
                        final q = _wrongQuestions[index];
                        final isFav = storage.isFavorite(q.id);
                        final isDiff = storage.isDifficult(q.id);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CustomCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuestionReviewScreen(
                                    question: q,
                                  ),
                                ),
                              ).then((_) => _loadQuestions());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Category, Difficulty, Icons & Remove button
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        q.category,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getDifficultyColor(q.difficulty)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        q.difficulty.toUpperCase(),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color:
                                              _getDifficultyColor(q.difficulty),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (isFav) ...[
                                      const Icon(
                                        Icons.favorite_rounded,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    if (isDiff) ...[
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 16,
                                        color: Colors.amber.shade800,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                      ),
                                      tooltip: 'Remove from Mistakes',
                                      onPressed: () => _removeQuestion(q.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Question text preview
                                Text(
                                  q.question,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Tap hint
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Review Question',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 14,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.successContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 64,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Mistakes Yet!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Questions you answer incorrectly during practice sessions will automatically appear here for focused review.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
