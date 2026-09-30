import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'mock_test_result.dart';

@immutable
class QuestionStat {
  final String questionId;
  final int attempts;
  final int correctAttempts;
  final int incorrectAttempts;
  final DateTime lastAttemptTimestamp;

  const QuestionStat({
    required this.questionId,
    required this.attempts,
    required this.correctAttempts,
    required this.incorrectAttempts,
    required this.lastAttemptTimestamp,
  });

  double get accuracy => attempts > 0 ? (correctAttempts / attempts) * 100 : 0.0;

  Map<String, dynamic> toMap() => {
        'questionId': questionId,
        'attempts': attempts,
        'correctAttempts': correctAttempts,
        'incorrectAttempts': incorrectAttempts,
        'lastAttemptTimestamp': lastAttemptTimestamp.toIso8601String(),
      };

  factory QuestionStat.fromMap(Map<String, dynamic> map) {
    return QuestionStat(
      questionId: map['questionId'] as String? ?? '',
      attempts: (map['attempts'] as num?)?.toInt() ?? 0,
      correctAttempts: (map['correctAttempts'] as num?)?.toInt() ?? 0,
      incorrectAttempts: (map['incorrectAttempts'] as num?)?.toInt() ?? 0,
      lastAttemptTimestamp: map['lastAttemptTimestamp'] != null
          ? DateTime.tryParse(map['lastAttemptTimestamp'] as String) ??
              DateTime.now()
          : DateTime.now(),
    );
  }
}

@immutable
class CategoryStat {
  final String category;
  final int attempted;
  final int correct;
  final int incorrect;

  const CategoryStat({
    required this.category,
    this.attempted = 0,
    this.correct = 0,
    this.incorrect = 0,
  });

  double get accuracy => attempted > 0 ? (correct / attempted) * 100 : 0.0;
  bool get isAttempted => attempted > 0;
  bool get needsMorePractice => attempted >= 3 && accuracy < 70.0;

  Map<String, dynamic> toMap() => {
        'category': category,
        'attempted': attempted,
        'correct': correct,
        'incorrect': incorrect,
      };

  factory CategoryStat.fromMap(Map<String, dynamic> map) {
    return CategoryStat(
      category: map['category'] as String? ?? '',
      attempted: (map['attempted'] as num?)?.toInt() ?? 0,
      correct: (map['correct'] as num?)?.toInt() ?? 0,
      incorrect: (map['incorrect'] as num?)?.toInt() ?? 0,
    );
  }
}

@immutable
class DifficultyStat {
  final String difficulty;
  final int attempted;
  final int correct;
  final int incorrect;

  const DifficultyStat({
    required this.difficulty,
    this.attempted = 0,
    this.correct = 0,
    this.incorrect = 0,
  });

  double get accuracy => attempted > 0 ? (correct / attempted) * 100 : 0.0;
  bool get isAttempted => attempted > 0;

  Map<String, dynamic> toMap() => {
        'difficulty': difficulty,
        'attempted': attempted,
        'correct': correct,
        'incorrect': incorrect,
      };

  factory DifficultyStat.fromMap(Map<String, dynamic> map) {
    return DifficultyStat(
      difficulty: map['difficulty'] as String? ?? '',
      attempted: (map['attempted'] as num?)?.toInt() ?? 0,
      correct: (map['correct'] as num?)?.toInt() ?? 0,
      incorrect: (map['incorrect'] as num?)?.toInt() ?? 0,
    );
  }
}

@immutable
class DailyPracticeRecord {
  final String date; // YYYY-MM-DD
  final int answered;
  final int correct;

  const DailyPracticeRecord({
    required this.date,
    this.answered = 0,
    this.correct = 0,
  });

  int get incorrect => answered - correct;
  double get accuracy => answered > 0 ? (correct / answered) * 100 : 0.0;

  Map<String, dynamic> toMap() => {
        'date': date,
        'answered': answered,
        'correct': correct,
      };

