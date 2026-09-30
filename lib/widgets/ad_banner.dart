import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../services/ad_service.dart';

/// Reusable non-intrusive AdMob banner widget.
///
/// Features:
/// - Loads the standard banner ad asynchronously.
/// - Gracefully collapses to `SizedBox.shrink()` when offline, when loading fails,
///   or in automated test environments.
/// - Never leaves an ugly blank space or causes layout overflow.
/// - Clearly labeled with an "Ad" badge in accordance with Google AdMob policy.
class AdBannerWidget extends StatefulWidget {
  final EdgeInsetsGeometry margin;

  const AdBannerWidget({
    super.key,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  void _loadBanner() {
    // In widget tests or non-mobile platforms, collapse cleanly without platform calls
    if (kIsWeb || AdService.instance.isTestEnvironment) {
      return;
    }

    try {
      _bannerAd = BannerAd(
        adUnitId: AdConfig.bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _isLoaded = true;
              _hasFailed = false;
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('[AdBannerWidget] Banner failed to load: ${error.message}');
            ad.dispose();
            if (!mounted) return;
            setState(() {
              _bannerAd = null;
              _isLoaded = false;
              _hasFailed = true;
            });
          },
        ),
      );

      _bannerAd!.load();
    } catch (e) {
      debugPrint('[AdBannerWidget] Load exception: $e');
      if (mounted) {
        setState(() {
          _bannerAd = null;
          _hasFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If ad failed, is loading, or in test environment without a loaded ad, collapse cleanly
    if (_hasFailed || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: 'Advertisement banner',
      child: Container(
        margin: widget.margin,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtle "Ad" policy label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'Ad',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ],
        ),
      ),
    );
  }
}
