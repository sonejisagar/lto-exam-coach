import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/data/questions_data.dart';
import 'package:lto_exam_coach/models/question_model.dart';
import 'package:lto_exam_coach/providers/quiz_provider.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/practice/category_selection_screen.dart';
import 'package:lto_exam_coach/screens/practice/practice_quiz_screen.dart';
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
    questionRepository =
        QuestionRepository(questions: QuestionsData.initial30Questions);
    settingsProvider = SettingsProvider(storageService);
    quizProvider = QuizProvider(
      questionRepository: questionRepository,
      storageService: storageService,
    );
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        Provider<QuestionRepository>.value(value: questionRepository),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('1. Dataset Validation Tests', () {
    test('Dataset contains exactly 30 questions for Phase 3', () {
      expect(QuestionsData.initial30Questions.length, 30);
    });

    test('QuestionRepository validateDataset() returns zero errors', () {
      final errors = questionRepository.validateDataset();
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    test('Category distribution matches requirements', () {
      final counts = <String, int>{};
      for (final q in QuestionsData.initial30Questions) {
        counts[q.category] = (counts[q.category] ?? 0) + 1;
      }

      expect(counts[AppCategories.trafficRules], 6);
      expect(counts[AppCategories.roadSigns], 5);
      expect(counts[AppCategories.roadMarkings], 3);
      expect(counts[AppCategories.rightOfWay], 3);
      expect(counts[AppCategories.overtaking], 2);
      expect(counts[AppCategories.parking], 2);
      expect(counts[AppCategories.turning], 2);
      expect(counts[AppCategories.defensiveDriving], 2);
      expect(counts[AppCategories.vehicleBasics], 2);
      expect(counts[AppCategories.safety], 2);
      expect(counts[AppCategories.expresswayRules], 1);
    });

    test('All questions have unique IDs, 4 options, and non-empty fields', () {
      final seenIds = <String>{};
      final seenQuestions = <String>{};

      for (final q in QuestionsData.initial30Questions) {
        expect(seenIds.add(q.id), true, reason: 'Duplicate ID: ${q.id}');
        expect(seenQuestions.add(q.question.trim().toLowerCase()), true,
            reason: 'Duplicate question text: ${q.question}');
        expect(q.options.length, 4);
        expect(q.correctAnswerIndex >= 0 && q.correctAnswerIndex <= 3, true);
        expect(q.explanation.isNotEmpty, true);
        for (final opt in q.options) {
          expect(opt.trim().isNotEmpty, true);
        }
      }
    });
  });

  group('2. QuestionModel & Repository Tests', () {
    test('QuestionModel JSON serialization works properly', () {
      final q = QuestionsData.initial30Questions.first;
      final json = q.toJson();
      final fromJson = QuestionModel.fromJson(json);

      expect(fromJson.id, q.id);
      expect(fromJson.question, q.question);
      expect(fromJson.options, q.options);
      expect(fromJson.correctAnswerIndex, q.correctAnswerIndex);
      expect(fromJson.sourceReference, q.sourceReference);
    });

    test('QuestionRepository queries questions by category', () {
      final rules =
          questionRepository.getQuestionsByCategory(AppCategories.trafficRules);
      expect(rules.length, 6);
      for (final q in rules) {
        expect(q.category, AppCategories.trafficRules);
      }
    });

    test('QuestionRepository filters questions by vehicle type', () {
      final carQuestions =
          questionRepository.getQuestionsForVehicle(AppVehicleTypes.car);
      expect(carQuestions.isNotEmpty, true);
      for (final q in carQuestions) {
        expect(q.appliesToVehicle(AppVehicleTypes.car), true);
      }
    });

    test('QuestionRepository getRandomQuestions returns correct count', () {
      final random5 = questionRepository.getRandomQuestions(count: 5);
      expect(random5.length, 5);
    });

    test('QuestionRepository getQuestionById returns correct question', () {
      final q = questionRepository.getQuestionById('tr_001');
      expect(q, isNotNull);
      expect(q!.id, 'tr_001');

      final notFound = questionRepository.getQuestionById('non_existing');
      expect(notFound, isNull);
    });
  });

  group('3. QuizProvider & Persistence Tests', () {
    test('QuizProvider starts practice session correctly', () {
      quizProvider.startPractice(
        category: AppCategories.trafficRules,
        vehicleType: AppVehicleTypes.both,
      );

      expect(quizProvider.totalQuestions, 6);
      expect(quizProvider.currentIndex, 0);
      expect(quizProvider.isAnswered, false);
      expect(quizProvider.score, 0);
      expect(quizProvider.currentQuestion, isNotNull);
    });

    test('QuizProvider records answer and calculates score correctly', () {
      quizProvider.startPractice(
        category: AppCategories.trafficRules,
        vehicleType: AppVehicleTypes.both,
      );

      final q = quizProvider.currentQuestion!;
      // Select correct answer
      quizProvider.selectAnswer(q.correctAnswerIndex);

      expect(quizProvider.isAnswered, true);
      expect(quizProvider.isCorrect, true);
      expect(quizProvider.score, 1);

      // Subsequent taps should not change the answer
      quizProvider.selectAnswer((q.correctAnswerIndex + 1) % 4);
      expect(quizProvider.selectedAnswerIndex, q.correctAnswerIndex);
    });

    test('QuizProvider advances to next question', () {
      quizProvider.startPractice(
        category: AppCategories.trafficRules,
        vehicleType: AppVehicleTypes.both,
      );

      quizProvider.selectAnswer(quizProvider.currentQuestion!.correctAnswerIndex);
      quizProvider.nextQuestion();

      expect(quizProvider.currentIndex, 1);
      expect(quizProvider.isAnswered, false);
    });

    test('QuizProvider handles practice completion', () {
      quizProvider.startPractice(
        category: AppCategories.expresswayRules, // 1 question
        vehicleType: AppVehicleTypes.both,
      );

      expect(quizProvider.totalQuestions, 1);
      quizProvider.selectAnswer(quizProvider.currentQuestion!.correctAnswerIndex);
      quizProvider.nextQuestion();

      expect(quizProvider.isCompleted, true);
      expect(quizProvider.score, 1);
      expect(quizProvider.accuracy, 100.0);
    });

    test('StorageService persists favorite and difficult question IDs', () async {
      const qId = 'tr_001';
      expect(storageService.isFavorite(qId), false);

      await storageService.toggleFavorite(qId);
      expect(storageService.isFavorite(qId), true);

      await storageService.toggleFavorite(qId);
      expect(storageService.isFavorite(qId), false);

      expect(storageService.isDifficult(qId), false);
      await storageService.toggleDifficult(qId);
      expect(storageService.isDifficult(qId), true);
    });
  });

  group('4. Widget Tests for Practice Flow', () {
    testWidgets('CategorySelectionScreen renders categories and total count',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const CategorySelectionScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Practice by Topic'), findsOneWidget);
      expect(find.text('All Questions'), findsOneWidget);
      expect(find.text(AppCategories.trafficRules), findsOneWidget);
      expect(find.text(AppCategories.roadSigns), findsOneWidget);
      expect(find.text('6 Questions'), findsOneWidget); // Traffic rules count
    });

    testWidgets('PracticeQuizScreen renders question and allows selecting option',
        (WidgetTester tester) async {
      quizProvider.startPractice(
        category: AppCategories.trafficRules,
        vehicleType: AppVehicleTypes.both,
      );

      await tester.pumpWidget(createTestWidget(const PracticeQuizScreen()));
      await tester.pumpAndSettle();

      // Check header
      expect(find.text('Question 1 of 6'), findsOneWidget);
      expect(find.text('Traffic Rules'), findsOneWidget);

      // Verify question options exist
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);

      // Next Question button should be disabled before answering
      final nextButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(nextButton.onPressed, isNull);

      // Tap option A
      await tester.tap(find.text('A'));
      await tester.pumpAndSettle();

      // Explanation should now be visible
      expect(find.byType(FilledButton), findsOneWidget);
      final nextButtonActive =
          tester.widget<FilledButton>(find.byType(FilledButton));
      expect(nextButtonActive.onPressed, isNotNull);
    });

    testWidgets('Practice completion screen displays score and actions',
        (WidgetTester tester) async {
      quizProvider.startPractice(
        category: AppCategories.expresswayRules,
        vehicleType: AppVehicleTypes.both,
      );

      await tester.pumpWidget(createTestWidget(const PracticeQuizScreen()));
      await tester.pumpAndSettle();

      // Answer question
      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();

      // Tap Finish Practice
      await tester.tap(find.text('Finish Practice'));
      await tester.pumpAndSettle();

      expect(find.text('Practice Complete!'), findsOneWidget);
      expect(find.text('1 / 1'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Practice Again'), findsOneWidget);
      expect(find.text('Back to Topics'), findsOneWidget);
    });
  });
}