  factory DailyPracticeRecord.fromMap(Map<String, dynamic> map) {
    return DailyPracticeRecord(
      date: map['date'] as String? ?? '',
      answered: (map['answered'] as num?)?.toInt() ?? 0,
      correct: (map['correct'] as num?)?.toInt() ?? 0,
    );
  }
}

class MockTestAnalytics {
  final int totalTests;
  final double? bestPercentage;
  final double? latestPercentage;
  final double? averagePercentage;
  final List<MockTestResult> recentAttempts; // Newest first
  final List<MockTestResult> chronologicalAttempts; // Oldest first

  const MockTestAnalytics({
    required this.totalTests,
    required this.bestPercentage,
    required this.latestPercentage,
    required this.averagePercentage,
    required this.recentAttempts,
    required this.chronologicalAttempts,
  });

  bool get hasEnoughDataForTrend => chronologicalAttempts.length >= 2;

  factory MockTestAnalytics.fromResults(List<MockTestResult> history) {
    if (history.isEmpty) {
      return const MockTestAnalytics(
        totalTests: 0,
        bestPercentage: null,
        latestPercentage: null,
        averagePercentage: null,
        recentAttempts: [],
        chronologicalAttempts: [],
      );
    }

    final total = history.length;
    final latest = history.first.percentage;
    final best = history.map((r) => r.percentage).reduce(max);
    final avg = history.map((r) => r.percentage).reduce((a, b) => a + b) / total;
    final chronological = history.reversed.toList();

    return MockTestAnalytics(
      totalTests: total,
      bestPercentage: best,
      latestPercentage: latest,
      averagePercentage: avg,
      recentAttempts: history,
      chronologicalAttempts: chronological,
    );
  }
}

@immutable
class UserProgressModel {
  final int totalPracticeAnswered;
  final int totalPracticeCorrect;
  final int totalPracticeIncorrect;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastPracticeDate;
  final Map<String, QuestionStat> questionStats;
  final Map<String, CategoryStat> categoryStats;
  final Map<String, DifficultyStat> difficultyStats;
  final Map<String, DailyPracticeRecord> dailyRecords;

  const UserProgressModel({
    this.totalPracticeAnswered = 0,
    this.totalPracticeCorrect = 0,
    this.totalPracticeIncorrect = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPracticeDate,
    this.questionStats = const {},
    this.categoryStats = const {},
    this.difficultyStats = const {},
    this.dailyRecords = const {},
  });

  double get practiceAccuracy => totalPracticeAnswered > 0
      ? (totalPracticeCorrect / totalPracticeAnswered) * 100
      : 0.0;

  int get uniqueQuestionsAttempted => questionStats.length;
  int get categoriesAttempted =>
      categoryStats.values.where((c) => c.isAttempted).length;

  int get questionsPracticedToday {
    final todayKey = _dateToKey(DateTime.now());
    return dailyRecords[todayKey]?.answered ?? 0;
  }

