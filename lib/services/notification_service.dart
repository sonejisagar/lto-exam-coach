import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int dailyReminderNotificationId = 1001;
  static const String channelId = 'lto_daily_study_channel';
  static const String channelName = 'Daily Study Reminder';
  static const String channelDescription =
      'Daily notifications to remind you to review LTO exam questions.';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initializes timezone data, notification channels, and platform settings.
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
    } catch (e) {
      debugPrint('NotificationService: Failed to initialize timezones: $e');
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(settings: initSettings);

      // Create high-visibility Android notification channel
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        const channel = AndroidNotificationChannel(
          channelId,
          channelName,
          description: channelDescription,
          importance: Importance.defaultImportance,
        );
        await androidImplementation.createNotificationChannel(channel);
      }
      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService: Initialization error: $e');
    }
  }

  /// Requests notification permissions on Android 13+ (API level 33+).
  Future<bool> requestPermission() async {
    try {
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    } catch (e) {
      debugPrint('NotificationService: requestPermission error: $e');
      return false;
    }
  }

  /// Calculates the next occurrence of the requested hour and minute.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Schedules an inexact daily reminder at 7:00 PM (19:00).
  ///
  /// Uses [AndroidScheduleMode.inexact] to comply strictly with Google Play
  /// exact alarm restrictions and optimize battery consumption.
  Future<void> scheduleDailyReminder({int hour = 19, int minute = 0}) async {
    if (!_isInitialized) {
      await init();
    }

    try {
      // Cancel previous schedule before setting a fresh recurring reminder
      await cancelDailyReminder();

      const androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      final scheduledDate = _nextInstanceOfTime(hour, minute);

      await _notificationsPlugin.zonedSchedule(
        id: dailyReminderNotificationId,
        title: 'Time to Practice! 🚗',
        body: 'Keep your study streak going with a quick 5-minute review for your LTO exam.',
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexact,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: Scheduled daily reminder for $scheduledDate');
    } catch (e) {
      debugPrint('NotificationService: Failed to schedule daily reminder: $e');
    }
  }

  /// Cancels the scheduled daily reminder.
  Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(id: dailyReminderNotificationId);
      debugPrint('NotificationService: Cancelled daily reminder');
    } catch (e) {
      debugPrint('NotificationService: Failed to cancel daily reminder: $e');
    }
  }

  /// Synchronizes scheduled state with user preference.
  Future<void> syncReminderPreference(bool isEnabled) async {
    if (isEnabled) {
      await scheduleDailyReminder();
    } else {
      await cancelDailyReminder();
    }
  }
}
