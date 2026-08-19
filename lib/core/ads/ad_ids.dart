import 'dart:io';

import 'package:flutter/foundation.dart';

class AdIds {
  AdIds._();

  static const String _androidTestBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _androidTestRewarded =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _iosTestRewarded =
      'ca-app-pub-3940256099942544/1712485313';

  static const String _androidHistoryBanner =
      'ca-app-pub-9522361506110215/8330441769';
  static const String _androidSheetDetailBanner =
      'ca-app-pub-9522361506110215/1398096704';
  static const String _androidSettingsBanner =
      'ca-app-pub-9522361506110215/4335356430';
  static const String _androidExportRewarded =
      'ca-app-pub-9522361506110215/6458851691';

  // TODO(admob-ios): Replace these after creating the Notaleq iOS AdMob app.
  static const String _iosHistoryBanner = 'TODO_IOS_HISTORY_BANNER_ID';
  static const String _iosSheetDetailBanner = 'TODO_IOS_SHEET_DETAIL_BANNER_ID';
  static const String _iosSettingsBanner = 'TODO_IOS_SETTINGS_BANNER_ID';
  static const String _iosExportRewarded = 'TODO_IOS_EXPORT_REWARDED_ID';

  static bool get isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  static bool get canServeAds =>
      Platform.isAndroid || (Platform.isIOS && kDebugMode);

  static List<String> get debugTestDeviceIds => const String.fromEnvironment(
    'ADMOB_TEST_DEVICE_IDS',
  ).split(',').map((id) => id.trim()).where((id) => id.isNotEmpty).toList();

  static String get historyBanner => _bannerId(
    androidReleaseId: _androidHistoryBanner,
    iosReleaseId: _iosHistoryBanner,
  );

  static String get sheetDetailBanner => _bannerId(
    androidReleaseId: _androidSheetDetailBanner,
    iosReleaseId: _iosSheetDetailBanner,
  );

  static String get settingsBanner => _bannerId(
    androidReleaseId: _androidSettingsBanner,
    iosReleaseId: _iosSettingsBanner,
  );

  static String get exportRewarded {
    if (Platform.isAndroid) {
      return kDebugMode ? _androidTestRewarded : _androidExportRewarded;
    }
    if (Platform.isIOS) {
      return kDebugMode ? _iosTestRewarded : _iosExportRewarded;
    }
    throw UnsupportedError('AdMob supports Android and iOS only.');
  }

  static String _bannerId({
    required String androidReleaseId,
    required String iosReleaseId,
  }) {
    if (Platform.isAndroid) {
      return kDebugMode ? _androidTestBanner : androidReleaseId;
    }
    if (Platform.isIOS) {
      return kDebugMode ? _iosTestBanner : iosReleaseId;
    }
    throw UnsupportedError('AdMob supports Android and iOS only.');
  }
}
