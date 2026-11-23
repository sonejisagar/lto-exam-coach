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

  AppOpenAd? _appOpenAd;
  bool _isLoadingAppOpenAd = false;
  bool _hasAttemptedColdStartAppOpen = false;
  bool _isShowingAppOpenAd = false;
  bool _coldStartTimedOutOrClosed = false;

  bool get isInitialized => _isInitialized;
  bool get isTestEnvironment => _isTestEnvironment;
  bool get isInterstitialReady =>
      _isTestEnvironment ? _mockInterstitialReady : _interstitialAd != null;
  bool get isAppOpenAdReady => _appOpenAd != null;
  bool get hasAttemptedColdStartAppOpen => _hasAttemptedColdStartAppOpen;

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
    _hasAttemptedColdStartAppOpen = true;
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

      // Preload cold-start App Open ad immediately so it's ready as early as possible
      preloadColdStartAppOpenAd();

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
    if (_isTestEnvironment || !AdConfig.areAdsEnabled || _isLoadingInterstitial || _interstitialAd != null) {
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
    if (!AdConfig.areAdsEnabled || !isInterstitialReady) return false;

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

  // ===========================================================================
  // COLD-START APP OPEN AD LOGIC
  // ===========================================================================

  /// Preloads the App Open ad for initial app launch.
  void preloadColdStartAppOpenAd() {
    if (_isTestEnvironment ||
        !AdConfig.areAdsEnabled ||
        _hasAttemptedColdStartAppOpen ||
        _isLoadingAppOpenAd ||
        _appOpenAd != null) {
      return;
    }

    _isLoadingAppOpenAd = true;
    try {
      AppOpenAd.load(
        adUnitId: AdConfig.appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoadingAppOpenAd = false;
            if (_coldStartTimedOutOrClosed) {
              debugPrint('[AdService] App Open ad loaded after timeout window; disposing.');
              ad.dispose();
              return;
            }
            _appOpenAd = ad;
            debugPrint('[AdService] Cold-start App Open ad loaded successfully.');
          },
          onAdFailedToLoad: (error) {
            _isLoadingAppOpenAd = false;
            _appOpenAd = null;
            debugPrint('[AdService] App Open ad failed to load: ${error.message} (code: ${error.code})');
          },
        ),
      );
    } catch (e) {
      _isLoadingAppOpenAd = false;
      debugPrint('[AdService] App Open load exception: $e');
    }
  }

  /// Shows the cold-start App Open ad strictly on initial launch.
  ///
  /// CRITICAL RULES:
  /// 1. ONLY runs once per app process launch (cold start).
  /// 2. NEVER triggers on warm start / app switch / recent apps drawer resume.
  /// 3. Times out safely after [timeoutMs] (default 2500ms) to ensure the user
  ///    never experiences a frozen or delayed startup if offline or no fill.
  Future<void> showColdStartAppOpenAd({
    int timeoutMs = 2500,
    VoidCallback? onComplete,
  }) async {
    // Permanent single-run guard: cold start only, never on resume
    if (_hasAttemptedColdStartAppOpen || _isShowingAppOpenAd || !AdConfig.areAdsEnabled) {
      _hasAttemptedColdStartAppOpen = true;
      onComplete?.call();
      return;
    }
    _hasAttemptedColdStartAppOpen = true;

    if (_isTestEnvironment) {
      onComplete?.call();
      return;
    }

    // Ensure ad preloading was kicked off
    if (_appOpenAd == null && !_isLoadingAppOpenAd) {
      preloadColdStartAppOpenAd();
    }

    // If ad is ready right now, display it immediately
    if (_appOpenAd != null) {
      _displayAppOpenAd(_appOpenAd!, onComplete);
      return;
    }

    // If still loading, wait up to timeoutMs (e.g. 2.5s)
    final startTime = DateTime.now();
    while (_isLoadingAppOpenAd && _appOpenAd == null) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (DateTime.now().difference(startTime).inMilliseconds >= timeoutMs) {
        _coldStartTimedOutOrClosed = true;
        debugPrint(
          '[AdService] Cold-start App Open ad timeout reached (${timeoutMs}ms). Proceeding smoothly.',
        );
        onComplete?.call();
        return;
      }
    }

    if (_appOpenAd != null && !_coldStartTimedOutOrClosed) {
      _displayAppOpenAd(_appOpenAd!, onComplete);
    } else {
      _coldStartTimedOutOrClosed = true;
      onComplete?.call();
    }
  }

  void _displayAppOpenAd(AppOpenAd ad, VoidCallback? onComplete) {
    _isShowingAppOpenAd = true;
    _appOpenAd = null;

    var hasCompleted = false;
    void safeComplete() {
      if (!hasCompleted) {
        hasCompleted = true;
        _isShowingAppOpenAd = false;
        _coldStartTimedOutOrClosed = true;
        onComplete?.call();
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('[AdService] App Open ad presented on screen.');
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('[AdService] App Open ad dismissed by user.');
        ad.dispose();
        safeComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] App Open ad failed to show: ${error.message}');
        ad.dispose();
        safeComplete();
      },
    );

    try {
      ad.show();
    } catch (e) {
      debugPrint('[AdService] Exception displaying App Open ad: $e');
      ad.dispose();
      safeComplete();
    }
  }

  /// Disposes any loaded interstitial and App Open ad resources.
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }
}
