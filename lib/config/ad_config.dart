import 'dart:io';
import '../services/firebase_service.dart';

/// Centralized configuration for Google AdMob monetization, ad units,
/// test-mode toggles, and privacy policy endpoints.
class AdConfig {
  /// Toggle test mode. When true, official Google test ad unit IDs are used.
  /// Set to false only for production release builds with verified AdMob credentials.
  static bool isTestMode = false;

  /// Whether ads are enabled globally. Can be toggled remotely via Firebase Remote Config.
  static bool get areAdsEnabled => FirebaseService.instance.adsEnabled;

  // ===========================================================================
  // GOOGLE OFFICIAL TEST AD UNIT IDs
  // https://developers.google.com/admob/android/test-ads
  // ===========================================================================
  static const String testAndroidBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testAndroidInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testAndroidAppOpenId = 'ca-app-pub-3940256099942544/9257395921';
  static const String testIosBannerId = 'ca-app-pub-3940256099942544/2934735716';
  static const String testIosInterstitialId = 'ca-app-pub-3940256099942544/4411468910';
  static const String testIosAppOpenId = 'ca-app-pub-3940256099942544/5575463023';

  // ===========================================================================
  // PRODUCTION AD UNIT IDs (Insert approved production IDs before Play Store release)
  // ===========================================================================
  static const String prodAndroidBannerId = 'ca-app-pub-4523328156597896/2961512669';
  static const String prodAndroidInterstitialId = 'ca-app-pub-4523328156597896/4939229738';
  static const String prodAndroidAppOpenId = 'ca-app-pub-4523328156597896/7213325272';
  static const String prodIosBannerId = '';
  static const String prodIosInterstitialId = '';
  static const String prodIosAppOpenId = '';

  /// Active banner ad unit ID based on current platform and test mode.
  static String get bannerAdUnitId {
    if (isTestMode) {
      if (Platform.isIOS) {
        return testIosBannerId;
      }
      return testAndroidBannerId;
    }

    final remoteId = FirebaseService.instance.bannerAdUnitId;
    if (remoteId.isNotEmpty) {
      return remoteId;
    }

    if (Platform.isIOS) {
      return prodIosBannerId.isNotEmpty ? prodIosBannerId : testIosBannerId;
    }
    return prodAndroidBannerId.isNotEmpty ? prodAndroidBannerId : testAndroidBannerId;
  }

  /// Active interstitial ad unit ID based on current platform and test mode.
  static String get interstitialAdUnitId {
    if (isTestMode) {
      if (Platform.isIOS) {
        return testIosInterstitialId;
      }
      return testAndroidInterstitialId;
    }

    final remoteId = FirebaseService.instance.interstitialAdUnitId;
    if (remoteId.isNotEmpty) {
      return remoteId;
    }

    if (Platform.isIOS) {
      return prodIosInterstitialId.isNotEmpty ? prodIosInterstitialId : testIosInterstitialId;
    }
    return prodAndroidInterstitialId.isNotEmpty
        ? prodAndroidInterstitialId
        : testAndroidInterstitialId;
  }

  /// Active App Open ad unit ID based on current platform and test mode.
  static String get appOpenAdUnitId {
    if (isTestMode) {
      if (Platform.isIOS) {
        return testIosAppOpenId;
      }
      return testAndroidAppOpenId;
    }

    final remoteId = FirebaseService.instance.appOpenAdUnitId;
    if (remoteId.isNotEmpty) {
      return remoteId;
    }

    if (Platform.isIOS) {
      return prodIosAppOpenId.isNotEmpty ? prodIosAppOpenId : testIosAppOpenId;
    }
    return prodAndroidAppOpenId.isNotEmpty
        ? prodAndroidAppOpenId
        : testAndroidAppOpenId;
  }

  // ===========================================================================
  // INTERSTITIAL FREQUENCY & COOLDOWN GUARDS
  // ===========================================================================
  /// Default minimum cooldown seconds between two interstitial displays.
  static const int defaultMinSecondsBetweenInterstitials = 180; // 3 minutes

  /// Minimum cooldown seconds between two interstitial displays (overridable via Firebase Remote Config).
  static int get minSecondsBetweenInterstitials {
    final remoteCooldown = FirebaseService.instance.interstitialCooldownSeconds;
    return remoteCooldown > 0 ? remoteCooldown : defaultMinSecondsBetweenInterstitials;
  }

  /// Maximum interstitials allowed per completed study/exam session.
  static const int maxInterstitialsPerSession = 1;

  // ===========================================================================
  // PRIVACY POLICY CONFIGURATION
  // ===========================================================================
  /// Centralized production HTTPS Privacy Policy URL.
  ///
  /// REQUIRED PRODUCTION CONFIGURATION VALUE:
  /// Before submitting to Google Play Console, deploy `docs/privacy_policy.html`
  /// or `docs/index.html` to a public HTTPS host (e.g. GitHub Pages, Cloudflare
  /// Pages, Firebase Hosting) and set the resulting live URL here:
  /// `static const String? privacyPolicyUrl = 'https://<your-domain>/privacy_policy.html';`
  ///
  /// IMPORTANT:
  /// - Must be a valid HTTPS URL with a valid SSL certificate.
  /// - Must match the exact URL entered into Google Play Console.
  /// - Kept null until published by the developer. Do NOT enter a fake URL.
  static const String privacyPolicyUrl =
      'https://sonejisagar.github.io/lto-exam-coach/';

  // ===========================================================================
  // PRODUCTION READINESS & VALIDATION
  // ===========================================================================
  /// Indicates whether valid non-empty production IDs are populated.
  static bool get hasValidProductionIds =>
      prodAndroidBannerId.isNotEmpty &&
      prodAndroidInterstitialId.isNotEmpty &&
      prodAndroidAppOpenId.isNotEmpty;

  /// Audits the monetization configuration.
  /// Returns a list of pending items required before store publication.
  static List<String> validateProductionConfig() {
    final pending = <String>[];
    if (prodAndroidBannerId.isEmpty) {
      pending.add('Production Android Banner Unit ID (prodAndroidBannerId)');
    }
    if (prodAndroidInterstitialId.isEmpty) {
      pending.add('Production Android Interstitial Unit ID (prodAndroidInterstitialId)');
    }
    if (prodAndroidAppOpenId.isEmpty) {
      pending.add('Production Android App Open Unit ID (prodAndroidAppOpenId)');
    }
    if (privacyPolicyUrl.isEmpty) {
      pending.add('Publicly hosted Privacy Policy URL (privacyPolicyUrl)');
    }
    return pending;
  }
}
