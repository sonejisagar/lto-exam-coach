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

class DifficultQuestionsScreen extends StatefulWidget {
  const DifficultQuestionsScreen({super.key});

  @override
  State<DifficultQuestionsScreen> createState() =>
      _DifficultQuestionsScreenState();
}

class _DifficultQuestionsScreenState extends State<DifficultQuestionsScreen> {
  List<QuestionModel> _difficultQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final storage = context.read<StorageService>();
    final repository = context.read<QuestionRepository>();
    final difficultIds = storage.getDifficult();
    final questions = repository.getQuestionsByIds(difficultIds);
    setState(() {
      _difficultQuestions = questions;
    });
  }

  Future<void> _removeDifficult(String id) async {
    final storage = context.read<StorageService>();
    await storage.removeDifficult(id);
    _loadQuestions();
  }

  void _startPractice() {
    if (_difficultQuestions.isEmpty) return;
    context.read<QuizProvider>().startTargetedPractice(
          questions: _difficultQuestions,
          title: 'Practice Difficult Questions',
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
        title: Text('Difficult Questions (${_difficultQuestions.length})'),
      ),
      body: _difficultQuestions.isEmpty
          ? _buildEmptyState(context)
          : SafeArea(
              child: Column(
                children: [
                  // Practice Difficult Banner Action
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
                                '${_difficultQuestions.length} Flagged Question${_difficultQuestions.length == 1 ? '' : 's'}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Randomized practice session for questions you flagged as tough',
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
                          label: const Text('Practice Difficult'),
                        ),
                      ],
                    ),
                  ),

                  // Questions List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _difficultQuestions.length,
                      itemBuilder: (context, index) {
                        final q = _difficultQuestions[index];
                        final isFav = storage.isFavorite(q.id);
                        final isWrong = storage.isWrongAnswer(q.id);

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
                                    if (isWrong) ...[
                                      const Icon(
                                        Icons.cancel_outlined,
                                        size: 16,
                                        color: AppColors.error,
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      icon: Icon(
                                        Icons.warning_rounded,
                                        size: 20,
                                        color: Colors.amber.shade800,
                                      ),
                                      tooltip: 'Remove Difficult Marker',
                                      onPressed: () => _removeDifficult(q.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
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
                color: Colors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.amber.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No difficult questions yet.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Flag questions that challenge you during practice by tapping the warning flag to create a personalized study queue.',
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
