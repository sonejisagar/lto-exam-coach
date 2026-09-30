import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/mock_test_result.dart';
import '../models/question_model.dart';
import '../services/storage_service.dart';

class MockTestProvider extends ChangeNotifier {
  final StorageService storageService;

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionIndex
  int _totalSeconds = 1200; // default 20 minutes
  int _remainingSeconds = 1200;
  Timer? _timer;
  bool _isSubmitted = false;
  String _vehicleType = 'both';
  MockTestResult? _result;

  // Callback hook for UI when auto-submission triggers
  VoidCallback? onAutoSubmit;

  MockTestProvider({required this.storageService});

  // Getters
  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  bool get isSubmitted => _isSubmitted;
  String get vehicleType => _vehicleType;
  MockTestResult? get result => _result;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;

  QuestionModel? get currentQuestion {
    if (_questions.isEmpty || _currentIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentIndex];
  }

  int? get currentSelectedAnswer => _selectedAnswers[_currentIndex];

  bool isQuestionAnswered(int index) => _selectedAnswers.containsKey(index);

  int? getAnswerForQuestion(int index) => _selectedAnswers[index];

  int get answeredCount => _selectedAnswers.length;

  int get unansweredCount =>
      _questions.isEmpty ? 0 : _questions.length - _selectedAnswers.length;

  int get timeUsedSeconds => _totalSeconds - _remainingSeconds;

  bool get isLowTime => _remainingSeconds <= 120 && _remainingSeconds > 0;

  String get formattedRemainingTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTimeUsed {
    final used = timeUsedSeconds;
    final minutes = used ~/ 60;
    final seconds = used % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Starts a new mock test with provided questions and optional custom duration in seconds.
  void startMockTest({
    required List<QuestionModel> questions,
    required String vehicleType,
    int? durationSeconds,
  }) {
    _cancelTimer();
    _questions = List.unmodifiable(questions);
    _vehicleType = vehicleType;
    _currentIndex = 0;
    _selectedAnswers.clear();
    _isSubmitted = false;
    _result = null;

    // Default duration: 1 minute per question (e.g. 20 Qs = 1200s, 30 Qs = 1800s)
    _totalSeconds = durationSeconds ?? (_questions.length * 60);
    _remainingSeconds = _totalSeconds;

    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _cancelTimer();
        submitTest();
        onAutoSubmit?.call();
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Select or change answer for the current question (user can freely change before submitting).
  void selectAnswer(int optionIndex) {
    if (_isSubmitted || _questions.isEmpty) return;
    if (optionIndex < 0 || optionIndex > 3) return;
    _selectedAnswers[_currentIndex] = optionIndex;
    notifyListeners();
  }

  /// Navigate directly to a specific question index.
  void navigateToQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  /// Move to next question if available.
  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  /// Move to previous question if available.
  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// Submits the mock exam, stops timer, evaluates results, and saves to storage.
  Future<MockTestResult?> submitTest() async {
    if (_isSubmitted || _questions.isEmpty) return _result;

    _cancelTimer();
    _isSubmitted = true;

    int correct = 0;
    int incorrect = 0;
    final Map<String, int> catTotal = {};
    final Map<String, int> catCorrect = {};
    final Map<String, int> userAnswersMap = {};

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      catTotal[q.category] = (catTotal[q.category] ?? 0) + 1;

      final selected = _selectedAnswers[i];
      if (selected != null) {
        userAnswersMap[q.id] = selected;
        if (selected == q.correctAnswerIndex) {
          correct++;
          catCorrect[q.category] = (catCorrect[q.category] ?? 0) + 1;
        } else {
          incorrect++;
        }
      }
    }

    final double percentage =
        _questions.isEmpty ? 0.0 : ((correct / _questions.length) * 100);

    final Map<String, double> categoryPerformance = {};
    catTotal.forEach((cat, total) {
      final c = catCorrect[cat] ?? 0;
      categoryPerformance[cat] = total > 0 ? (c / total) * 100 : 0.0;
    });

    final testResult = MockTestResult(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      timestamp: DateTime.now(),
      vehicleType: _vehicleType,
      questionCount: _questions.length,
      correctCount: correct,
      incorrectCount: incorrect,
      unansweredCount: unansweredCount,
      percentage: double.parse(percentage.toStringAsFixed(1)),
      timeUsedSeconds: timeUsedSeconds,
      categoryPerformance: categoryPerformance,
      userAnswers: userAnswersMap,
    );

    _result = testResult;
    await storageService.saveMockTestResult(testResult);

    notifyListeners();
    return testResult;
  }

  /// Cancels and resets the active exam.
  void cancelExam() {
    _cancelTimer();
    _questions = [];
    _selectedAnswers.clear();
    _currentIndex = 0;
    _isSubmitted = false;
    _result = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
