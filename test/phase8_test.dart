import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/app/routes/app_routes.dart';
import 'package:lto_exam_coach/data/road_signs_data.dart';
import 'package:lto_exam_coach/providers/sign_learning_provider.dart';
import 'package:lto_exam_coach/screens/road_signs/road_sign_detail_screen.dart';
import 'package:lto_exam_coach/screens/road_signs/road_signs_screen.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:lto_exam_coach/widgets/road_sign_painters.dart';

void main() {
  late StorageService storageService;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    storageService = StorageService(prefs);
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: child,
      ),
    );
  }

  group('Group 1: Dataset Verification & Model Integrity', () {
    test('1. Exactly 45 road signs exist in RoadSignsData.allSigns', () {
      expect(RoadSignsData.allSigns.length, 45);
    });

    test('2. All sign IDs are unique and non-empty', () {
      final ids = RoadSignsData.allSigns.map((s) => s.id).toSet();
      expect(ids.length, 45);
      for (final sign in RoadSignsData.allSigns) {
        expect(sign.id.isNotEmpty, isTrue);
        expect(sign.id.contains(' '), isFalse,
            reason: 'ID should not have spaces');
      }
    });

    test('3. Signs fall into verified Philippine categories', () {
      const allowedCategories = {
        'Regulatory',
        'Warning',
        'Informative',
        'Guide',
        'Road Work',
      };
      for (final sign in RoadSignsData.allSigns) {
        expect(allowedCategories.contains(sign.category), isTrue,
            reason: '${sign.name} has invalid category ${sign.category}');
      }
      expect(RoadSignsData.getSignsByCategory('Regulatory').length, 15);
      expect(RoadSignsData.getSignsByCategory('Warning').length, 15);
      expect(RoadSignsData.getSignsByCategory('Informative').length, 7);
      expect(RoadSignsData.getSignsByCategory('Guide').length, 3);
      expect(RoadSignsData.getSignsByCategory('Road Work').length, 5);
    });

    test('4. No empty names, meanings, descriptions, or usages', () {
      for (final sign in RoadSignsData.allSigns) {
        expect(sign.name.trim().isNotEmpty, isTrue);
        expect(sign.meaning.trim().isNotEmpty, isTrue);
        expect(sign.description.trim().isNotEmpty, isTrue);
        expect(sign.usage.trim().isNotEmpty, isTrue);
      }
    });

    test('5. Authoritative Philippine source references are explicitly cited',
        () {
      for (final sign in RoadSignsData.allSigns) {
        expect(sign.sourceReference, isNotNull);
        expect(sign.sourceReference!.trim().isNotEmpty, isTrue);
        final ref = sign.sourceReference!;
        final hasValidSource = ref.contains('DPWH') ||
            ref.contains('RA 4136') ||
            ref.contains('BP 344') ||
            ref.contains('TRB');
        expect(hasValidSource, isTrue,
            reason: '${sign.name} has unverified source: $ref');
      }
    });

    test('6. Speed limit signs contain verified values and context', () {
      final speed60 = RoadSignsData.getSignById('reg_07');
      final speed80 = RoadSignsData.getSignById('reg_08');
      expect(speed60, isNotNull);
      expect(speed80, isNotNull);
      expect(speed60!.meaning, contains('60 kilometers per hour'));
      expect(speed80!.meaning, contains('80 kilometers per hour'));
      expect(speed60.sourceReference, contains('DPWH'));
      expect(speed80.sourceReference, contains('DPWH'));
    });

    test('7. Semantic labels are defined and non-empty for all 45 signs', () {
      for (final sign in RoadSignsData.allSigns) {
        expect(sign.semanticLabel.trim().isNotEmpty, isTrue);
        expect(sign.semanticLabel.length, greaterThan(3));
      }
    });
  });

  group('Group 2: Vector CustomPainter & RoadSignWidget Tests', () {
    testWidgets('8. RoadSignWidget renders without errors for all 45 signs',
        (tester) async {
      for (final sign in RoadSignsData.allSigns) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: RoadSignWidget(
                  signType: sign.signType,
                  size: 68,
                  semanticLabel: sign.semanticLabel,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(RoadSignWidget), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('9. RoadSignWidget scales cleanly to large and small sizes',
        (tester) async {
      final sign = RoadSignsData.allSigns.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                RoadSignWidget(
                  signType: sign.signType,
                  size: 36,
                  semanticLabel: sign.semanticLabel,
                ),
                RoadSignWidget(
                  signType: sign.signType,
                  size: 140,
                  semanticLabel: sign.semanticLabel,
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(RoadSignWidget), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('10. RoadSignWidget renders Semantics with correct label',
        (tester) async {
      final sign = RoadSignsData.getSignById('reg_01')!;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RoadSignWidget(
              signType: sign.signType,
              size: 68,
              semanticLabel: sign.semanticLabel,
            ),
          ),
        ),
      );
      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == sign.semanticLabel,
      );
      expect(semanticsFinder, findsOneWidget);
    });

    test('11. Painter shouldRepaint handles signType equality', () {
      final painter1 = RoadSignPainter(signType: 'stop');
      final painter2 = RoadSignPainter(signType: 'yield');
      final painter1Same = RoadSignPainter(signType: 'stop');

      expect(painter1.shouldRepaint(painter2), isTrue);
      expect(painter1.shouldRepaint(painter1Same), isFalse);
    });
  });

  group('Group 3: StorageService Sign Favorites Isolation Tests', () {
    test('12. Sign favorites starts empty', () {
      expect(storageService.getFavoriteSignIds(), isEmpty);
    });

    test('13. toggleFavoriteSign adds and removes sign ID', () async {
      await storageService.toggleFavoriteSign('reg_01');
      expect(storageService.isFavoriteSign('reg_01'), isTrue);
      expect(storageService.getFavoriteSignIds().contains('reg_01'), isTrue);

      await storageService.toggleFavoriteSign('reg_01');
      expect(storageService.isFavoriteSign('reg_01'), isFalse);
      expect(storageService.getFavoriteSignIds().contains('reg_01'), isFalse);
    });

    test('14. Sign favorites persistence uses lto_favorite_signs key',
        () async {
      await storageService.addFavoriteSign('warn_04');
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList('lto_favorite_signs');
      expect(storedList, isNotNull);
      expect(storedList, contains('warn_04'));
    });

    test('15. Sign favorites is strictly isolated from question favorites',
        () async {
      await storageService.addFavoriteSign('reg_01');
      await storageService.toggleFavorite('q_sample_1');

      expect(storageService.getFavoriteSignIds(), contains('reg_01'));
      expect(storageService.getFavoriteSignIds(), isNot(contains('q_sample_1')));

      expect(storageService.getFavorites(), contains('q_sample_1'));
      expect(storageService.getFavorites(), isNot(contains('reg_01')));
    });

    test('16. Sign favorites is isolated from difficult questions', () async {
      await storageService.addFavoriteSign('reg_02');
      await storageService.toggleDifficult('q_diff_1');

      expect(storageService.getFavoriteSignIds(), contains('reg_02'));
      expect(storageService.getFavoriteSignIds(), isNot(contains('q_diff_1')));

      expect(storageService.getDifficult(), contains('q_diff_1'));
      expect(storageService.getDifficult(), isNot(contains('reg_02')));
    });
  });

  group('Group 4: Search & Dynamic Category Filters Tests', () {
    test('17. Search by name is case-insensitive', () {
      final results = RoadSignsData.searchSigns('stop');
      expect(results.any((s) => s.id == 'reg_01'), isTrue);

      final resultsUpper = RoadSignsData.searchSigns('STOP');
      expect(resultsUpper.any((s) => s.id == 'reg_01'), isTrue);
    });

    test('18. Search by meaning finds relevant signs', () {
      final results = RoadSignsData.searchSigns('yield the right of way');
      expect(results.any((s) => s.id == 'reg_02'), isTrue);
    });

    test('19. Filtering by category returns expected subset', () {
      final regSigns = RoadSignsData.getSignsByCategory('Regulatory');
      expect(regSigns.length, 15);
      expect(regSigns.every((s) => s.category == 'Regulatory'), isTrue);

      final workSigns = RoadSignsData.getSignsByCategory('Road Work');
      expect(workSigns.length, 5);
      expect(workSigns.every((s) => s.category == 'Road Work'), isTrue);
    });

    test('20. allCategories dynamically returns dataset categories', () {
      final cats = RoadSignsData.allCategories;
      expect(cats, contains('Regulatory'));
      expect(cats, contains('Warning'));
      expect(cats, contains('Informative'));
      expect(cats, contains('Guide'));
      expect(cats, contains('Road Work'));
      expect(cats.length, 5);
    });

    test('21. Empty query returns all signs in search', () {
      expect(RoadSignsData.searchSigns('').length, 45);
      expect(RoadSignsData.searchSigns('   ').length, 45);
    });
  });

  group('Group 5: SignLearningProvider Quiz Mechanics Tests', () {
    test('22. Default session generates exactly 10 questions', () {
      final provider = SignLearningProvider();
      expect(provider.totalQuestions, 10);
      expect(provider.currentIndex, 0);
      expect(provider.score, 0);
      expect(provider.isSessionFinished, isFalse);
    });

    test('23. Each quiz question has 4 answer options with correct answer', () {
      final provider = SignLearningProvider();
      for (final q in provider.questions) {
        expect(q.options.length, 4);
        expect(q.options.contains(q.sign.meaning), isTrue);
        expect(q.correctAnswerIndex, q.options.indexOf(q.sign.meaning));
      }
    });

    test('24. Quiz avoids duplicate signs in session', () {
      final provider = SignLearningProvider();
      final seenIds = <String>{};
      for (final q in provider.questions) {
        expect(seenIds.contains(q.sign.id), isFalse,
            reason: 'Duplicate sign in quiz: ${q.sign.id}');
        seenIds.add(q.sign.id);
      }
    });

    test('25. Answering question updates score, state, and advances index', () {
      final provider = SignLearningProvider();
      final q0 = provider.currentQuestion!;
      expect(provider.isAnswered, isFalse);

      provider.selectAnswer(q0.correctAnswerIndex);
      expect(provider.isAnswered, isTrue);
      expect(provider.isCorrect, isTrue);
      expect(provider.score, 1);

      provider.nextQuestion();
      expect(provider.currentIndex, 1);
      expect(provider.isAnswered, isFalse);
    });

    test('26. Small pool handling does not crash with small sign subsets', () {
      final smallPool = RoadSignsData.getSignsByCategory('Road Work').take(3).toList();
      final provider = SignLearningProvider(
        catalog: smallPool,
      );
      provider.startSession(count: 10);
      expect(provider.totalQuestions, 3);
      for (final q in provider.questions) {
        expect(q.options.length, 4); // Distractor fallback fills up to 4 options
        expect(q.options.contains(q.sign.meaning), isTrue);
      }
    });
  });

  group('Group 6: UI & Navigation Integration Tests', () {
    testWidgets('27. RoadSignsScreen renders search, chips, and sign grid',
        (tester) async {
      await tester.pumpWidget(createTestWidget(const RoadSignsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Road Signs'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('All (45)'), findsOneWidget);
      expect(find.text('Regulatory (15)'), findsOneWidget);
      expect(find.text('Warning (15)'), findsOneWidget);
      expect(find.text('Learn Road Signs Mode'), findsOneWidget);
      expect(find.byType(RoadSignWidget), findsWidgets);
    });

    testWidgets('28. RoadSignDetailScreen renders sign info and favorite toggle',
        (tester) async {
      final sign = RoadSignsData.getSignById('reg_01')!;
      await tester.pumpWidget(
        createTestWidget(RoadSignDetailScreen(sign: sign)),
      );
      await tester.pumpAndSettle();

      expect(find.text(sign.name), findsWidgets);
      expect(find.text(sign.meaning), findsOneWidget);
      expect(find.text(sign.usage), findsOneWidget);
      expect(find.text(sign.sourceReference!), findsOneWidget);

      // Favorite toggle button exists (star outline)
      final starIcon = find.byIcon(Icons.star_outline_rounded);
      expect(starIcon, findsOneWidget);

      await tester.tap(starIcon);
      await tester.pumpAndSettle();

      expect(storageService.isFavoriteSign(sign.id), isTrue);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });
  });
}
