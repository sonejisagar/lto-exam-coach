import 'package:flutter/foundation.dart';
import '../models/question_model.dart';
import '../services/question_repository.dart';
import '../services/storage_service.dart';
import 'progress_provider.dart';

class QuizProvider extends ChangeNotifier {
  final QuestionRepository questionRepository;
  final StorageService storageService;
  ProgressProvider progressProvider;

  List<QuestionModel> _sessionQuestions = [];
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {}; // questionIndex -> selectedOptionIndex
  bool _isCompleted = false;
  String? _currentCategory;
  String? _currentVehicleType;

  QuizProvider({
    required this.questionRepository,
    required this.storageService,
    ProgressProvider? progressProvider,
  }) : progressProvider = progressProvider ?? ProgressProvider(storageService);

  // Getters
  List<QuestionModel> get sessionQuestions => _sessionQuestions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _sessionQuestions.length;
  bool get isCompleted => _isCompleted;
  String? get currentCategory => _currentCategory;
  String? get currentVehicleType => _currentVehicleType;

  QuestionModel? get currentQuestion {
    if (_sessionQuestions.isEmpty || _currentIndex >= _sessionQuestions.length) {
      return null;
    }
    return _sessionQuestions[_currentIndex];
  }

  int? get selectedAnswerIndex => _userAnswers[_currentIndex];

  bool get isAnswered => _userAnswers.containsKey(_currentIndex);

  bool get isCorrect {
    if (!isAnswered || currentQuestion == null) return false;
    return selectedAnswerIndex == currentQuestion!.correctAnswerIndex;
  }

  int get score {
    int count = 0;
    for (int i = 0; i < _sessionQuestions.length; i++) {
      if (_userAnswers[i] == _sessionQuestions[i].correctAnswerIndex) {
        count++;
      }
    }
    return count;
  }

  double get accuracy {
    if (_sessionQuestions.isEmpty) return 0.0;
    return (score / _sessionQuestions.length) * 100;
  }

  // Favorite & Difficult State for current question
  bool get isCurrentFavorite {
    final q = currentQuestion;
    if (q == null) return false;
    return storageService.isFavorite(q.id);
  }

  Future<void> toggleCurrentFavorite() async {
    final q = currentQuestion;
    if (q == null) return;
    await storageService.toggleFavorite(q.id);
    notifyListeners();
  }

  bool get isCurrentDifficult {
    final q = currentQuestion;
    if (q == null) return false;
    return storageService.isDifficult(q.id);
  }

  Future<void> toggleCurrentDifficult() async {
    final q = currentQuestion;
    if (q == null) return;
    await storageService.toggleDifficult(q.id);
    notifyListeners();
  }

  // Wrong Answers State for current question
  bool get isCurrentWrongAnswer {
    final q = currentQuestion;
    if (q == null) return false;
    return storageService.isWrongAnswer(q.id);
  }

  Future<void> removeCurrentFromWrongAnswers() async {
    final q = currentQuestion;
    if (q == null) return;
    await storageService.removeWrongAnswer(q.id);
    notifyListeners();
  }

  /// Starts a new practice session with specified category or random selection.
  void startPractice({
    String? category,
    String? vehicleType,
    int? count,
  }) {
    _currentCategory = category;
    _currentVehicleType = vehicleType;
    _currentIndex = 0;
    _userAnswers.clear();
    _isCompleted = false;

    if (category != null && category.isNotEmpty) {
      final list = questionRepository.getQuestionsByCategory(category);
      if (vehicleType != null && vehicleType.isNotEmpty) {
        _sessionQuestions =
            list.where((q) => q.appliesToVehicle(vehicleType)).toList();
      } else {
        _sessionQuestions = list;
      }
    } else {
      _sessionQuestions = questionRepository.getRandomQuestions(
        count: count ?? 20,
        vehicleType: vehicleType,
      );
    }

    notifyListeners();
  }

  /// Starts a targeted practice session with a provided list of questions.
  void startTargetedPractice({
    required List<QuestionModel> questions,
    String? title,
    bool shuffle = true,
  }) {
    _currentCategory = title ?? 'Targeted Practice';
    _currentVehicleType = null;
    _currentIndex = 0;
    _userAnswers.clear();
    _isCompleted = false;

    final list = List<QuestionModel>.from(questions);
    if (shuffle && list.length > 1) {
      list.shuffle();
    }
    _sessionQuestions = list;

    notifyListeners();
  }

  /// Selects an option for the current question (cannot be modified after selection).
  void selectAnswer(int optionIndex) {
    if (isAnswered || _isCompleted || currentQuestion == null) return;
    _userAnswers[_currentIndex] = optionIndex;

    final question = currentQuestion!;
    final bool correct = optionIndex == question.correctAnswerIndex;

    if (!correct) {
      storageService.addWrongAnswer(question.id);
    }

    // Record attempt in ProgressProvider (single source of truth)
    progressProvider.recordPracticeAttempt(
      questionId: question.id,
      category: question.category,
      difficulty: question.difficulty,
      isCorrect: correct,
    );

    notifyListeners();
  }

  /// Navigates to the next question or finishes the practice session.
  void nextQuestion() {
    if (_currentIndex < _sessionQuestions.length - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      _isCompleted = true;
      notifyListeners();
    }
  }

  /// Navigates to the previous question (for review).
  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  /// Restarts the current practice session with the same questions.
  void restartPractice() {
    _currentIndex = 0;
    _userAnswers.clear();
    _isCompleted = false;
    notifyListeners();
  }

  /// Resets and clears the active session.
  void reset() {
    _sessionQuestions = [];
    _currentIndex = 0;
    _userAnswers.clear();
    _isCompleted = false;
    _currentCategory = null;
    _currentVehicleType = null;
    notifyListeners();
  }
}
