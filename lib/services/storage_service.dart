import 'package:shared_preferences/shared_preferences.dart';
import '../models/mock_test_result.dart';
import '../models/user_progress_model.dart';

class StorageService {
  static const String keyLanguageCode = 'app_language_code'; // 'en', 'fil'
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyVehicleType = 'vehicle_type'; // 'car', 'motorcycle', 'both'
  static const String keyThemeMode = 'theme_mode'; // 'system', 'light', 'dark'
  static const String keyDailyGoal = 'daily_goal'; // 10, 20, 30
  static const String keyDailyReminder = 'daily_reminder'; // true/false
  static const String keyFavorites = 'favorite_questions';
  static const String keyDifficult = 'difficult_questions';
  static const String keyWrongAnswers = 'wrong_answers';
  static const String keyMockTestHistory = 'mock_test_history';
  static const String keyPracticeProgress = 'lto_practice_progress';
  static const String keyFavoriteSigns = 'lto_favorite_signs';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Language Preference
  String get languageCode => _prefs.getString(keyLanguageCode) ?? 'en';

  Future<bool> setLanguageCode(String code) async {
    return await _prefs.setString(keyLanguageCode, code);
  }

  // Onboarding
  bool get isOnboardingCompleted =>
      _prefs.getBool(keyOnboardingCompleted) ?? false;

  Future<bool> setOnboardingCompleted(bool completed) async {
    return await _prefs.setBool(keyOnboardingCompleted, completed);
  }

  // Vehicle Preference
  String get vehicleType => _prefs.getString(keyVehicleType) ?? 'both';

  Future<bool> setVehicleType(String type) async {
    return await _prefs.setString(keyVehicleType, type);
  }

  // Theme Mode
  String get themeMode => _prefs.getString(keyThemeMode) ?? 'light';

  Future<bool> setThemeMode(String mode) async {
    return await _prefs.setString(keyThemeMode, mode);
  }

  // Daily Goal
  int get dailyGoal => _prefs.getInt(keyDailyGoal) ?? 20;

  Future<bool> setDailyGoal(int goal) async {
    return await _prefs.setInt(keyDailyGoal, goal);
  }

  // Daily Reminder
  bool get dailyReminder => _prefs.getBool(keyDailyReminder) ?? false;

  Future<bool> setDailyReminder(bool enabled) async {
    return await _prefs.setBool(keyDailyReminder, enabled);
  }

  // Favorites
  Set<String> getFavorites() {
    final list = _prefs.getStringList(keyFavorites) ?? [];
    return list.toSet();
  }

  bool isFavorite(String questionId) {
    return getFavorites().contains(questionId);
  }

  Future<bool> toggleFavorite(String questionId) async {
    final current = getFavorites();
    if (current.contains(questionId)) {
      current.remove(questionId);
    } else {
      current.add(questionId);
    }
    return await _prefs.setStringList(keyFavorites, current.toList());
  }

  Future<bool> removeFavorite(String questionId) async {
    final current = getFavorites();
    if (current.contains(questionId)) {
      current.remove(questionId);
      return await _prefs.setStringList(keyFavorites, current.toList());
    }
    return true;
  }

  // Road Sign Favorites (Isolated from Question Favorites)
  Set<String> getFavoriteSignIds() {
    final list = _prefs.getStringList(keyFavoriteSigns) ?? [];
    return list.toSet();
  }

  bool isFavoriteSign(String signId) {
    return getFavoriteSignIds().contains(signId);
  }

  Future<bool> toggleFavoriteSign(String signId) async {
    final current = getFavoriteSignIds();
    if (current.contains(signId)) {
      current.remove(signId);
    } else {
      current.add(signId);
    }
    return await _prefs.setStringList(keyFavoriteSigns, current.toList());
  }

  Future<bool> addFavoriteSign(String signId) async {
    final current = getFavoriteSignIds();
    if (!current.contains(signId)) {
      current.add(signId);
      return await _prefs.setStringList(keyFavoriteSigns, current.toList());
    }
    return true;
  }

