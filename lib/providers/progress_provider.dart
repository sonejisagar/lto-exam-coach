import 'package:flutter/foundation.dart';
import '../models/user_progress_model.dart';
import '../services/storage_service.dart';

class ProgressProvider extends ChangeNotifier {
  final StorageService storageService;

  late UserProgressModel _progress;

  ProgressProvider(this.storageService) {
    _loadProgress();
  }

  UserProgressModel get progress => _progress;

  void _loadProgress() {
    _progress = storageService.getPracticeProgress();
  }

  /// Reloads progress from storage and notifies listeners.
  void refreshProgress() {
    _loadProgress();
    notifyListeners();
  }

  /// Records a single practice question attempt, persists it, and notifies listeners.
  Future<void> recordPracticeAttempt({
    required String questionId,
    required String category,
    required String difficulty,
    required bool isCorrect,
    DateTime? timestamp,
  }) async {
    _progress = _progress.recordAttempt(
      questionId: questionId,
      category: category,
      difficulty: difficulty,
      isCorrect: isCorrect,
      timestamp: timestamp,
    );
    await storageService.savePracticeProgress(_progress);
    notifyListeners();
  }

  /// Resets practice progress, clears persistent record, and notifies listeners.
  Future<void> resetProgress() async {
    await storageService.resetPracticeProgress();
    _progress = UserProgressModel.empty();
    notifyListeners();
  }

  /// Helper to fetch mock test analytics calculated from local mock history.
  MockTestAnalytics getMockAnalytics() {
    final history = storageService.getMockTestHistory();
    return MockTestAnalytics.fromResults(history);
  }
}
