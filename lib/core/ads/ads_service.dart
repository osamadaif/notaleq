import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';
import 'consent_manager.dart';

class AdsService {
  AdsService(this._consentManager);

  final ConsentManager _consentManager;
  Future<void>? _initialization;
  bool _isReady = false;

  bool get isReady => _isReady;
  bool get canRequestAds => _consentManager.canRequestAds;

  Future<void> initialize() => _initialization ??= _initializeOnce();

  Future<void> _initializeOnce() async {
    if (!AdIds.isSupportedPlatform) return;
    await _consentManager.ensureConsent();
    try {
      await MobileAds.instance.initialize();
      if (kDebugMode) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: AdIds.debugTestDeviceIds),
        );
      }
      _isReady = true;
    } on PlatformException catch (error) {
      debugPrint('AdMob initialization failed: ${error.message}');
    } on MissingPluginException catch (error) {
      debugPrint('AdMob initialization unavailable: $error');
    }
  }
}
