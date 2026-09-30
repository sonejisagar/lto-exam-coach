import 'package:flutter_test/flutter_test.dart';
import 'package:lto_exam_coach/data/questions_data.dart';
import 'package:lto_exam_coach/data/road_signs_data.dart';
import 'package:lto_exam_coach/data/questions_filipino.dart';

void main() {
  test('Audit question count and breakdown', () {
    final questions = QuestionsData.allQuestions;
    expect(questions.length, 150);

    final categoryCounts = <String, int>{};
    for (final q in questions) {
      categoryCounts[q.category] = (categoryCounts[q.category] ?? 0) + 1;
      expect(q.options.length, 4, reason: 'Question ${q.id} must have 4 options');
      expect(q.correctAnswerIndex >= 0 && q.correctAnswerIndex < 4, isTrue,
          reason: 'Question ${q.id} has invalid correctAnswerIndex');
      expect(q.question.isNotEmpty, isTrue);
      expect(q.explanation.isNotEmpty, isTrue);
      expect(q.sourceReference != null && q.sourceReference!.isNotEmpty, isTrue);
    }

    // Validate all 11 categories have questions
    expect(categoryCounts.length, 11);

    final signs = RoadSignsData.allSigns;
    expect(signs.length, 45);
    final signCategories = <String, int>{};
    for (final s in signs) {
      signCategories[s.category] = (signCategories[s.category] ?? 0) + 1;
    }
    expect(signCategories.length, 5);
    expect(QuestionsFilipinoData.translations.length, greaterThanOrEqualTo(16));
    for (final entry in QuestionsFilipinoData.translations.entries) {
      final qId = entry.key;
      final filContent = entry.value;
      final canonical = questions.firstWhere((q) => q.id == qId);
      expect(canonical, isNotNull, reason: 'Translation $qId does not exist in canonical questions');
      expect(filContent.options.length, 4, reason: '$qId must have 4 options');
      expect(filContent.question.trim().isNotEmpty, isTrue);
      expect(filContent.explanation.trim().isNotEmpty, isTrue);
      expect(filContent.options[canonical.correctAnswerIndex].trim().isNotEmpty, isTrue);
    }
  });
}
