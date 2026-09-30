import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';

/// Service managing AdMob lifecycle, banner configurations, background
/// interstitial preloading, session frequency capping, and UMP consent.
///
/// Designed to be completely non-blocking, failing silently and gracefully
/// when offline or when ad units fail to load.
class AdService {
  static final AdService instance = AdService._internal();

  AdService._internal();

  bool _isInitialized = false;
  bool _isTestEnvironment = false;
  bool _mockInterstitialReady = false;

  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
  DateTime? _lastInterstitialShownAt;

  bool get isInitialized => _isInitialized;
  bool get isTestEnvironment => _isTestEnvironment;
  bool get isInterstitialReady =>
      _isTestEnvironment ? _mockInterstitialReady : _interstitialAd != null;

  /// Visible for testing to configure stubbed test behavior.
  @visibleForTesting
  void setTestEnvironment({
    required bool isTest,
    bool mockInterstitialReady = false,
  }) {
    _isTestEnvironment = isTest;
    _mockInterstitialReady = mockInterstitialReady;
    _isInitialized = true;
    _lastInterstitialShownAt = null;
  }

  /// Initializes the Google Mobile Ads SDK and requests UMP consent in the background.
  /// Does NOT block app startup or UI rendering.
  Future<void> initialize({bool testMode = false}) async {
    if (_isInitialized) return;

    if (testMode) {
      _isTestEnvironment = true;
      _isInitialized = true;
      return;
    }

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Request UMP consent in the background
      _initConsentAndPreload();
    } catch (e) {
      debugPrint('[AdService] Initialization error (safe fallback): $e');
      // Even if init fails (e.g., offline or missing Play Services), mark initialized
      // so the app operates in clean ad-free fallback mode.
      _isInitialized = true;
    }
  }

  void _initConsentAndPreload() {
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          ConsentForm.loadAndShowConsentFormIfRequired(
            (formError) {
              if (formError != null) {
                debugPrint('[AdService] Consent form error: ${formError.message}');
              }
              // Preload interstitial after consent is addressed
              preloadInterstitial();
            },
          );
        },
        (formError) {
          debugPrint('[AdService] Consent info error: ${formError.message}');
          // If consent info request fails (e.g. offline), continue with preloading
          preloadInterstitial();
        },
      );
    } catch (e) {
      debugPrint('[AdService] Consent flow exception: $e');
      preloadInterstitial();
    }
  }

  /// Presents the Google UMP privacy options form if the user wishes to review
  /// or change their advertising choices from Settings.
  void showPrivacyOptionsForm({VoidCallback? onComplete}) {
    if (_isTestEnvironment) {
      onComplete?.call();
      return;
    }

    try {
      ConsentForm.showPrivacyOptionsForm((formError) {
        if (formError != null) {
          debugPrint('[AdService] Privacy options error: ${formError.message}');
        }
        onComplete?.call();
      });
    } catch (e) {
      debugPrint('[AdService] Privacy options exception: $e');
      onComplete?.call();
    }
  }

  /// Preloads the next interstitial ad in the background.
  void preloadInterstitial() {
    if (_isTestEnvironment || _isLoadingInterstitial || _interstitialAd != null) {
      return;
    }

    _isLoadingInterstitial = true;
    try {
      InterstitialAd.load(
        adUnitId: AdConfig.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoadingInterstitial = false;
            debugPrint('[AdService] Interstitial loaded successfully.');
          },
          onAdFailedToLoad: (error) {
            _interstitialAd = null;
            _isLoadingInterstitial = false;
            debugPrint('[AdService] Interstitial failed to load: ${error.message}');
          },
        ),
      );
    } catch (e) {
      _isLoadingInterstitial = false;
      debugPrint('[AdService] Interstitial load exception: $e');
    }
  }

  /// Verifies if an interstitial ad is permitted to display under session frequency rules:
  /// 1. An ad must already be loaded in memory.
  /// 2. Cooldown period must have elapsed since the last interstitial.
  bool canShowInterstitial() {
    if (!isInterstitialReady) return false;

    if (_lastInterstitialShownAt != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialShownAt!).inSeconds;
      if (elapsed < AdConfig.minSecondsBetweenInterstitials) {
        return false;
      }
    }

    return true;
  }

  /// Displays an interstitial ad ONLY if already cached and permitted by frequency guards.
  /// Calls [onComplete] immediately if the ad is not ready or fails, ensuring the user's
  /// workflow is never blocked or delayed.
  void showInterstitialIfReady({VoidCallback? onComplete}) {
    if (_isTestEnvironment) {
      if (canShowInterstitial()) {
        _lastInterstitialShownAt = DateTime.now();
        _mockInterstitialReady = false;
      }
      onComplete?.call();
      return;
    }

    if (!canShowInterstitial() || _interstitialAd == null) {
      onComplete?.call();
      return;
    }

    var hasCompleted = false;
    void safeComplete() {
      if (!hasCompleted) {
        hasCompleted = true;
        onComplete?.call();
      }
    }

    final ad = _interstitialAd!;
    _interstitialAd = null;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _lastInterstitialShownAt = DateTime.now();
        preloadInterstitial();
        safeComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] Interstitial failed to show: ${error.message}');
        ad.dispose();
        preloadInterstitial();
        safeComplete();
      },
    );

    try {
      ad.show();
    } catch (e) {
      debugPrint('[AdService] Interstitial show exception: $e');
      ad.dispose();
      preloadInterstitial();
      safeComplete();
    }
  }

  /// Disposes any loaded interstitial ad resources.
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
