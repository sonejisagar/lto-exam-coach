import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'providers/mock_test_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/settings_provider.dart';
import 'services/ad_service.dart';
import 'services/notification_service.dart';
import 'services/question_repository.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storageService = await StorageService.init();
  final questionRepository = QuestionRepository();
  final progressProvider = ProgressProvider(storageService);

  // Initialize notifications and sync reminder status
  final notificationService = NotificationService();
  await notificationService.init();
  if (storageService.dailyReminder) {
    unawaited(notificationService.scheduleDailyReminder());
  }

  // Initialize AdMob and consent in background without blocking app startup
  unawaited(AdService.instance.initialize());

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

