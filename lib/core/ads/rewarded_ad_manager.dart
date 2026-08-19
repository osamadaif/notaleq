import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../errors/failures.dart';
import 'ad_ids.dart';
import 'ads_service.dart';

abstract interface class RewardedAdManager {
  bool get isReady;

  Future<void> preload();

  Future<Either<Failures, Unit>> showForExport();
}

class AdMobRewardedAdManager implements RewardedAdManager {
  AdMobRewardedAdManager(this._adsService);

  static const List<Duration> _retryDelays = [
    Duration.zero,
    Duration(seconds: 1),
    Duration(seconds: 2),
  ];
  static const Duration _loadAttemptTimeout = Duration(seconds: 5);

  final AdsService _adsService;
  RewardedAd? _rewardedAd;
  Future<void>? _preloadOperation;
  bool _isShowing = false;
  int _loadGeneration = 0;

  @override
  bool get isReady => _rewardedAd != null;

  @override
  Future<void> preload() async {
    if (_rewardedAd != null) return;
    final activePreload = _preloadOperation;
    if (activePreload != null) return activePreload;

    final preloadOperation = _preloadWithRetry();
    _preloadOperation = preloadOperation;
    await preloadOperation;
    if (identical(_preloadOperation, preloadOperation)) {
      _preloadOperation = null;
    }
  }

  Future<void> _preloadWithRetry() async {
    await _adsService.initialize();
    if (!_adsService.isReady ||
        !_adsService.canRequestAds ||
        !AdIds.canServeAds) {
      return;
    }

    for (var attempt = 0; attempt < _retryDelays.length; attempt++) {
      if (attempt > 0) await Future<void>.delayed(_retryDelays[attempt]);
      if (await _loadOnce()) return;
    }
  }

  Future<bool> _loadOnce() async {
    final loadGeneration = ++_loadGeneration;
    final loadCompleted = Completer<void>();
    var loaded = false;

    void completeLoad() {
      if (loadGeneration != _loadGeneration || loadCompleted.isCompleted) {
        return;
      }
      loadCompleted.complete();
    }

    final loadRequest = RewardedAd.load(
      adUnitId: AdIds.exportRewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          if (loadGeneration != _loadGeneration) {
            ad.dispose();
            return;
          }
          _rewardedAd = ad;
          loaded = true;
          completeLoad();
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: ${error.message}');
          completeLoad();
        },
      ),
    );
    try {
      await Future.wait<void>([
        loadRequest,
        loadCompleted.future,
      ]).timeout(_loadAttemptTimeout);
      return loaded;
    } on TimeoutException {
      if (loadGeneration == _loadGeneration) _loadGeneration++;
      return false;
    } on PlatformException catch (error) {
      debugPrint('Rewarded ad load call failed: ${error.message}');
      if (loadGeneration == _loadGeneration) _loadGeneration++;
      return false;
    }
  }

  @override
  Future<Either<Failures, Unit>> showForExport() async {
    if (_isShowing) {
      return const Left(AdLoadFailure('ad_failed'));
    }
    await preload();
    final ad = _rewardedAd;
    if (ad == null) {
      return const Left(AdLoadFailure('ad_failed'));
    }

    _rewardedAd = null;
    _isShowing = true;
    return _show(ad);
  }

  Future<Either<Failures, Unit>> _show(RewardedAd ad) async {
    final completion = Completer<Either<Failures, Unit>>();
    var earnedReward = false;
    var cleanedUp = false;

    void finish(Either<Failures, Unit> outcome) {
      if (!completion.isCompleted) completion.complete(outcome);
    }

    void disposeAndPreload() {
      if (cleanedUp) return;
      cleanedUp = true;
      ad.dispose();
      _isShowing = false;
      unawaited(preload());
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) {},
      onAdFailedToShowFullScreenContent: (_, error) {
        debugPrint('Rewarded ad failed to show: ${error.message}');
        finish(const Left(AdLoadFailure('ad_failed')));
        disposeAndPreload();
      },
      onAdDismissedFullScreenContent: (_) {
        finish(
          earnedReward
              ? const Right(unit)
              : const Left(AdDismissedFailure('ad_dismissed')),
        );
        disposeAndPreload();
      },
    );

    try {
      await ad.show(onUserEarnedReward: (_, __) => earnedReward = true);
    } on PlatformException catch (error) {
      debugPrint('Rewarded ad show call failed: ${error.message}');
      finish(const Left(AdLoadFailure('ad_failed')));
      disposeAndPreload();
    }
    return completion.future;
  }
}
