import 'package:flutter_test/flutter_test.dart';
import 'package:lto_exam_coach/data/questions_data.dart';
import 'package:lto_exam_coach/services/question_repository.dart';
import 'package:lto_exam_coach/utils/constants.dart';

void main() {
  late QuestionRepository repo;

  setUp(() {
    repo = QuestionRepository();
  });

  group('Phase 5 — Question Bank Quality & Integrity Tests', () {
    test('Dataset contains exactly 150 questions', () {
      expect(QuestionsData.allQuestions.length, 150);
      expect(repo.getQuestionCount(), 150);
    });

    test('All questions have unique IDs and unique question text', () {
      final seenIds = <String>{};
      final seenTexts = <String>{};

      for (final q in QuestionsData.allQuestions) {
        expect(seenIds.add(q.id), isTrue, reason: 'Duplicate ID: ${q.id}');
        final normalizedText = q.question.trim().toLowerCase();
        expect(seenTexts.add(normalizedText), isTrue,
            reason: 'Duplicate question text: "${q.question}"');
      }
    });

    test('All questions have valid options, answers, and explanations', () {
      for (final q in QuestionsData.allQuestions) {
        expect(q.options.length, 4,
            reason: 'Question ${q.id} does not have exactly 4 options');
        expect(q.correctAnswerIndex >= 0 && q.correctAnswerIndex <= 3, isTrue,
            reason: 'Question ${q.id} has invalid correctAnswerIndex');
        expect(q.question.trim().isNotEmpty, isTrue,
            reason: 'Question ${q.id} has empty question text');
        expect(q.explanation.trim().isNotEmpty, isTrue,
            reason: 'Question ${q.id} has empty explanation');
        for (int i = 0; i < q.options.length; i++) {
          expect(q.options[i].trim().isNotEmpty, isTrue,
              reason: 'Question ${q.id} has empty option at index $i');
        }
      }
    });

    test('QuestionRepository.validateDataset() returns zero errors', () {
      final errors = repo.validateDataset();
      expect(errors, isEmpty, reason: errors.join('\n'));
    });

    test('Category distribution matches exact target counts (total 150)', () {
      final categoryCounts = <String, int>{};
      for (final q in QuestionsData.allQuestions) {
        categoryCounts[q.category] = (categoryCounts[q.category] ?? 0) + 1;
      }

      expect(categoryCounts[AppCategories.trafficRules], 25);
      expect(categoryCounts[AppCategories.roadSigns], 20);
      expect(categoryCounts[AppCategories.roadMarkings], 15);
      expect(categoryCounts[AppCategories.rightOfWay], 15);
      expect(categoryCounts[AppCategories.overtaking], 10);
      expect(categoryCounts[AppCategories.parking], 10);
      expect(categoryCounts[AppCategories.turning], 10);
      expect(categoryCounts[AppCategories.defensiveDriving], 15);
      expect(categoryCounts[AppCategories.vehicleBasics], 10);
      expect(categoryCounts[AppCategories.safety], 15);
      expect(categoryCounts[AppCategories.expresswayRules], 5);

      final sum = categoryCounts.values.reduce((a, b) => a + b);
      expect(sum, 150);
    });

    test('Difficulty distribution aligns with target (~35% Easy, ~50% Medium, ~15% Hard)', () {
      final diffCounts = <String, int>{};
      for (final q in QuestionsData.allQuestions) {
        diffCounts[q.difficulty] = (diffCounts[q.difficulty] ?? 0) + 1;
      }

      expect(diffCounts[AppDifficulty.easy], 52); // ~34.7%
      expect(diffCounts[AppDifficulty.medium], 75); // 50.0%
      expect(diffCounts[AppDifficulty.hard], 23); // ~15.3%
    });

    test('Vehicle type pools exceed minimum required thresholds (>30 questions)', () {
      final carPool = repo.getQuestionsForVehicle(AppVehicleTypes.car);
      final motoPool = repo.getQuestionsForVehicle(AppVehicleTypes.motorcycle);
      final bothPool = repo.getQuestionsForVehicle(AppVehicleTypes.both);

      expect(carPool.length >= 30, isTrue,
          reason: 'Car pool too small: ${carPool.length}');
      expect(motoPool.length >= 30, isTrue,
          reason: 'Motorcycle pool too small: ${motoPool.length}');
      expect(bothPool.length, 150);

      // Verify specific vehicle applicability
      for (final q in carPool) {
        expect(q.appliesToVehicle(AppVehicleTypes.car), isTrue);
      }
      for (final q in motoPool) {
        expect(q.appliesToVehicle(AppVehicleTypes.motorcycle), isTrue);
      }
    });

    test('Random mock test sampling returns expected count of unique questions', () {
      // 20-question mock test
      final sample20Both = repo.getRandomQuestions(
        count: 20,
        vehicleType: AppVehicleTypes.both,
      );
      expect(sample20Both.length, 20);
      expect(sample20Both.map((q) => q.id).toSet().length, 20);

      final sample20Car = repo.getRandomQuestions(
        count: 20,
        vehicleType: AppVehicleTypes.car,
      );
      expect(sample20Car.length, 20);
      expect(sample20Car.map((q) => q.id).toSet().length, 20);

      final sample20Moto = repo.getRandomQuestions(
        count: 20,
        vehicleType: AppVehicleTypes.motorcycle,
      );
      expect(sample20Moto.length, 20);
      expect(sample20Moto.map((q) => q.id).toSet().length, 20);

      // 30-question mock test
      final sample30Both = repo.getRandomQuestions(
        count: 30,
        vehicleType: AppVehicleTypes.both,
      );
      expect(sample30Both.length, 30);
      expect(sample30Both.map((q) => q.id).toSet().length, 30);

      final sample30Car = repo.getRandomQuestions(
        count: 30,
        vehicleType: AppVehicleTypes.car,
      );
      expect(sample30Car.length, 30);
      expect(sample30Car.map((q) => q.id).toSet().length, 30);

      final sample30Moto = repo.getRandomQuestions(
        count: 30,
        vehicleType: AppVehicleTypes.motorcycle,
      );
      expect(sample30Moto.length, 30);
      expect(sample30Moto.map((q) => q.id).toSet().length, 30);
    });

    test('Every question can be retrieved by its ID', () {
      for (final q in QuestionsData.allQuestions) {
        final retrieved = repo.getQuestionById(q.id);
        expect(retrieved, isNotNull, reason: 'Failed to retrieve ${q.id}');
        expect(retrieved!.id, q.id);
        expect(retrieved.question, q.question);
      }
    });

    test('Initial 30 questions subset is preserved for backward compatibility', () {
      expect(QuestionsData.initial30Questions.length, 30);
      final allQuestionIds =
          QuestionsData.allQuestions.map((q) => q.id).toSet();
      for (final q in QuestionsData.initial30Questions) {
        expect(allQuestionIds.contains(q.id), isTrue);
      }
    });
  });
}
