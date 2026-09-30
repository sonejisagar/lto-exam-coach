import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/models/mock_test_result.dart';
import 'package:lto_exam_coach/providers/mock_test_provider.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_quiz_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_result_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_review_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_setup_screen.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:lto_exam_coach/utils/constants.dart';

void main() {
  late StorageService storageService;
  late QuestionRepository questionRepository;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
    questionRepository = QuestionRepository();
  });

  group('1. Mock Test Result Model & Storage Tests', () {
    test('MockTestResult serializes and deserializes correctly via JSON', () {
      final result = MockTestResult(
        id: 'test_123',
        timestamp: DateTime.parse('2026-09-18T10:00:00Z'),
        vehicleType: 'both',
        questionCount: 20,
        correctCount: 16,
        incorrectCount: 3,
        unansweredCount: 1,
        percentage: 80.0,
        timeUsedSeconds: 650,
        categoryPerformance: {
          AppCategories.trafficRules: 100.0,
          AppCategories.roadSigns: 75.0,
        },
        userAnswers: {'q1': 0, 'q2': 2},
      );

      final jsonStr = result.toJson();
      final fromJson = MockTestResult.fromJson(jsonStr);

      expect(fromJson.id, 'test_123');
      expect(fromJson.vehicleType, 'both');
      expect(fromJson.questionCount, 20);
      expect(fromJson.correctCount, 16);
      expect(fromJson.incorrectCount, 3);
      expect(fromJson.unansweredCount, 1);
      expect(fromJson.percentage, 80.0);
      expect(fromJson.timeUsedSeconds, 650);
      expect(fromJson.isPassed, true);
      expect(fromJson.categoryPerformance[AppCategories.trafficRules], 100.0);
      expect(fromJson.userAnswers['q1'], 0);
    });

    test('StorageService saves mock test results and caps at 50 entries', () async {
      for (int i = 0; i < 55; i++) {
        await storageService.saveMockTestResult(
          MockTestResult(
            id: 'attempt_$i',
            timestamp: DateTime.now(),
            vehicleType: 'car',
            questionCount: 20,
            correctCount: 15,
            incorrectCount: 5,
            unansweredCount: 0,
            percentage: 75.0,
            timeUsedSeconds: 500,
            categoryPerformance: {},
          ),
        );
      }

      final history = storageService.getMockTestHistory();
      expect(history.length, 50);
      // Most recent should be first
      expect(history.first.id, 'attempt_54');
    });
  });

  group('2. MockTestProvider Unit Tests', () {
    test('Starting 20-question test configures 20 unique questions and 20 mins timer', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(
        count: 20,
        vehicleType: AppVehicleTypes.both,
      );

      provider.startMockTest(
        questions: questions,
        vehicleType: AppVehicleTypes.both,
      );

      expect(provider.totalQuestions, 20);
      expect(provider.questions.length, 20);
      expect(provider.totalSeconds, 1200);
      expect(provider.remainingSeconds, 1200);
      expect(provider.formattedRemainingTime, '20:00');
      expect(provider.isSubmitted, false);

      // Verify no duplicate questions
      final uniqueIds = provider.questions.map((q) => q.id).toSet();
      expect(uniqueIds.length, 20);

      provider.dispose();
    });

    test('Starting 30-question test configures 30 unique questions and 30 mins timer', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(
        count: 30,
        vehicleType: AppVehicleTypes.both,
      );

      provider.startMockTest(
        questions: questions,
        vehicleType: AppVehicleTypes.both,
      );

      expect(provider.totalQuestions, 30);
      expect(provider.totalSeconds, 1800);
      expect(provider.remainingSeconds, 1800);
      expect(provider.formattedRemainingTime, '30:00');

      final uniqueIds = provider.questions.map((q) => q.id).toSet();
      expect(uniqueIds.length, 30);

      provider.dispose();
    });

    test('Vehicle filtering only includes questions matching vehicle preference', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(
        count: 30,
        vehicleType: AppVehicleTypes.motorcycle,
      );

      provider.startMockTest(
        questions: questions,
        vehicleType: AppVehicleTypes.motorcycle,
      );

      for (final q in provider.questions) {
        expect(q.appliesToVehicle(AppVehicleTypes.motorcycle), isTrue);
      }

      provider.dispose();
    });

    test('Answer selection and changing answers before submission', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      provider.startMockTest(questions: questions, vehicleType: 'both');

      // Select option 1
      provider.selectAnswer(1);
      expect(provider.currentSelectedAnswer, 1);
      expect(provider.isQuestionAnswered(0), true);
      expect(provider.answeredCount, 1);
      expect(provider.unansweredCount, 4);

      // Change answer to option 3
      provider.selectAnswer(3);
      expect(provider.currentSelectedAnswer, 3);
      expect(provider.answeredCount, 1);

      provider.dispose();
    });

    test('Navigation between questions preserves answers', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      provider.startMockTest(questions: questions, vehicleType: 'both');

      provider.selectAnswer(2);
      provider.nextQuestion();
      expect(provider.currentIndex, 1);
      expect(provider.currentSelectedAnswer, isNull);

      provider.selectAnswer(0);
      provider.previousQuestion();
      expect(provider.currentIndex, 0);
      expect(provider.currentSelectedAnswer, 2);

      provider.navigateToQuestion(4);
      expect(provider.currentIndex, 4);

      provider.dispose();
    });

    test('Score, percentage, and category performance calculation on submit', () async {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      provider.startMockTest(
        questions: questions,
        vehicleType: 'both',
        durationSeconds: 300,
      );

      // Answer first 3 questions: 2 correct, 1 wrong, 2 unanswered
      provider.navigateToQuestion(0);
      provider.selectAnswer(questions[0].correctAnswerIndex);

      provider.navigateToQuestion(1);
      provider.selectAnswer(questions[1].correctAnswerIndex);

      provider.navigateToQuestion(2);
      // Wrong answer
      final wrongIndex = (questions[2].correctAnswerIndex + 1) % 4;
      provider.selectAnswer(wrongIndex);

      final result = await provider.submitTest();

      expect(result, isNotNull);
      expect(result!.correctCount, 2);
      expect(result.incorrectCount, 1);
      expect(result.unansweredCount, 2);
      expect(result.percentage, (2 / 5) * 100);
      expect(provider.isSubmitted, true);

      // Check that result is saved in storage
      final history = storageService.getMockTestHistory();
      expect(history.isNotEmpty, true);
      expect(history.first.correctCount, 2);

      provider.dispose();
    });

    test('Double submission guard: subsequent calls return existing result', () async {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      provider.startMockTest(questions: questions, vehicleType: 'both');

      final res1 = await provider.submitTest();
      final res2 = await provider.submitTest();

      expect(res1, same(res2));
      // Storage should only have 1 entry
      expect(storageService.getMockTestHistory().length, 1);

      provider.dispose();
    });

    test('Cancel exam cancels timer and resets state cleanly', () {
      final provider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      provider.startMockTest(questions: questions, vehicleType: 'both');

      provider.selectAnswer(1);
      provider.cancelExam();

      expect(provider.questions.isEmpty, true);
      expect(provider.answeredCount, 0);
      expect(provider.currentIndex, 0);
      expect(provider.isSubmitted, false);

      provider.dispose();
    });
  });

  group('3. Widget Tests for Mock Exam Flow', () {
    Widget createMockTestApp({
      required Widget child,
      MockTestProvider? mockProvider,
    }) {
      final settings = SettingsProvider(storageService);
      final mock = mockProvider ?? MockTestProvider(storageService: storageService);

      return MultiProvider(
        providers: [
          Provider<QuestionRepository>.value(value: questionRepository),
          ChangeNotifierProvider<SettingsProvider>.value(value: settings),
          ChangeNotifierProvider<MockTestProvider>.value(value: mock),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('MockTestSetupScreen renders title, chips, info card, and start button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createMockTestApp(child: const MockTestSetupScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mock Exam'), findsWidgets);
      expect(find.text('Test your knowledge with a timed practice exam.'), findsOneWidget);
      expect(find.text('Practice only'), findsOneWidget);
      expect(
        find.text(
          'This mock exam is an independent study tool. It is not an official LTO examination.',
        ),
        findsOneWidget,
      );

      // Question count chips
      expect(find.text('20 Questions'), findsOneWidget);
      expect(find.text('30 Questions'), findsOneWidget);

      // Vehicle chips
      expect(find.text('Car'), findsOneWidget);
      expect(find.text('Motorcycle'), findsOneWidget);
      expect(find.text('Both'), findsOneWidget);

      // Start button
      expect(find.text('Start Mock Exam'), findsOneWidget);

      // Tap 30 Questions chip
      await tester.tap(find.text('30 Questions'));
      await tester.pumpAndSettle();

      // Tap Motorcycle chip
      await tester.tap(find.text('Motorcycle'));
      await tester.pumpAndSettle();
    });

    testWidgets('MockTestQuizScreen renders question, options without green/red feedback, and submit dialog',
        (WidgetTester tester) async {
      final mockProvider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 3);
      mockProvider.startMockTest(
        questions: questions,
        vehicleType: 'both',
        durationSeconds: 1200,
      );

      await tester.pumpWidget(
        createMockTestApp(
          child: const MockTestQuizScreen(),
          mockProvider: mockProvider,
        ),
      );
      await tester.pumpAndSettle();

      // Header Question count & timer
      expect(find.text('Question 1 of 3'), findsOneWidget);
      expect(find.text('20:00'), findsOneWidget);

      // First question text
      expect(find.text(questions[0].question), findsOneWidget);

      // Verify 4 options rendered
      expect(find.text(questions[0].options[0]), findsOneWidget);
      expect(find.text(questions[0].options[1]), findsOneWidget);
      expect(find.text(questions[0].options[2]), findsOneWidget);
      expect(find.text(questions[0].options[3]), findsOneWidget);

      // Select an option
      await tester.tap(find.text(questions[0].options[1]));
      await tester.pumpAndSettle();

      expect(mockProvider.currentSelectedAnswer, 1);
      expect(mockProvider.answeredCount, 1);

      // Verify no immediate explanation is displayed
      expect(find.text('Explanation'), findsNothing);

      // Tap Question list button (Grid)
      await tester.tap(find.byIcon(Icons.grid_view_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Question Navigator'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.byIcon(Icons.close_rounded).last);
      await tester.pumpAndSettle();

      // Tap Submit button
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify Submit confirmation dialog appears
      expect(find.text('Submit Mock Exam?'), findsOneWidget);
      expect(find.text('Answered:'), findsOneWidget);
      expect(find.text('Unanswered:'), findsOneWidget);
      expect(find.text('Continue Exam'), findsOneWidget);
      expect(find.text('Submit Exam'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('Continue Exam'));
      await tester.pumpAndSettle();
      expect(find.text('Submit Mock Exam?'), findsNothing);

      mockProvider.dispose();
    });

    testWidgets('MockTestResultScreen renders score, stats, category breakdown, and action buttons',
        (WidgetTester tester) async {
      final mockProvider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 5);
      mockProvider.startMockTest(
        questions: questions,
        vehicleType: 'both',
        durationSeconds: 300,
      );

      mockProvider.selectAnswer(questions[0].correctAnswerIndex);
      mockProvider.nextQuestion();
      mockProvider.selectAnswer(questions[1].correctAnswerIndex);
      await mockProvider.submitTest();

      await tester.pumpWidget(
        createMockTestApp(
          child: const MockTestResultScreen(),
          mockProvider: mockProvider,
        ),
      );
      await tester.pumpAndSettle();

      // Header and result titles
      expect(find.text('Mock Exam Complete'), findsOneWidget);
      expect(find.text('Practice Result'), findsOneWidget);
      expect(find.text('2 / 5'), findsOneWidget);
      expect(find.text('40.0%'), findsOneWidget);

      // Stats
      expect(find.text('Correct'), findsOneWidget);
      expect(find.text('Incorrect'), findsOneWidget);
      expect(find.text('Unanswered'), findsOneWidget);
      expect(find.text('Time Used'), findsOneWidget);

      // Topic Breakdown
      expect(find.text('Topic Breakdown'), findsOneWidget);

      // Action buttons
      expect(find.text('Review Answers'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);

      // Disclaimer
      expect(
        find.text(
          'This is an independent educational reviewer and is not affiliated with or endorsed by the Land Transportation Office (LTO).',
        ),
        findsOneWidget,
      );

      mockProvider.dispose();
    });

    testWidgets('MockTestReviewScreen displays questions, user answer, and correct answer in green',
        (WidgetTester tester) async {
      final mockProvider = MockTestProvider(storageService: storageService);
      final questions = questionRepository.getRandomQuestions(count: 2);
      mockProvider.startMockTest(
        questions: questions,
        vehicleType: 'both',
      );

      // Answer question 0 correctly
      mockProvider.selectAnswer(questions[0].correctAnswerIndex);
      await mockProvider.submitTest();

      await tester.pumpWidget(
        createMockTestApp(
          child: const MockTestReviewScreen(),
          mockProvider: mockProvider,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Review (1/2)'), findsOneWidget);
      expect(find.text('Correct'), findsWidgets);
      expect(find.text('Explanation'), findsOneWidget);
      expect(find.text(questions[0].explanation), findsOneWidget);

      // Next question
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Review (2/2)'), findsOneWidget);
      expect(find.text('Unanswered'), findsWidgets);

      mockProvider.dispose();
    });
  });
}
