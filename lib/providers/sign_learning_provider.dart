import 'package:flutter/foundation.dart';
import '../data/road_signs_data.dart';
import '../models/road_sign_model.dart';

class SignQuestion {
  final RoadSignModel sign;
  final List<String> options;
  final int correctAnswerIndex;

  const SignQuestion({
    required this.sign,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class SignLearningProvider extends ChangeNotifier {
  final List<RoadSignModel> _catalog;

  List<SignQuestion> _questions = [];
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  int _score = 0;
  bool _isSessionFinished = false;

  SignLearningProvider({List<RoadSignModel>? catalog})
      : _catalog = catalog ?? RoadSignsData.allSigns {
    startSession();
  }

  List<SignQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  int get score => _score;
  bool get isSessionFinished => _isSessionFinished;

  SignQuestion? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  bool get isAnswered => _selectedAnswerIndex != null;

  bool get isCorrect =>
      isAnswered &&
      currentQuestion != null &&
      _selectedAnswerIndex == currentQuestion!.correctAnswerIndex;

  double get accuracy =>
      totalQuestions > 0 ? (_score / totalQuestions) * 100 : 0.0;

  /// Starts a randomized 10-question sign quiz session.
  void startSession({int count = 10, String? category}) {
    _currentIndex = 0;
    _selectedAnswerIndex = null;
    _score = 0;
    _isSessionFinished = false;

    List<RoadSignModel> pool = category != null && category != 'All'
        ? _catalog.where((s) => s.category == category).toList()
        : List<RoadSignModel>.from(_catalog);

    if (pool.isEmpty) {
      pool = List<RoadSignModel>.from(_catalog);
    }

    if (pool.isEmpty) {
      _questions = [];
      notifyListeners();
      return;
    }

    pool.shuffle();
    final actualCount = pool.length < count ? pool.length : count;
    final sessionSigns = pool.take(actualCount).toList();

    _questions = sessionSigns.map((targetSign) {
      final distractors = _catalog
          .where((s) => s.id != targetSign.id && s.meaning != targetSign.meaning)
          .map((s) => s.meaning)
          .toSet()
          .toList();
      distractors.shuffle();

      final chosenDistractors = distractors.take(3).toList();
      while (chosenDistractors.length < 3) {
        chosenDistractors.add('Caution: Follow designated road regulation (${chosenDistractors.length + 1})');
      }

      final options = [targetSign.meaning, ...chosenDistractors];
      options.shuffle();
      final correctIndex = options.indexOf(targetSign.meaning);

      return SignQuestion(
        sign: targetSign,
        options: options,
        correctAnswerIndex: correctIndex,
      );
    }).toList();

    notifyListeners();
  }

  void selectAnswer(int index) {
    if (isAnswered || _isSessionFinished || currentQuestion == null) return;
    _selectedAnswerIndex = index;
    if (index == currentQuestion!.correctAnswerIndex) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      notifyListeners();
    } else {
      _isSessionFinished = true;
      notifyListeners();
    }
  }

  void restartSession() {
    startSession(count: _questions.length);
  }
}
