import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lto_exam_coach/services/storage_service.dart';
import 'package:lto_exam_coach/services/notification_service.dart';
import 'package:lto_exam_coach/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 13: Data Management & Reset Study Data Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        StorageService.keyLanguageCode: 'fil',
        StorageService.keyThemeMode: 'dark',
        StorageService.keyVehicleType: 'motorcycle',
        StorageService.keyDailyGoal: 30,
        StorageService.keyDailyReminder: true,
        StorageService.keyOnboardingCompleted: true,
        StorageService.keyFavorites: ['tr_001', 'rs_002'],
        StorageService.keyDifficult: ['ov_001'],
        StorageService.keyWrongAnswers: ['rm_001', 'tu_002'],
        StorageService.keyFavoriteSigns: ['reg_01', 'warn_02'],
        StorageService.keyMockTestHistory: ['{}'],
        StorageService.keyPracticeProgress: '{"totalAttempts": 15}',
      });

      storageService = await StorageService.init();
    });

    test('resetAllStudyData wipes study progress while protecting user preferences', () async {
      // Pre-condition check
      expect(storageService.getFavorites().length, 2);
      expect(storageService.getDifficult().length, 1);
      expect(storageService.getWrongAnswerIds().length, 2);
      expect(storageService.getFavoriteSignIds().length, 2);
      expect(storageService.getMockTestHistory().length, 1);
      expect(storageService.languageCode, 'fil');
      expect(storageService.themeMode, 'dark');
      expect(storageService.vehicleType, 'motorcycle');
      expect(storageService.dailyGoal, 30);
      expect(storageService.dailyReminder, true);
      expect(storageService.isOnboardingCompleted, true);

      // Perform reset
      final result = await storageService.resetAllStudyData();
      expect(result, isTrue);

      // Verify study data is completely wiped
      expect(storageService.getFavorites(), isEmpty);
      expect(storageService.getDifficult(), isEmpty);
      expect(storageService.getWrongAnswerIds(), isEmpty);
      expect(storageService.getFavoriteSignIds(), isEmpty);
      expect(storageService.getMockTestHistory(), isEmpty);

      // Verify user preferences are strictly preserved
      expect(storageService.languageCode, 'fil');
      expect(storageService.themeMode, 'dark');
      expect(storageService.vehicleType, 'motorcycle');
      expect(storageService.dailyGoal, 30);
      expect(storageService.dailyReminder, true);
      expect(storageService.isOnboardingCompleted, true);
    });

    test('SettingsProvider.resetAllStudyData updates listeners cleanly', () async {
      final settingsProvider = SettingsProvider(storageService);
      var notified = false;
      settingsProvider.addListener(() {
        notified = true;
      });

      await settingsProvider.resetAllStudyData();
      expect(notified, isTrue);
      expect(storageService.getFavorites(), isEmpty);
      expect(settingsProvider.languageCode, 'fil');
      expect(settingsProvider.vehicleType, 'motorcycle');
    });
  });

  group('Phase 13: Notification Service Integrity Tests', () {
    test('NotificationService singleton contract and channel constants', () {
      final service1 = NotificationService();
      final service2 = NotificationService();
      expect(identical(service1, service2), isTrue);

      expect(NotificationService.dailyReminderNotificationId, 1001);
      expect(NotificationService.channelId, 'lto_daily_study_channel');
      expect(NotificationService.channelName, 'Daily Study Reminder');
    });
  });
}
