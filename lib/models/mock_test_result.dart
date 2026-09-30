import 'dart:convert';
import 'package:flutter/foundation.dart';

@immutable
class MockTestResult {
  final String id;
  final DateTime timestamp;
  final String vehicleType;
  final int questionCount;
  final int correctCount;
  final int incorrectCount;
  final int unansweredCount;
  final double percentage;
  final int timeUsedSeconds;
  final Map<String, double> categoryPerformance;
  final Map<String, int> userAnswers; // questionId -> selectedOptionIndex

  const MockTestResult({
    required this.id,
    required this.timestamp,
    required this.vehicleType,
    required this.questionCount,
    required this.correctCount,
    required this.incorrectCount,
    required this.unansweredCount,
    required this.percentage,
    required this.timeUsedSeconds,
    required this.categoryPerformance,
    this.userAnswers = const {},
  });

  bool get isPassed => percentage >= 80.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'vehicleType': vehicleType,
      'questionCount': questionCount,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'unansweredCount': unansweredCount,
      'percentage': percentage,
      'timeUsedSeconds': timeUsedSeconds,
      'categoryPerformance': categoryPerformance,
      'userAnswers': userAnswers,
    };
  }

  factory MockTestResult.fromMap(Map<String, dynamic> map) {
    final rawCat = map['categoryPerformance'] as Map<String, dynamic>? ?? {};
    final categoryPerformance = rawCat.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    final rawAnswers = map['userAnswers'] as Map<String, dynamic>? ?? {};
    final userAnswers = rawAnswers.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );

    return MockTestResult(
      id: map['id'] as String? ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : DateTime.now(),
      vehicleType: map['vehicleType'] as String? ?? 'both',
      questionCount: (map['questionCount'] as num?)?.toInt() ?? 0,
      correctCount: (map['correctCount'] as num?)?.toInt() ?? 0,
      incorrectCount: (map['incorrectCount'] as num?)?.toInt() ?? 0,
      unansweredCount: (map['unansweredCount'] as num?)?.toInt() ?? 0,
      percentage: (map['percentage'] as num?)?.toDouble() ?? 0.0,
      timeUsedSeconds: (map['timeUsedSeconds'] as num?)?.toInt() ?? 0,
      categoryPerformance: categoryPerformance,
      userAnswers: userAnswers,
    );
  }

  String toJson() => json.encode(toMap());

  factory MockTestResult.fromJson(String source) =>
      MockTestResult.fromMap(json.decode(source) as Map<String, dynamic>);
}
