import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/routes/app_routes.dart';
import 'package:lto_exam_coach/providers/progress_provider.dart';
import 'package:lto_exam_coach/providers/quiz_provider.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/home/home_screen.dart';
import 'package:lto_exam_coach/screens/onboarding/onboarding_screen.dart';
import 'package:lto_exam_coach/screens/onboarding/vehicle_selection_screen.dart';
import 'package:lto_exam_coach/screens/practice/practice_quiz_screen.dart';
import 'package:lto_exam_coach/screens/settings/about_screen.dart';
import 'package:lto_exam_coach/services/ad_service.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storageService;
  late QuestionRepository questionRepository;
  late ProgressProvider progressProvider;
  late SettingsProvider settingsProvider;
  late QuizProvider quizProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
    questionRepository = QuestionRepository();
    progressProvider = ProgressProvider(storageService);
    settingsProvider = SettingsProvider(storageService);
    quizProvider = QuizProvider(
      questionRepository: questionRepository,
      storageService: storageService,
      progressProvider: progressProvider,
    );
    AdService.instance.setTestEnvironment(isTest: true);
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<QuestionRepository>.value(value: questionRepository),
        ChangeNotifierProvider<ProgressProvider>.value(value: progressProvider),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: child,
      ),
    );
  }

  group('Deep Audit & Production Bug Fix Tests', () {
    testWidgets('1. OnboardingScreen disposes its PageController cleanly without memory leak', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                );
              },
              child: const Text('Open Onboarding'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Onboarding'));
      await tester.pumpAndSettle();

      expect(find.text('Prepare Smarter'), findsOneWidget);

      // Navigate back to trigger dispose
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('Open Onboarding'), findsOneWidget);
    });

    testWidgets('2. VehicleSelectionScreen in modal mode pops instead of clearing navigation stack', (tester) async {
      await tester.pumpWidget(createTestWidget(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VehicleSelectionScreen(isModal: true),
                ),
              );
            },
            child: const Text('Open Modal Selection'),
          ),
        ),
      ));

      await tester.tap(find.text('Open Modal Selection'));
      await tester.pumpAndSettle();

      expect(find.text('What are you preparing for?'), findsOneWidget);

      // Tap Car option and submit
      await tester.tap(find.text('Car (Non-Professional)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Continue'));
      await tester.pumpAndSettle();

      // Verify it popped back to original screen
      expect(find.text('Open Modal Selection'), findsOneWidget);
      expect(settingsProvider.vehicleType, equals('car'));
    });

    testWidgets('3. AboutScreen privacy dialog includes both offline storage and AdMob disclosures', (tester) async {
      await tester.pumpWidget(createTestWidget(const AboutScreen()));
      await tester.pumpAndSettle();

      // Scroll to Privacy Policy card and tap
      final privacyFinder = find.text('Privacy Policy');
      await tester.scrollUntilVisible(privacyFinder, 200);
      await tester.pumpAndSettle();

      await tester.tap(privacyFinder);
      await tester.pumpAndSettle();

      expect(find.text('Offline Data Storage'), findsOneWidget);
      expect(find.text('Advertising & Analytics'), findsOneWidget);
      expect(find.textContaining('Google AdMob'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Offline Data Storage'), findsNothing);
    });

    testWidgets('4. Practice completion view renders score, accuracy, and actions inside scrollable layout', (tester) async {
      quizProvider.startPractice(count: 5);
      // Answer all 5 questions
      for (int i = 0; i < 5; i++) {
        quizProvider.selectAnswer(quizProvider.currentQuestion!.correctAnswerIndex);
        quizProvider.nextQuestion();
      }

      expect(quizProvider.isCompleted, isTrue);

      await tester.pumpWidget(createTestWidget(const PracticeQuizScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Practice Complete!'), findsOneWidget);
      expect(find.text('5 / 5'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
      expect(find.text('Practice Again'), findsOneWidget);
      expect(find.text('Back to Topics'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('5. HomeScreen dynamically displays questions left to review and reactive today summary', (tester) async {
      await tester.pumpWidget(createTestWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      // Initially 150 questions left
      expect(find.text('150 Questions Left to Review'), findsOneWidget);
      expect(find.text("Today's Summary"), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);

      // Record a practice attempt today
      await progressProvider.recordPracticeAttempt(
        questionId: 'tr_001',
        category: 'Traffic Rules & Regulations',
        difficulty: 'Easy',
        isCorrect: true,
      );

      await tester.pumpAndSettle();

      // Subtitle dynamically updates to 149 questions left
      expect(find.text('149 Questions Left to Review'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // 1 today
    });

    test('6. AdService safeComplete callback runs at most once', () {
      int completions = 0;
      AdService.instance.setTestEnvironment(isTest: true, mockInterstitialReady: true);
      AdService.instance.showInterstitialIfReady(onComplete: () {
        completions++;
      });
      expect(completions, equals(1));
    });
  });
}
