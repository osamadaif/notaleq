import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_ids.dart';

class ConsentManager {
  static const MethodChannel _trackingChannel = MethodChannel(
    'com.osama.daif.notaleq/tracking-consent',
  );

  bool _canRequestAds = false;

  bool get canRequestAds => _canRequestAds;

  Future<void> ensureConsent() async {
    final updateCompleted = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      _requestParameters,
      () async {
        await _showRequiredForm();
        updateCompleted.complete();
      },
      (error) {
        debugPrint('AdMob consent update failed: ${error.message}');
        updateCompleted.complete();
      },
    );
    await updateCompleted.future;
    await _refreshAdPermission();
    await _requestTrackingAuthorization();
  }

  ConsentRequestParameters get _requestParameters {
    if (!kDebugMode || AdIds.debugTestDeviceIds.isEmpty) {
      return ConsentRequestParameters();
    }
    return ConsentRequestParameters(
      consentDebugSettings: ConsentDebugSettings(
        testIdentifiers: AdIds.debugTestDeviceIds,
      ),
    );
  }

  Future<void> _showRequiredForm() async {
    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) {
          debugPrint('AdMob consent form failed: ${error.message}');
        }
      });
    } on PlatformException catch (error) {
      debugPrint('AdMob consent form failed: ${error.message}');
    }
  }

  Future<void> _refreshAdPermission() async {
    try {
      _canRequestAds = await ConsentInformation.instance.canRequestAds();
    } on PlatformException catch (error) {
      debugPrint('AdMob consent status failed: ${error.message}');
      _canRequestAds = false;
    }
  }

  Future<void> _requestTrackingAuthorization() async {
    if (!Platform.isIOS) return;
    try {
      await _trackingChannel.invokeMethod<void>('requestTrackingAuthorization');
    } on PlatformException catch (error) {
      debugPrint('ATT request failed: ${error.message}');
    } on MissingPluginException catch (error) {
      debugPrint('ATT request unavailable: $error');
    }
  }
}