  Future<bool> removeFavoriteSign(String signId) async {
    final current = getFavoriteSignIds();
    if (current.contains(signId)) {
      current.remove(signId);
      return await _prefs.setStringList(keyFavoriteSigns, current.toList());
    }
    return true;
  }

  // Difficult Questions
  Set<String> getDifficult() {
    final list = _prefs.getStringList(keyDifficult) ?? [];
    return list.toSet();
  }

  bool isDifficult(String questionId) {
    return getDifficult().contains(questionId);
  }

  Future<bool> toggleDifficult(String questionId) async {
    final current = getDifficult();
    if (current.contains(questionId)) {
      current.remove(questionId);
    } else {
      current.add(questionId);
    }
    return await _prefs.setStringList(keyDifficult, current.toList());
  }

  Future<bool> removeDifficult(String questionId) async {
    final current = getDifficult();
    if (current.contains(questionId)) {
      current.remove(questionId);
      return await _prefs.setStringList(keyDifficult, current.toList());
    }
    return true;
  }

  // Wrong Answers Bank
  Set<String> getWrongAnswerIds() {
    final list = _prefs.getStringList(keyWrongAnswers) ?? [];
    return list.toSet();
  }

  bool isWrongAnswer(String questionId) {
    return getWrongAnswerIds().contains(questionId);
  }

  Future<bool> addWrongAnswer(String questionId) async {
    final current = getWrongAnswerIds();
    if (!current.contains(questionId)) {
      current.add(questionId);
      return await _prefs.setStringList(keyWrongAnswers, current.toList());
    }
    return true;
  }

  Future<bool> removeWrongAnswer(String questionId) async {
    final current = getWrongAnswerIds();
    if (current.contains(questionId)) {
      current.remove(questionId);
      return await _prefs.setStringList(keyWrongAnswers, current.toList());
    }
    return true;
  }

  Future<bool> clearWrongAnswers() async {
    return await _prefs.remove(keyWrongAnswers);
  }

  // Mock Test History (Limited to latest 50 attempts)
  List<MockTestResult> getMockTestHistory() {
    final rawList = _prefs.getStringList(keyMockTestHistory) ?? [];
    final List<MockTestResult> results = [];
    for (final item in rawList) {
      try {
        results.add(MockTestResult.fromJson(item));
      } catch (_) {
        // Skip corrupted entries
      }
    }
    return results;
  }

  Future<bool> saveMockTestResult(MockTestResult result) async {
    final history = getMockTestHistory();
    history.insert(0, result);
    // Limit to latest 50 attempts
    final capped = history.take(50).toList();
    final jsonList = capped.map((r) => r.toJson()).toList();
    return await _prefs.setStringList(keyMockTestHistory, jsonList);
  }

  // Practice Progress Analytics
  UserProgressModel getPracticeProgress() {
    final raw = _prefs.getString(keyPracticeProgress);
    if (raw == null || raw.trim().isEmpty) {
      return UserProgressModel.empty();
    }
    try {
      final progress = UserProgressModel.fromJson(raw);
      return progress.updateStreakForDate(DateTime.now());
    } catch (_) {
      // Return clean empty model if corrupted
      return UserProgressModel.empty();
    }
  }

  Future<bool> savePracticeProgress(UserProgressModel progress) async {
    return await _prefs.setString(keyPracticeProgress, progress.toJson());
  }

  Future<bool> resetPracticeProgress() async {
    return await _prefs.remove(keyPracticeProgress);
  }

  /// Completely resets all local study data (practice progress, wrong answer bank,
  /// bookmarks/favorites, difficult questions, road sign bookmarks, and mock exam history)
  /// while strictly preserving user configuration (language, theme mode, vehicle preference,
  /// daily goal, daily reminder status, and onboarding completion status).
  Future<bool> resetAllStudyData() async {
    final r1 = await _prefs.remove(keyPracticeProgress);
    final r2 = await _prefs.remove(keyWrongAnswers);
    final r3 = await _prefs.remove(keyFavorites);
    final r4 = await _prefs.remove(keyDifficult);
    final r5 = await _prefs.remove(keyFavoriteSigns);
    final r6 = await _prefs.remove(keyMockTestHistory);
    return r1 && r2 && r3 && r4 && r5 && r6;
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
}
