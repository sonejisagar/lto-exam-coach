import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/routes/app_routes.dart';
import 'package:lto_exam_coach/providers/mock_test_provider.dart';
import 'package:lto_exam_coach/providers/quiz_provider.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/difficult_questions/difficult_questions_screen.dart';
import 'package:lto_exam_coach/screens/favorites/favorites_screen.dart';
import 'package:lto_exam_coach/screens/review/question_review_screen.dart';
import 'package:lto_exam_coach/screens/wrong_answers/wrong_answers_screen.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:lto_exam_coach/utils/constants.dart';

void main() {
  late StorageService storageService;
  late QuestionRepository questionRepository;
  late SettingsProvider settingsProvider;
  late QuizProvider quizProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
    questionRepository = QuestionRepository();
    settingsProvider = SettingsProvider(storageService);
    quizProvider = QuizProvider(
      questionRepository: questionRepository,
      storageService: storageService,
    );
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<QuestionRepository>.value(value: questionRepository),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: child,
      ),
    );
  }

  group('Phase 6 — Wrong Answers & Personal Review Unit Tests', () {
    test('1. Wrong answer is persisted in StorageService', () async {
      expect(storageService.isWrongAnswer('tr_001'), isFalse);
      await storageService.addWrongAnswer('tr_001');
      expect(storageService.isWrongAnswer('tr_001'), isTrue);
      expect(storageService.getWrongAnswerIds().contains('tr_001'), isTrue);
    });

    test('2. Duplicate wrong answer is prevented in StorageService', () async {
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('tr_001');
      expect(storageService.getWrongAnswerIds().length, 1);
    });

    test('3. Wrong answer can be removed from StorageService', () async {
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('tr_002');
      expect(storageService.getWrongAnswerIds().length, 2);

      await storageService.removeWrongAnswer('tr_001');
      expect(storageService.isWrongAnswer('tr_001'), isFalse);
      expect(storageService.isWrongAnswer('tr_002'), isTrue);
      expect(storageService.getWrongAnswerIds().length, 1);
    });

    test('4. Clearing wrong answers works without affecting other data', () async {
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('tr_002');
      await storageService.toggleFavorite('tr_001');
      await storageService.toggleDifficult('tr_003');

      await storageService.clearWrongAnswers();
      expect(storageService.getWrongAnswerIds(), isEmpty);
      // Verify favorites and difficult were preserved
      expect(storageService.getFavorites().contains('tr_001'), isTrue);
      expect(storageService.getDifficult().contains('tr_003'), isTrue);
    });

    test('5. Invalid or missing stored IDs are handled safely by QuestionRepository', () {
      final ids = ['tr_001', 'non_existent_id_999', 'rs_001', 'fake_id'];
      final resolved = questionRepository.getQuestionsByIds(ids);
      expect(resolved.length, 2);
      expect(resolved[0].id, 'tr_001');
      expect(resolved[1].id, 'rs_001');
    });

    test('6. Favorite list loads and removal works in StorageService', () async {
      await storageService.toggleFavorite('rs_001');
      await storageService.toggleFavorite('rs_002');
      expect(storageService.getFavorites().length, 2);

      await storageService.removeFavorite('rs_001');
      expect(storageService.getFavorites().contains('rs_001'), isFalse);
      expect(storageService.getFavorites().contains('rs_002'), isTrue);
      expect(storageService.getFavorites().length, 1);
    });

    test('7. Difficult list loads and removal works in StorageService', () async {
      await storageService.toggleDifficult('rm_001');
      await storageService.toggleDifficult('rm_002');
      expect(storageService.getDifficult().length, 2);

      await storageService.removeDifficult('rm_001');
      expect(storageService.getDifficult().contains('rm_001'), isFalse);
      expect(storageService.getDifficult().contains('rm_002'), isTrue);
      expect(storageService.getDifficult().length, 1);
    });

    test('8. Practice Mode records incorrect answers and ignores correct answers', () {
      quizProvider.startPractice(category: AppCategories.trafficRules);
      final firstQ = quizProvider.currentQuestion!;
      final wrongOption = (firstQ.correctAnswerIndex + 1) % 4;

      quizProvider.selectAnswer(wrongOption);
      expect(storageService.isWrongAnswer(firstQ.id), isTrue);

      quizProvider.nextQuestion();
      final secondQ = quizProvider.currentQuestion!;
      quizProvider.selectAnswer(secondQ.correctAnswerIndex);
      // Correct answer does NOT add to wrong answers
      expect(storageService.isWrongAnswer(secondQ.id), isFalse);
    });

    test('9. Explicit removeCurrentFromWrongAnswers clears mistake status', () async {
      final q = questionRepository.getAllQuestions().first;
      await storageService.addWrongAnswer(q.id);
      expect(storageService.isWrongAnswer(q.id), isTrue);

      quizProvider.startTargetedPractice(questions: [q]);
      expect(quizProvider.isCurrentWrongAnswer, isTrue);

      await quizProvider.removeCurrentFromWrongAnswers();
      expect(quizProvider.isCurrentWrongAnswer, isFalse);
      expect(storageService.isWrongAnswer(q.id), isFalse);
    });

    test('10. Targeted wrong-answer practice loads correct questions', () async {
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('rs_001');
      final questions = questionRepository.getQuestionsByIds(storageService.getWrongAnswerIds());

      quizProvider.startTargetedPractice(
        questions: questions,
        title: 'Practice Mistakes',
        shuffle: false,
      );

      expect(quizProvider.totalQuestions, 2);
      expect(quizProvider.currentCategory, 'Practice Mistakes');
      expect(quizProvider.sessionQuestions.map((q) => q.id).toSet(), {'tr_001', 'rs_001'});
    });

    test('11. Targeted favorite and difficult practice load correct questions', () async {
      await storageService.toggleFavorite('pk_001');
      final favQuestions = questionRepository.getQuestionsByIds(storageService.getFavorites());

      quizProvider.startTargetedPractice(
        questions: favQuestions,
        title: 'Practice Favorites',
      );
      expect(quizProvider.totalQuestions, 1);
      expect(quizProvider.currentQuestion?.id, 'pk_001');

      await storageService.toggleDifficult('ov_001');
      final diffQuestions = questionRepository.getQuestionsByIds(storageService.getDifficult());

      quizProvider.startTargetedPractice(
        questions: diffQuestions,
        title: 'Practice Difficult',
      );
      expect(quizProvider.totalQuestions, 1);
      expect(quizProvider.currentQuestion?.id, 'ov_001');
    });

    test('12. Empty targeted practice does not crash', () {
      expect(() {
        quizProvider.startTargetedPractice(
          questions: [],
          title: 'Empty Practice',
        );
      }, returnsNormally);

      expect(quizProvider.totalQuestions, 0);
      expect(quizProvider.currentQuestion, isNull);
    });

    test('13. Mock exam does NOT record wrong answers into storage', () async {
      final mockProvider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      mockProvider.startMockTest(questions: questions, vehicleType: 'both');

      // Answer all incorrectly
      for (int i = 0; i < questions.length; i++) {
        final wrongOption = (questions[i].correctAnswerIndex + 1) % 4;
        mockProvider.selectAnswer(wrongOption);
        if (i < questions.length - 1) mockProvider.nextQuestion();
      }
      await mockProvider.submitTest();

      // Wrong answers bank must remain empty
      expect(storageService.getWrongAnswerIds(), isEmpty);
      mockProvider.dispose();
    });
  });

  group('Phase 6 — Widget Tests for Learning & Review Screens', () {
    testWidgets('14. WrongAnswersScreen empty state renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const WrongAnswersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Wrong Answers (0)'), findsOneWidget);
      expect(find.text('No Mistakes Yet!'), findsOneWidget);
      expect(
        find.textContaining('Questions you answer incorrectly'),
        findsOneWidget,
      );
      expect(find.text('Practice Mistakes'), findsNothing);
    });

    testWidgets('15. WrongAnswersScreen populated state displays questions and clear dialog',
        (WidgetTester tester) async {
      await storageService.addWrongAnswer('tr_001');
      await storageService.addWrongAnswer('rs_001');

      await tester.pumpWidget(createTestWidget(const WrongAnswersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Wrong Answers (2)'), findsOneWidget);
      expect(find.text('Practice Mistakes'), findsOneWidget);
      expect(find.text('2 Questions to Review'), findsOneWidget);

      // Verify clear confirmation dialog
      await tester.tap(find.byIcon(Icons.delete_sweep_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Clear Wrong Answers?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(storageService.getWrongAnswerIds().length, 2);

      // Tap Clear and confirm
      await tester.tap(find.byIcon(Icons.delete_sweep_outlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear All'));
      await tester.pumpAndSettle();

      expect(storageService.getWrongAnswerIds(), isEmpty);
      expect(find.text('No Mistakes Yet!'), findsOneWidget);
    });

    testWidgets('16. FavoritesScreen empty and populated states work properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const FavoritesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Favorite Questions (0)'), findsOneWidget);
      expect(find.text('No favorite questions yet.'), findsOneWidget);

      // Add a favorite and pump fresh widget
      await storageService.toggleFavorite('tr_001');
      await tester.pumpWidget(createTestWidget(FavoritesScreen(key: UniqueKey())));
      await tester.pumpAndSettle();

      expect(find.text('Favorite Questions (1)'), findsOneWidget);
      expect(find.text('Practice Favorites'), findsOneWidget);
      expect(find.text('Review Question'), findsOneWidget);

      // Remove favorite
      await tester.tap(find.byIcon(Icons.favorite_rounded));
      await tester.pumpAndSettle();

      expect(storageService.getFavorites(), isEmpty);
      expect(find.text('No favorite questions yet.'), findsOneWidget);
    });

    testWidgets('17. DifficultQuestionsScreen empty and populated states work properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const DifficultQuestionsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Difficult Questions (0)'), findsOneWidget);
      expect(find.text('No difficult questions yet.'), findsOneWidget);

      // Flag a difficult question and pump fresh widget
      await storageService.toggleDifficult('rm_001');
      await tester.pumpWidget(createTestWidget(DifficultQuestionsScreen(key: UniqueKey())));
      await tester.pumpAndSettle();

      expect(find.text('Difficult Questions (1)'), findsOneWidget);
      expect(find.text('Practice Difficult'), findsOneWidget);
      expect(find.text('Review Question'), findsOneWidget);

      // Remove difficult marker
      await tester.tap(find.byIcon(Icons.warning_rounded));
      await tester.pumpAndSettle();

      expect(storageService.getDifficult(), isEmpty);
      expect(find.text('No difficult questions yet.'), findsOneWidget);
    });

    testWidgets('18. QuestionReviewScreen renders question, green correct choice, and toggles',
        (WidgetTester tester) async {
      final q = questionRepository.getAllQuestions().first;
      await tester.pumpWidget(createTestWidget(QuestionReviewScreen(question: q)));
      await tester.pumpAndSettle();

      expect(find.text('Question Details'), findsOneWidget);
      expect(find.text(q.question), findsOneWidget);
      expect(find.text('Correct Answer Explanation'), findsOneWidget);
      expect(find.text(q.explanation), findsOneWidget);
      expect(find.text('Mark as Mistake'), findsOneWidget);

      // Ensure button is visible in scroll view before tapping
      await tester.ensureVisible(find.text('Mark as Mistake'));
      await tester.pumpAndSettle();

      // Tap Mark as Mistake
      await tester.tap(find.text('Mark as Mistake'));
      await tester.pumpAndSettle();
      expect(storageService.isWrongAnswer(q.id), isTrue);
      expect(find.text('Remove from Wrong Answers Bank'), findsOneWidget);

      // Toggle favorite
      await tester.tap(find.byIcon(Icons.favorite_border_rounded));
      await tester.pumpAndSettle();
      expect(storageService.isFavorite(q.id), isTrue);
    });
  });
}
