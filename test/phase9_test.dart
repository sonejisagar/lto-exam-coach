import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/routes/app_routes.dart';
import 'package:lto_exam_coach/config/ad_config.dart';
import 'package:lto_exam_coach/providers/mock_test_provider.dart';
import 'package:lto_exam_coach/providers/progress_provider.dart';
import 'package:lto_exam_coach/providers/quiz_provider.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/providers/sign_learning_provider.dart';
import 'package:lto_exam_coach/screens/home/home_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_quiz_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_result_screen.dart';
import 'package:lto_exam_coach/screens/onboarding/onboarding_screen.dart';
import 'package:lto_exam_coach/screens/practice/category_selection_screen.dart';
import 'package:lto_exam_coach/screens/practice/practice_quiz_screen.dart';
import 'package:lto_exam_coach/screens/progress/progress_screen.dart';
import 'package:lto_exam_coach/screens/road_signs/road_signs_screen.dart';
import 'package:lto_exam_coach/screens/road_signs/sign_learning_screen.dart';
import 'package:lto_exam_coach/screens/settings/settings_screen.dart';
import 'package:lto_exam_coach/services/ad_service.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:lto_exam_coach/utils/constants.dart';
import 'package:lto_exam_coach/widgets/ad_banner.dart';

void main() {
  late StorageService storageService;
  late QuestionRepository questionRepository;
  late ProgressProvider progressProvider;
  late SettingsProvider settingsProvider;
  late QuizProvider quizProvider;
  late MockTestProvider mockTestProvider;

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
    mockTestProvider = MockTestProvider(storageService: storageService);

    // Ensure AdService is in isolated test mode
    AdService.instance.setTestEnvironment(
      isTest: true,
      mockInterstitialReady: false,
    );
  });

  Widget createTestApp(Widget child) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<QuestionRepository>.value(value: questionRepository),
        Provider<AdService>.value(value: AdService.instance),
        ChangeNotifierProvider<ProgressProvider>.value(value: progressProvider),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
        ChangeNotifierProvider<MockTestProvider>.value(value: mockTestProvider),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: child,
      ),
    );
  }

  group('Group 1: AdConfig Unit Tests', () {
    test('1. Test ad unit IDs are official Google sample IDs', () {
      expect(AdConfig.testAndroidBannerId, 'ca-app-pub-3940256099942544/6300978111');
      expect(AdConfig.testAndroidInterstitialId, 'ca-app-pub-3940256099942544/1033173712');
      expect(AdConfig.testIosBannerId, 'ca-app-pub-3940256099942544/2934735716');
      expect(AdConfig.testIosInterstitialId, 'ca-app-pub-3940256099942544/4411468910');
    });

    test('2. bannerAdUnitId and interstitialAdUnitId respect isTestMode', () {
      AdConfig.isTestMode = true;
      expect(AdConfig.bannerAdUnitId, isNotEmpty);
      expect(AdConfig.interstitialAdUnitId, isNotEmpty);
      expect(AdConfig.bannerAdUnitId, contains('3940256099942544'));
      expect(AdConfig.interstitialAdUnitId, contains('3940256099942544'));
    });

    test('3. Fallback to test unit IDs when production unit IDs are empty', () {
      AdConfig.isTestMode = false;
      // In development, production IDs are blank strings, so getter falls back to test IDs
      expect(AdConfig.bannerAdUnitId, isNotEmpty);
      expect(AdConfig.interstitialAdUnitId, isNotEmpty);
      AdConfig.isTestMode = true; // restore
    });

    test('4. Privacy policy URL placeholder configuration', () {
      // Must not contain fake or broken github URLs
      expect(AdConfig.privacyPolicyUrl.startsWith('http'), isTrue);
      expect(AdConfig.privacyPolicyUrl.contains('fake'), isFalse);
    });

    test('5. Session frequency and cooldown constants', () {
      expect(AdConfig.minSecondsBetweenInterstitials, greaterThanOrEqualTo(180));
      expect(AdConfig.maxInterstitialsPerSession, equals(1));
    });
  });

  group('Group 2: AdService Lifecycle & Frequency Guard Tests', () {
    test('6. AdService starts in test environment and initial interstitial is not ready', () {
      AdService.instance.setTestEnvironment(isTest: true, mockInterstitialReady: false);
      expect(AdService.instance.isInitialized, isTrue);
      expect(AdService.instance.isInterstitialReady, isFalse);
      expect(AdService.instance.canShowInterstitial(), isFalse);
    });

    test('7. showInterstitialIfReady immediately calls onComplete when ad not ready', () {
      AdService.instance.setTestEnvironment(isTest: true, mockInterstitialReady: false);
      bool completed = false;

      AdService.instance.showInterstitialIfReady(
        onComplete: () {
          completed = true;
        },
      );

      expect(completed, isTrue);
    });

    test('8. Enabling mock interstitial allows showing and enforces cooldown', () {
      AdService.instance.setTestEnvironment(isTest: true, mockInterstitialReady: true);
      expect(AdService.instance.canShowInterstitial(), isTrue);

      bool completed = false;
      AdService.instance.showInterstitialIfReady(
        onComplete: () {
          completed = true;
        },
      );

      expect(completed, isTrue);
      // Immediately after, readiness is consumed and cooldown timestamp is set
      expect(AdService.instance.isInterstitialReady, isFalse);
      expect(AdService.instance.canShowInterstitial(), isFalse);
    });

    test('9. showPrivacyOptionsForm runs callback safely in test environment', () {
      bool called = false;
      AdService.instance.showPrivacyOptionsForm(
        onComplete: () {
          called = true;
        },
      );
      expect(called, isTrue);
    });
  });

  group('Group 3: AdBannerWidget Unit & Rendering Tests', () {
    testWidgets('10. AdBannerWidget collapses to SizedBox.shrink in test mode without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Text('Main Content'),
                AdBannerWidget(),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Main Content'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsOneWidget);
      // In test mode (or failed ad load), it collapses cleanly to zero/shrink size
      final bannerBox = tester.renderObject(find.byType(AdBannerWidget)) as RenderBox;
      expect(bannerBox.size.height, equals(0.0));
    });
  });

  group('Group 4: Active Experience Ad-Free Policy (Zero Distraction)', () {
    testWidgets('11. Practice Quiz Screen contains ZERO AdBannerWidget during active questions', (tester) async {
      quizProvider.startPractice(category: AppCategories.trafficRules);

      await tester.pumpWidget(
        createTestApp(
          const PracticeQuizScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure question is being answered and NO banner ad exists
      expect(find.textContaining('Question 1 of'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('12. Mock Exam Quiz Screen contains ZERO AdBannerWidget during active examination', (tester) async {
      final questions = questionRepository.getRandomQuestions(count: 5);
      mockTestProvider.startMockTest(
        questions: questions,
        vehicleType: 'both',
        durationSeconds: 1200,
      );

      await tester.pumpWidget(
        createTestApp(
          const MockTestQuizScreen(),
        ),
      );
      await tester.pump();

      // Ensure exam is active and NO banner ad exists
      expect(find.textContaining('Question 1 of'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsNothing);

      // Cleanly end test to cancel timer
      await mockTestProvider.submitTest();
      await tester.pumpAndSettle();
    });

    testWidgets('13. Road Signs Learning Screen contains ZERO AdBannerWidget during active quiz', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<StorageService>.value(value: storageService),
            Provider<AdService>.value(value: AdService.instance),
          ],
          child: const MaterialApp(
            home: SignLearningScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure sign quiz is active and NO banner ad exists
      expect(find.text('Road Sign Quiz'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('14. Onboarding Screen contains ZERO AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdBannerWidget), findsNothing);
    });

    testWidgets('15. Settings Screen contains ZERO AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsNothing);
    });
  });

  group('Group 5: Passive Ad & Interstitial Exit Placements', () {
    testWidgets('16. Home Screen contains passive AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('17. Category Selection Screen contains passive AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const CategorySelectionScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('18. Road Signs Screen contains passive AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const RoadSignsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('19. Progress Screen contains passive AdBannerWidget', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const ProgressScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdBannerWidget), findsOneWidget);
    });

    testWidgets('20. Mock Test Result Screen contains passive AdBannerWidget and Back to Home triggers interstitial check', (tester) async {
      final questions = questionRepository.getRandomQuestions(count: 3);
      mockTestProvider.startMockTest(
        questions: questions,
        vehicleType: 'both',
        durationSeconds: 1200,
      );
      await mockTestProvider.submitTest();

      await tester.pumpWidget(
        createTestApp(
          const MockTestResultScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Passive banner on result screen
      expect(find.byType(AdBannerWidget), findsOneWidget);
      final backHomeBtn = find.text('Back to Home');
      expect(backHomeBtn, findsOneWidget);
      await tester.ensureVisible(backHomeBtn);
      await tester.pumpAndSettle();

      // Tap Back to Home; triggers showInterstitialIfReady safely
      await tester.tap(backHomeBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('21. Practice Quiz Completion View contains passive AdBannerWidget and Back to Topics triggers interstitial', (tester) async {
      quizProvider.startPractice(category: AppCategories.trafficRules);
      // Advance to end to trigger completion
      while (!quizProvider.isCompleted) {
        quizProvider.nextQuestion();
      }

      await tester.pumpWidget(
        createTestApp(
          const PracticeQuizScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Practice Complete!'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsOneWidget);

      final backBtn = find.text('Back to Topics');
      expect(backBtn, findsOneWidget);
      await tester.ensureVisible(backBtn);
      await tester.pumpAndSettle();
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('22. Road Signs Learning Finished View contains passive AdBannerWidget and Back to Road Signs triggers interstitial', (tester) async {
      final signProvider = SignLearningProvider();
      signProvider.startSession(count: 2);
      while (!signProvider.isSessionFinished) {
        signProvider.nextQuestion();
      }

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<StorageService>.value(value: storageService),
            Provider<AdService>.value(value: AdService.instance),
          ],
          child: MaterialApp(
            home: SignLearningScreen(provider: signProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign Practice Complete!'), findsOneWidget);
      expect(find.byType(AdBannerWidget), findsOneWidget);

      final backBtn = find.text('Back to Road Signs');
      expect(backBtn, findsOneWidget);
      await tester.ensureVisible(backBtn);
      await tester.pumpAndSettle();
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
    });
  });

  group('Group 6: Settings Screen Privacy & Consent Options', () {
    testWidgets('23. Settings Screen renders Privacy Policy and Ad Consent tiles', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Ad Privacy & Consent'), findsOneWidget);
    });

    testWidgets('24. Tapping Privacy Policy opens informational dialog with offline storage and AdMob details', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final privacyTile = find.text('Privacy Policy');
      await tester.ensureVisible(privacyTile);
      await tester.pumpAndSettle();
      await tester.tap(privacyTile);
      await tester.pumpAndSettle();

      // Dialog content verification
      expect(find.text('Offline Data Storage'), findsOneWidget);
      expect(find.text('Advertising & Analytics'), findsOneWidget);
      expect(find.text('Production Policy Notice'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Offline Data Storage'), findsNothing);
    });

    testWidgets('25. Tapping Ad Privacy & Consent triggers feedback snackbar', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      final consentTile = find.text('Ad Privacy & Consent');
      await tester.ensureVisible(consentTile);
      await tester.pumpAndSettle();
      await tester.tap(consentTile);
      await tester.pumpAndSettle();

      expect(find.text('Advertising choices and consent updated.'), findsOneWidget);
    });
  });

  group('Group 7: Offline Resilience & Zero-Network Integrity', () {
    test('26. QuestionRepository operates completely offline with all 150 questions intact', () {
      final repo = QuestionRepository();
      expect(repo.getAllQuestions().length, equals(150));
      expect(repo.validateDataset(), isEmpty);
    });

    test('27. StorageService operates completely offline without network or ad dependencies', () async {
      final progress = storageService.getPracticeProgress();
      expect(progress.totalPracticeAnswered, equals(0));
      expect(storageService.getFavorites(), isEmpty);
      expect(storageService.getDifficult(), isEmpty);
    });
  });
}