  int get questionsPracticedThisWeek {
    final now = DateTime.now();
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final d = now.subtract(Duration(days: i));
      final key = _dateToKey(d);
      count += dailyRecords[key]?.answered ?? 0;
    }
    return count;
  }

  static String _dateToKey(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  factory UserProgressModel.empty() {
    return const UserProgressModel();
  }

  /// Evaluates whether the current streak is broken by calendar days elapsed.
  UserProgressModel updateStreakForDate(DateTime now) {
    if (lastPracticeDate == null || currentStreak == 0) return this;
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = DateTime(
      lastPracticeDate!.year,
      lastPracticeDate!.month,
      lastPracticeDate!.day,
    );
    final d1 = DateTime.utc(lastDate.year, lastDate.month, lastDate.day, 12);
    final d2 = DateTime.utc(today.year, today.month, today.day, 12);
    final daysDiff = d2.difference(d1).inDays;

    if (daysDiff > 1) {
      return copyWith(currentStreak: 0);
    }
    return this;
  }

  /// Records a single practice question attempt and returns a new immutable [UserProgressModel].
  UserProgressModel recordAttempt({
    required String questionId,
    required String category,
    required String difficulty,
    required bool isCorrect,
    DateTime? timestamp,
  }) {
    final time = timestamp ?? DateTime.now();
    final today = DateTime(time.year, time.month, time.day);

    // 1. Streak calculation
    int newCurrentStreak = currentStreak;
    int newLongestStreak = longestStreak;
    DateTime newLastDate = today;

    if (lastPracticeDate == null) {
      newCurrentStreak = 1;
      newLongestStreak = max(newLongestStreak, 1);
    } else {
      final lastDate = DateTime(
        lastPracticeDate!.year,
        lastPracticeDate!.month,
        lastPracticeDate!.day,
      );
      final d1 = DateTime.utc(lastDate.year, lastDate.month, lastDate.day, 12);
      final d2 = DateTime.utc(today.year, today.month, today.day, 12);
      final daysDiff = d2.difference(d1).inDays;

      if (daysDiff == 0) {
        // Same calendar day: streak does not increase
      } else if (daysDiff == 1) {
        // Consecutive calendar day: increment streak
        newCurrentStreak += 1;
        newLongestStreak = max(newLongestStreak, newCurrentStreak);
      } else if (daysDiff > 1) {
        // Missed at least one calendar day: reset streak to 1
        newCurrentStreak = 1;
        newLongestStreak = max(newLongestStreak, 1);
      }
      // If daysDiff < 0, leave streak untouched
    }

    // 2. Question-level stats
    final updatedQ = Map<String, QuestionStat>.from(questionStats);
    final existingQ = updatedQ[questionId];
    updatedQ[questionId] = QuestionStat(
      questionId: questionId,
      attempts: (existingQ?.attempts ?? 0) + 1,
      correctAttempts: (existingQ?.correctAttempts ?? 0) + (isCorrect ? 1 : 0),
      incorrectAttempts:
          (existingQ?.incorrectAttempts ?? 0) + (isCorrect ? 0 : 1),
      lastAttemptTimestamp: time,
    );

    // 3. Category stats
    final updatedCat = Map<String, CategoryStat>.from(categoryStats);
    final existingCat = updatedCat[category];
    updatedCat[category] = CategoryStat(
      category: category,
      attempted: (existingCat?.attempted ?? 0) + 1,
      correct: (existingCat?.correct ?? 0) + (isCorrect ? 1 : 0),
      incorrect: (existingCat?.incorrect ?? 0) + (isCorrect ? 0 : 1),
    );

    // 4. Difficulty stats
    final updatedDiff = Map<String, DifficultyStat>.from(difficultyStats);
    final existingDiff = updatedDiff[difficulty];
    updatedDiff[difficulty] = DifficultyStat(
      difficulty: difficulty,
      attempted: (existingDiff?.attempted ?? 0) + 1,
      correct: (existingDiff?.correct ?? 0) + (isCorrect ? 1 : 0),
      incorrect: (existingDiff?.incorrect ?? 0) + (isCorrect ? 0 : 1),
    );

    // 5. Daily records
    final dateKey = _dateToKey(time);
    final updatedDaily = Map<String, DailyPracticeRecord>.from(dailyRecords);
    final existingDaily = updatedDaily[dateKey];
    updatedDaily[dateKey] = DailyPracticeRecord(
      date: dateKey,
      answered: (existingDaily?.answered ?? 0) + 1,
      correct: (existingDaily?.correct ?? 0) + (isCorrect ? 1 : 0),
    );

    return UserProgressModel(
      totalPracticeAnswered: totalPracticeAnswered + 1,
      totalPracticeCorrect: totalPracticeCorrect + (isCorrect ? 1 : 0),
      totalPracticeIncorrect: totalPracticeIncorrect + (isCorrect ? 0 : 1),
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastPracticeDate: newLastDate,
      questionStats: updatedQ,
      categoryStats: updatedCat,
      difficultyStats: updatedDiff,
      dailyRecords: updatedDaily,
    );
  }

  UserProgressModel copyWith({
    int? totalPracticeAnswered,
    int? totalPracticeCorrect,
    int? totalPracticeIncorrect,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPracticeDate,
    Map<String, QuestionStat>? questionStats,
    Map<String, CategoryStat>? categoryStats,
    Map<String, DifficultyStat>? difficultyStats,
    Map<String, DailyPracticeRecord>? dailyRecords,
  }) {
    return UserProgressModel(
      totalPracticeAnswered:
          totalPracticeAnswered ?? this.totalPracticeAnswered,
      totalPracticeCorrect: totalPracticeCorrect ?? this.totalPracticeCorrect,
      totalPracticeIncorrect:
          totalPracticeIncorrect ?? this.totalPracticeIncorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      questionStats: questionStats ?? this.questionStats,
      categoryStats: categoryStats ?? this.categoryStats,
      difficultyStats: difficultyStats ?? this.difficultyStats,
      dailyRecords: dailyRecords ?? this.dailyRecords,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPracticeAnswered': totalPracticeAnswered,
      'totalPracticeCorrect': totalPracticeCorrect,
      'totalPracticeIncorrect': totalPracticeIncorrect,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastPracticeDate': lastPracticeDate?.toIso8601String(),
      'questionStats': questionStats.map((k, v) => MapEntry(k, v.toMap())),
      'categoryStats': categoryStats.map((k, v) => MapEntry(k, v.toMap())),
      'difficultyStats': difficultyStats.map((k, v) => MapEntry(k, v.toMap())),
      'dailyRecords': dailyRecords.map((k, v) => MapEntry(k, v.toMap())),
    };
  }

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    final rawQ = map['questionStats'] as Map<String, dynamic>? ?? {};
    final questionStats = rawQ.map(
      (k, v) => MapEntry(k, QuestionStat.fromMap(v as Map<String, dynamic>)),
    );

    final rawCat = map['categoryStats'] as Map<String, dynamic>? ?? {};
    final categoryStats = rawCat.map(
      (k, v) => MapEntry(k, CategoryStat.fromMap(v as Map<String, dynamic>)),
    );

    final rawDiff = map['difficultyStats'] as Map<String, dynamic>? ?? {};
    final difficultyStats = rawDiff.map(
      (k, v) => MapEntry(k, DifficultyStat.fromMap(v as Map<String, dynamic>)),
    );

    final rawDaily = map['dailyRecords'] as Map<String, dynamic>? ?? {};
    final dailyRecords = rawDaily.map(
      (k, v) =>
          MapEntry(k, DailyPracticeRecord.fromMap(v as Map<String, dynamic>)),
    );

    return UserProgressModel(
      totalPracticeAnswered:
          (map['totalPracticeAnswered'] as num?)?.toInt() ?? 0,
      totalPracticeCorrect: (map['totalPracticeCorrect'] as num?)?.toInt() ?? 0,
      totalPracticeIncorrect:
          (map['totalPracticeIncorrect'] as num?)?.toInt() ?? 0,
      currentStreak: (map['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (map['longestStreak'] as num?)?.toInt() ?? 0,
      lastPracticeDate: map['lastPracticeDate'] != null
          ? DateTime.tryParse(map['lastPracticeDate'] as String)
          : null,
      questionStats: questionStats,
      categoryStats: categoryStats,
      difficultyStats: difficultyStats,
      dailyRecords: dailyRecords,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProgressModel.fromJson(String source) {
    return UserProgressModel.fromMap(
        json.decode(source) as Map<String, dynamic>);
  }
}
