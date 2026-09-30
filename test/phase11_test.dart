import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lto_exam_coach/data/questions_filipino.dart';
import 'package:lto_exam_coach/models/question_model.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';
import 'package:lto_exam_coach/screens/home/home_screen.dart';
import 'package:lto_exam_coach/screens/mock_test/mock_test_setup_screen.dart';
import 'package:lto_exam_coach/screens/settings/settings_screen.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 11 — Language Support & UI Polish Tests', () {
    late StorageService storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storage = StorageService(prefs);
    });

    test('1. Default language is English ("en")', () {
      expect(storage.languageCode, equals('en'));
      final provider = SettingsProvider(storage);
      expect(provider.languageCode, equals('en'));
      expect(provider.languageLabel, equals('English'));
      expect(provider.locale, equals(const Locale('en')));
    });

    test('2. Setting language to Filipino ("fil") persists in storage and updates SettingsProvider', () async {
      final provider = SettingsProvider(storage);
      await provider.setLanguageCode('fil');

      expect(provider.languageCode, equals('fil'));
      expect(provider.languageLabel, equals('Filipino'));
      expect(provider.locale, equals(const Locale('fil')));
      expect(storage.languageCode, equals('fil'));

      // Verify persistence across new provider instance
      final newProvider = SettingsProvider(storage);
      expect(newProvider.languageCode, equals('fil'));
    });

    test('3. Language labels are strictly "English" and "Filipino" (no Tagalog or Philippines label)', () {
      final provider = SettingsProvider(storage);
      expect(provider.languageLabel, equals('English'));

      provider.setLanguageCode('fil');
      expect(provider.languageLabel, equals('Filipino'));
    });

    test('4. QuestionModel extension provides Filipino translations when available', () {
      final repo = QuestionRepository();
      final q = repo.getQuestionById('tr_001');
      expect(q, isNotNull);

      final enText = q!.getLocalizedQuestion('en');
      final filText = q.getLocalizedQuestion('fil');

      expect(enText, equals(q.question));
      expect(filText, isNotEmpty);
      expect(filText, isNot(equals(enText)));

      final enOpts = q.getLocalizedOptions('en');
      final filOpts = q.getLocalizedOptions('fil');

      expect(enOpts.length, equals(filOpts.length));
      expect(filOpts[q.correctAnswerIndex], isNotEmpty);

      final enExpl = q.getLocalizedExplanation('en');
      final filExpl = q.getLocalizedExplanation('fil');
      expect(filExpl, isNotEmpty);
      expect(filExpl, isNot(equals(enExpl)));
    });

    test('5. Localized questions gracefully fall back to English if translation is missing', () {
      const customQ = QuestionModel(
        id: 'q_test_non_existent',
        question: 'What does this custom sign mean?',
        options: ['Option 1', 'Option 2', 'Option 3'],
        correctAnswerIndex: 1,
        category: 'Test Category',
        difficulty: 'easy',
        vehicleTypes: ['car', 'motorcycle'],
        explanation: 'This is a test explanation.',
      );

      expect(customQ.getLocalizedQuestion('fil'), equals('What does this custom sign mean?'));
      expect(customQ.getLocalizedOptions('fil'), equals(['Option 1', 'Option 2', 'Option 3']));
      expect(customQ.getLocalizedExplanation('fil'), equals('This is a test explanation.'));
    });

    test('6. Scoring invariance: Filipino translations maintain the exact same correct answer index and options count', () {
      final repo = QuestionRepository();
      final allQuestions = repo.getAllQuestions();

      for (final q in allQuestions) {
        final filOptions = q.getLocalizedOptions('fil');
        expect(filOptions.length, equals(q.options.length),
            reason: 'Options length mismatch for question ${q.id}');
        expect(q.correctAnswerIndex, inInclusiveRange(0, filOptions.length - 1),
            reason: 'Correct answer index out of range for ${q.id}');
      }
    });

    testWidgets('7. Settings screen contains GENERAL, STUDY, and ABOUT section headers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<StorageService>.value(value: storage),
              ChangeNotifierProvider<SettingsProvider>(
                create: (_) => SettingsProvider(storage),
              ),
            ],
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GENERAL'), findsOneWidget);
      expect(find.text('STUDY'), findsOneWidget);
      expect(find.text('ABOUT'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('8. Home screen displays 7 structured study modes in a content-first list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<StorageService>.value(value: storage),
              Provider<QuestionRepository>(create: (_) => QuestionRepository()),
              ChangeNotifierProvider<SettingsProvider>(
                create: (_) => SettingsProvider(storage),
              ),
            ],
            child: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Practice Questions'), findsOneWidget);
      expect(find.text('Mock Exam'), findsOneWidget);
      expect(find.text('Wrong Answers'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Difficult Questions'), findsOneWidget);
      expect(find.text('Road Signs'), findsOneWidget);
      expect(find.text('Progress & Analytics'), findsOneWidget);
    });

    testWidgets('9. Mock Exam setup screen refers to 80% as Practice Benchmark, not official passing requirement', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              Provider<StorageService>.value(value: storage),
              Provider<QuestionRepository>(create: (_) => QuestionRepository()),
              ChangeNotifierProvider<SettingsProvider>(
                create: (_) => SettingsProvider(storage),
              ),
            ],
            child: const MockTestSetupScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('80% Benchmark'), findsOneWidget);
      expect(find.text('Practice Benchmark'), findsOneWidget);
      expect(find.text('Practice only'), findsOneWidget);
    });

    test('10. Default theme is light theme and user can switch to dark theme', () async {
      expect(storage.themeMode, equals('light'));
      final provider = SettingsProvider(storage);
      expect(provider.themeMode, equals(ThemeMode.light));

      await provider.setThemeMode(ThemeMode.dark);
      expect(provider.themeMode, equals(ThemeMode.dark));
      expect(storage.themeMode, equals('dark'));

      await provider.setThemeMode(ThemeMode.light);
      expect(provider.themeMode, equals(ThemeMode.light));
      expect(storage.themeMode, equals('light'));
    });
  });
}
