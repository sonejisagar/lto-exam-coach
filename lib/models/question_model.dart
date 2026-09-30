import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

@immutable
class QuestionModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String category;
  final String difficulty;
  final List<String> vehicleTypes;
  final String? signType;
  final String? sourceReference;

  const QuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
    required this.vehicleTypes,
    this.signType,
    this.sourceReference,
  }) : assert(correctAnswerIndex >= 0 && correctAnswerIndex <= 3,
            'correctAnswerIndex must be between 0 and 3');

  /// Validation method returning a descriptive error string or null if valid.
  String? validate() {
    if (id.trim().isEmpty) return 'Question ID is required';
    if (question.trim().isEmpty) return 'Question text cannot be empty';
    if (options.length != 4) return 'Question must have exactly 4 options';
    for (int i = 0; i < options.length; i++) {
      if (options[i].trim().isEmpty) return 'Option $i cannot be empty';
    }
    if (correctAnswerIndex < 0 || correctAnswerIndex > 3) {
      return 'Correct answer index must be between 0 and 3';
    }
    if (explanation.trim().isEmpty) return 'Explanation cannot be empty';
    if (!AppCategories.allCategories.contains(category)) {
      return 'Invalid category: $category';
    }
    if (!AppDifficulty.allDifficulties.contains(difficulty)) {
      return 'Invalid difficulty: $difficulty';
    }
    if (vehicleTypes.isEmpty) return 'At least one vehicle type is required';
    for (final v in vehicleTypes) {
      if (!AppVehicleTypes.allTypes.contains(v)) {
        return 'Invalid vehicle type: $v';
      }
    }
    return null;
  }

  bool appliesToVehicle(String targetVehicle) {
    if (targetVehicle == AppVehicleTypes.both) return true;
    return vehicleTypes.contains(AppVehicleTypes.both) ||
        vehicleTypes.contains(targetVehicle);
  }

  String get correctAnswerText => options[correctAnswerIndex];

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      explanation: json['explanation'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      vehicleTypes: List<String>.from(json['vehicleTypes'] as List),
      signType: json['signType'] as String?,
      sourceReference: json['sourceReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'vehicleTypes': vehicleTypes,
      if (signType != null) 'signType': signType,
      if (sourceReference != null) 'sourceReference': sourceReference,
    };
  }

  QuestionModel copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? explanation,
    String? category,
    String? difficulty,
    List<String>? vehicleTypes,
    String? signType,
    String? sourceReference,
  }) {
    return QuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      vehicleTypes: vehicleTypes ?? this.vehicleTypes,
      signType: signType ?? this.signType,
      sourceReference: sourceReference ?? this.sourceReference,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'QuestionModel(id: $id, category: $category)';
}
