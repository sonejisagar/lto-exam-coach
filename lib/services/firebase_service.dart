import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../config/ad_config.dart';

/// Central service managing Firebase Core initialization, Analytics,
/// and Remote Config for dynamic ad controls and parameters.
///
/// Designed to fail gracefully when offline or in test environments without
/// interrupting the user experience or crashing the app.
class FirebaseService {
  static final FirebaseService instance = FirebaseService._internal();

  FirebaseService._internal();

  bool _isInitialized = false;
  FirebaseAnalytics? _analytics;
  FirebaseRemoteConfig? _remoteConfig;

  // Cached remote config values with production-safe defaults
  bool _adsEnabled = true;
  int _interstitialCooldownSeconds = AdConfig.defaultMinSecondsBetweenInterstitials;
  String _bannerAdUnitId = '';
  String _interstitialAdUnitId = '';
  String _appOpenAdUnitId = '';

  bool get isInitialized => _isInitialized;
  FirebaseAnalytics? get analytics => _analytics;

  /// Whether ads are enabled remotely via Firebase Remote Config.
  /// Defaults to true; can be toggled to false instantly from Firebase Console.
  bool get adsEnabled => _adsEnabled;

  /// Cooldown between interstitial ads in seconds (default 180s / 3 mins).
  int get interstitialCooldownSeconds => _interstitialCooldownSeconds;

  /// Dynamically configured banner ad unit ID (falls back to AdConfig if empty).
  String get bannerAdUnitId => _bannerAdUnitId;

  /// Dynamically configured interstitial ad unit ID (falls back to AdConfig if empty).
  String get interstitialAdUnitId => _interstitialAdUnitId;

  /// Dynamically configured app open ad unit ID (falls back to AdConfig if empty).
  String get appOpenAdUnitId => _appOpenAdUnitId;

  /// Initializes Firebase Core, Analytics, and Remote Config.
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
      _remoteConfig = FirebaseRemoteConfig.instance;

      // Connect Crashlytics to catch all unhandled Flutter errors
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Connect Crashlytics to catch all unhandled async errors
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      // In debug mode, disable automatic collection to avoid polluting production crash logs
      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      } else {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }

      await _configureRemoteConfig();
      _isInitialized = true;
      debugPrint('[FirebaseService] Successfully initialized Firebase, Analytics, Crashlytics & Remote Config');
    } catch (e) {
      debugPrint('[FirebaseService] Firebase initialization skipped or failed (offline/fallback mode): $e');
      _isInitialized = false;
    }
  }

  Future<void> _configureRemoteConfig() async {
    final rc = _remoteConfig;
    if (rc == null) return;

    try {
      await rc.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );

      // Define default values (used when offline or before first fetch)
      await rc.setDefaults({
        'ads_enabled': true,
        'interstitial_cooldown_seconds': AdConfig.defaultMinSecondsBetweenInterstitials,
        'banner_ad_unit_id': AdConfig.prodAndroidBannerId,
        'interstitial_ad_unit_id': AdConfig.prodAndroidInterstitialId,
        'app_open_ad_unit_id': AdConfig.prodAndroidAppOpenId,
      });

      // Synchronize in-memory defaults immediately without waiting for network
      _syncRemoteValues();

      // Fetch and activate latest values asynchronously in background (zero startup block)
      unawaited(() async {
        try {
          await rc.fetchAndActivate();
          _syncRemoteValues();
        } catch (e) {
          debugPrint('[FirebaseService] Remote Config background fetch failed (using local defaults): $e');
        }
      }());

      // Listen for real-time config updates (supported on newer SDKs)
      rc.onConfigUpdated.listen(
        (event) async {
          await rc.activate();
          _syncRemoteValues();
          debugPrint('[FirebaseService] Remote Config updated in real-time');
        },
        onError: (err) {
          debugPrint('[FirebaseService] Remote Config update listener error: $err');
        },
      );
    } catch (e) {
      debugPrint('[FirebaseService] Remote Config fetch failed (using local defaults): $e');
      _syncRemoteValues();
    }
  }

  void _syncRemoteValues() {
    final rc = _remoteConfig;
    if (rc == null) return;

    _adsEnabled = rc.getBool('ads_enabled');
    _interstitialCooldownSeconds = rc.getInt('interstitial_cooldown_seconds');
    if (_interstitialCooldownSeconds < 30) {
      _interstitialCooldownSeconds = 30; // Safety clamp
    }

    final remoteBanner = rc.getString('banner_ad_unit_id');
    if (remoteBanner.isNotEmpty && remoteBanner.startsWith('ca-app-pub-')) {
      _bannerAdUnitId = remoteBanner;
    }

    final remoteInterstitial = rc.getString('interstitial_ad_unit_id');
    if (remoteInterstitial.isNotEmpty && remoteInterstitial.startsWith('ca-app-pub-')) {
      _interstitialAdUnitId = remoteInterstitial;
    }

    final remoteAppOpen = rc.getString('app_open_ad_unit_id');
    if (remoteAppOpen.isNotEmpty && remoteAppOpen.startsWith('ca-app-pub-')) {
      _appOpenAdUnitId = remoteAppOpen;
    }
  }

  /// Log a custom analytics event safely.
  Future<void> logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await _analytics?.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('[FirebaseService] logEvent error: $e');
    }
  }
}
