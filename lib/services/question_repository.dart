import 'dart:math';
import '../data/questions_data.dart';
import '../models/question_model.dart';
import '../utils/constants.dart';

class QuestionRepository {
  final List<QuestionModel> _questions;

  QuestionRepository({List<QuestionModel>? questions})
      : _questions = questions ?? QuestionsData.allQuestions;

  /// Returns all available questions.
  List<QuestionModel> getAllQuestions() => List.unmodifiable(_questions);

  /// Returns total count of questions.
  int getQuestionCount() => _questions.length;

  /// Returns questions belonging to a specific category.
  List<QuestionModel> getQuestionsByCategory(String category) {
    return _questions.where((q) => q.category == category).toList();
  }

  /// Returns question count for a specific category.
  int getCategoryCount(String category, {String? vehicleType}) {
    if (vehicleType == null || vehicleType == AppVehicleTypes.both) {
      return _questions.where((q) => q.category == category).length;
    }
    return _questions
        .where((q) => q.category == category && q.appliesToVehicle(vehicleType))
        .length;
  }

  /// Returns questions filtered by user's vehicle preference ('car', 'motorcycle', 'both').
  List<QuestionModel> getQuestionsForVehicle(String vehicleType) {
    if (vehicleType == AppVehicleTypes.both) {
      return List.unmodifiable(_questions);
    }
    return _questions.where((q) => q.appliesToVehicle(vehicleType)).toList();
  }

  /// Returns a specific question by its unique ID, or null if not found.
  QuestionModel? getQuestionById(String id) {
    try {
      return _questions.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Returns a list of questions corresponding to the given IDs, ignoring invalid or missing IDs.
  List<QuestionModel> getQuestionsByIds(Iterable<String> ids) {
    final List<QuestionModel> result = [];
    for (final id in ids) {
      final q = getQuestionById(id);
      if (q != null) {
        result.add(q);
      }
    }
    return result;
  }

  /// Returns a randomized subset of questions with optional category & vehicle filters.
  List<QuestionModel> getRandomQuestions({
    int count = 20,
    String? category,
    String? vehicleType,
  }) {
    Iterable<QuestionModel> filtered = _questions;

    if (category != null && category.isNotEmpty) {
      filtered = filtered.where((q) => q.category == category);
    }

    if (vehicleType != null && vehicleType != AppVehicleTypes.both) {
      filtered = filtered.where((q) => q.appliesToVehicle(vehicleType));
    }

    final list = filtered.toList();
    list.shuffle(Random());

    if (list.length <= count) {
      return list;
    }
    return list.sublist(0, count);
  }

  /// Validates the entire dataset for consistency and adherence to requirements.
  List<String> validateDataset() {
    final List<String> errors = [];
    final Set<String> seenIds = {};
    final Set<String> seenQuestions = {};

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final validationError = q.validate();
      if (validationError != null) {
        errors.add('Question at index $i (${q.id}): $validationError');
      }

      if (seenIds.contains(q.id)) {
        errors.add('Duplicate question ID: ${q.id}');
      }
      seenIds.add(q.id);

      final normalizedQuestion = q.question.trim().toLowerCase();
      if (seenQuestions.contains(normalizedQuestion)) {
        errors.add('Duplicate question text: "${q.question}"');
      }
      seenQuestions.add(normalizedQuestion);
    }

    return errors;
  }
}
