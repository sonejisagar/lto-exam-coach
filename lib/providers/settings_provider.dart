import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;

  late bool _onboardingCompleted;
  late String _languageCode;
  late String _vehicleType;
  late ThemeMode _themeMode;
  late int _dailyGoal;
  late bool _dailyReminder;

  SettingsProvider(this._storageService) {
    _loadFromStorage();
  }

  void _loadFromStorage() {
    _onboardingCompleted = _storageService.isOnboardingCompleted;
    _languageCode = _storageService.languageCode;
    _vehicleType = _storageService.vehicleType;
    _dailyGoal = _storageService.dailyGoal;
    _dailyReminder = _storageService.dailyReminder;

    final themeStr = _storageService.themeMode;
    if (themeStr == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
  }

  StorageService get storageService => _storageService;
  bool get onboardingCompleted => _onboardingCompleted;
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  String get languageLabel => _languageCode == 'fil' ? 'Filipino' : 'English';
  String get vehicleType => _vehicleType;
  ThemeMode get themeMode => _themeMode;
  int get dailyGoal => _dailyGoal;
  bool get dailyReminder => _dailyReminder;

  Future<void> setLanguageCode(String code) async {
    if (code != 'en' && code != 'fil') return;
    _languageCode = code;
    notifyListeners();
    await _storageService.setLanguageCode(code);
  }

  String get vehicleTypeLabel {
    switch (_vehicleType) {
      case 'car':
        return 'Car';
      case 'motorcycle':
        return 'Motorcycle';
      case 'both':
      default:
        return 'Car & Motorcycle';
    }
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    notifyListeners();
    await _storageService.setOnboardingCompleted(true);
  }

  Future<void> setVehicleType(String type) async {
    _vehicleType = type;
    notifyListeners();
    await _storageService.setVehicleType(type);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final modeStr = mode == ThemeMode.dark ? 'dark' : 'light';
    await _storageService.setThemeMode(modeStr);
  }

  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
    notifyListeners();
    await _storageService.setDailyGoal(goal);
  }

  Future<void> setDailyReminder(bool enabled) async {
    _dailyReminder = enabled;
    notifyListeners();
    await _storageService.setDailyReminder(enabled);

    if (enabled) {
      await NotificationService().requestPermission();
      await NotificationService().scheduleDailyReminder();
    } else {
      await NotificationService().cancelDailyReminder();
    }
  }

  Future<void> resetPracticeProgress() async {
    await _storageService.resetPracticeProgress();
    notifyListeners();
  }

  Future<void> resetAllStudyData() async {
    await _storageService.resetAllStudyData();
    notifyListeners();
  }

  Future<void> resetAllData() async {
    await _storageService.clearAll();
    _loadFromStorage();
    notifyListeners();
  }
}
