import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'providers/mock_test_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/settings_provider.dart';
import 'services/ad_service.dart';
import 'services/app_update_review_service.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'services/question_repository.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first (with 3s timeout safeguard) so Crashlytics hooks
  // are attached before downstream initialization without ever stalling launch.
  try {
    await FirebaseService.instance.init().timeout(const Duration(seconds: 3));
  } catch (e) {
    debugPrint('[AppStartup] Firebase init timed out or skipped: $e');
  }

  final storageService = await StorageService.init();
  final questionRepository = QuestionRepository();
  final progressProvider = ProgressProvider(storageService);

  // Initialize notifications in background without blocking the first UI frame
  unawaited(() async {
    try {
      final notificationService = NotificationService();
      await notificationService.init();
      if (storageService.dailyReminder) {
        await notificationService.scheduleDailyReminder();
      }
    } catch (e) {
      debugPrint('[AppStartup] Notification init skipped: $e');
    }
  }());

  // Initialize AdMob and consent in background without blocking app startup
  unawaited(AdService.instance.initialize());

  // Track app open count and check for Play Store updates / request review safely
  unawaited(() async {
    try {
      await AppUpdateReviewService.instance.init(storageService.prefs);
      await AppUpdateReviewService.instance.onAppOpened();
      unawaited(AppUpdateReviewService.instance.checkForUpdate());
      unawaited(AppUpdateReviewService.instance.maybeRequestReview());
    } catch (e) {
      debugPrint('[AppStartup] Non-critical background task error: $e');
    }
  }());

  runApp(
    MultiProvider(
      providers: [
        Provider<AdService>.value(
          value: AdService.instance,
        ),
        Provider<StorageService>.value(
          value: storageService,
        ),
        Provider<QuestionRepository>.value(
          value: questionRepository,
        ),
        ChangeNotifierProvider<ProgressProvider>.value(
          value: progressProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(
            questionRepository: questionRepository,
            storageService: storageService,
            progressProvider: progressProvider,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MockTestProvider(
            storageService: storageService,
          ),
        ),
      ],
      child: const LtoExamCoachApp(),
    ),
  );
}
