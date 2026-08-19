import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../di/injection_container.dart';
import '../../style/app_dimens.dart';
import '../ad_ids.dart';
import '../ads_service.dart';

enum BannerAdVariant { adaptive, mediumRectangle }

class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({
    super.key,
    required this.adUnitId,
    required this.variant,
  });

  final String adUnitId;
  final BannerAdVariant variant;

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;
  bool _loadFailed = false;
  double? _lastAdaptiveWidth;
  int _loadGeneration = 0;

  @override
  void dispose() {
    _loadGeneration++;
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _load(double availableWidth) async {
    if (!_canStartLoad) return;
    _isLoading = true;
    final loadGeneration = ++_loadGeneration;
    final adsService = getIt<AdsService>();
    await adsService.initialize();
    if (!_isCurrent(loadGeneration)) return;
    if (!adsService.canRequestAds) {
      _isLoading = false;
      return;
    }

    final adSize = await _adSize(availableWidth);
    if (!_isCurrent(loadGeneration)) return;
    if (adSize == null) {
      _isLoading = false;
      return;
    }
    await _loadBanner(adSize, loadGeneration);
  }

  bool get _canStartLoad =>
      _bannerAd == null && !_isLoading && !_loadFailed && AdIds.canServeAds;

  Future<void> _loadBanner(AdSize adSize, int loadGeneration) async {
    final banner = BannerAd(
      adUnitId: widget.adUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => _markLoaded(ad, loadGeneration),
        onAdFailedToLoad: (ad, _) => _markFailed(ad, loadGeneration),
      ),
    );
    _bannerAd = banner;
    try {
      await banner.load();
    } on PlatformException {
      banner.dispose();
      if (_isCurrent(loadGeneration)) {
        _bannerAd = null;
        _loadFailed = true;
      }
    } finally {
      if (_isCurrent(loadGeneration)) _isLoading = false;
    }
  }

  void _markLoaded(Ad ad, int loadGeneration) {
    if (!_isCurrent(loadGeneration)) {
      ad.dispose();
      return;
    }
    setState(() => _isLoaded = true);
  }

  void _markFailed(Ad ad, int loadGeneration) {
    ad.dispose();
    if (!_isCurrent(loadGeneration)) return;
    setState(() {
      _bannerAd = null;
      _loadFailed = true;
    });
  }

  bool _isCurrent(int loadGeneration) =>
      mounted && loadGeneration == _loadGeneration;

  Future<AdSize?> _adSize(double availableWidth) {
    if (widget.variant == BannerAdVariant.mediumRectangle) {
      return Future<AdSize?>.value(AdSize.mediumRectangle);
    }
    _lastAdaptiveWidth = availableWidth;
    return AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      availableWidth.truncate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (widget.variant == BannerAdVariant.adaptive &&
            _lastAdaptiveWidth != null &&
            (_lastAdaptiveWidth! - width).abs() >= 1) {
          _loadGeneration++;
          _bannerAd?.dispose();
          _bannerAd = null;
          _isLoaded = false;
          _isLoading = false;
          _loadFailed = false;
        }
        if (_bannerAd == null) _load(width);

        final banner = _bannerAd;
        final child = !_isLoaded || banner == null
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: SizedBox(
                    width: banner.size.width.toDouble(),
                    height: banner.size.height.toDouble(),
                    child: AdWidget(ad: banner),
                  ),
                ),
              );
        return AnimatedSize(
          duration: AppMotion.lineCommit,
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}
