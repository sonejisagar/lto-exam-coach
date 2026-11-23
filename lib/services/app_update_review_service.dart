import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles Google Play In-App Update checks and In-App Review prompts.
///
/// **In-App Update**: On each app start, checks Play Store for a newer
/// version. If an update is available, shows a flexible update prompt.
///
/// **In-App Review**: Requests the official Google Play review dialog
/// after an "activity" (practice session, mock exam) is completed,
/// but ONLY on the user's 2nd app open after that activity. If the user
/// has already submitted a rating (or was shown the dialog), it won't
/// show again.
class AppUpdateReviewService {
  AppUpdateReviewService._();
  static final AppUpdateReviewService instance = AppUpdateReviewService._();

  static const String _keyAppOpenCount = 'app_open_count';
  static const String _keyHasCompletedActivity = 'has_completed_activity';
  static const String _keyHasBeenReviewed = 'has_been_reviewed';
  static const String _keyLastUpdateCheckMs = 'last_update_check_ms';

  // Only check for updates once every 4 hours to save bandwidth.
  static const int _updateCheckIntervalMs = 4 * 60 * 60 * 1000;

  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> init([SharedPreferences? prefs]) async {
    try {
      _prefs = prefs ?? await SharedPreferences.getInstance();
      _initialized = true;
    } catch (e) {
      debugPrint('[AppUpdateReviewService] Failed to init prefs: $e');
    }
  }

  // ────────────────────────────────────────────
  // APP OPEN TRACKING
  // ────────────────────────────────────────────

  /// Call once per app launch (from main.dart or app startup).
  Future<void> onAppOpened() async {
    try {
      if (!_initialized || _prefs == null) await init();
      final current = _prefs?.getInt(_keyAppOpenCount) ?? 0;
      await _prefs?.setInt(_keyAppOpenCount, current + 1);
    } catch (e) {
      debugPrint('[AppUpdateReviewService] onAppOpened error: $e');
    }
  }

  int get _appOpenCount => _prefs?.getInt(_keyAppOpenCount) ?? 0;

  // ────────────────────────────────────────────
  // IN-APP UPDATE
  // ────────────────────────────────────────────

  /// Checks Play Store for an available update and triggers a flexible
  /// update prompt if one is found.
  Future<void> checkForUpdate() async {
    if (kIsWeb) return;

    try {
      if (!_initialized || _prefs == null) await init();

      // Throttle update checks to avoid too-frequent network calls.
      final lastCheckMs = _prefs?.getInt(_keyLastUpdateCheckMs) ?? 0;
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      if (nowMs - lastCheckMs < _updateCheckIntervalMs) return;

      final updateInfo = await InAppUpdate.checkForUpdate();
      await _prefs?.setInt(_keyLastUpdateCheckMs, nowMs);

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // Start non-disruptive flexible update in background
        await InAppUpdate.startFlexibleUpdate();
      }
    } catch (e) {
      // In-app update isn't available on debug/non-Play builds — swallow.
      debugPrint('[AppUpdateReviewService] Update check skipped: $e');
    }
  }

  // ────────────────────────────────────────────
  // IN-APP REVIEW
  // ────────────────────────────────────────────

  /// Mark that the user has finished a study activity (practice session /
  /// mock exam). The review dialog will be triggered on the next app open.
  Future<void> markActivityCompleted() async {
    try {
      if (!_initialized || _prefs == null) await init();
      if (_hasBeenReviewed) return; // No need to track if already reviewed.
      await _prefs?.setBool(_keyHasCompletedActivity, true);
    } catch (e) {
      debugPrint('[AppUpdateReviewService] markActivityCompleted error: $e');
    }
  }

  bool get _hasCompletedActivity =>
      _prefs?.getBool(_keyHasCompletedActivity) ?? false;

  bool get _hasBeenReviewed =>
      _prefs?.getBool(_keyHasBeenReviewed) ?? false;

  /// Call on app startup (after [onAppOpened]).
  ///
  /// Shows the Play Store review sheet if ALL of:
  ///   1. User has completed at least one activity.
  ///   2. User has opened the app at least **twice** (i.e., they're back).
  ///   3. User has NOT already been shown / submitted the review dialog.
  Future<void> maybeRequestReview() async {
    try {
      if (kIsWeb) return;
      if (!_initialized || _prefs == null) await init();
      if (_hasBeenReviewed) return;
      if (!_hasCompletedActivity) return;
      if (_appOpenCount < 2) return;

      final inAppReview = InAppReview.instance;
      final isAvailable = await inAppReview.isAvailable();
      if (!isAvailable) return;

      await inAppReview.requestReview();
      // Mark as shown — don't annoy the user again.
      await _prefs?.setBool(_keyHasBeenReviewed, true);
      await _prefs?.setBool(_keyHasCompletedActivity, false);
    } catch (e) {
      debugPrint('[AppUpdateReviewService] Review request error (handled): $e');
    }
  }

  /// Returns true if the user has already been prompted for a review.
  bool get hasBeenReviewed => _hasBeenReviewed;
}
