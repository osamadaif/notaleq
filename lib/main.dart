import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/app/app.dart';
import 'core/ads/ads_service.dart';
import 'core/ads/rewarded_ad_manager.dart';
import 'core/bloc_observer.dart';
import 'core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await setUpInjector();
  runApp(const NotaleqApp());
  unawaited(_startAds());
}

Future<void> _startAds() async {
  await getIt<AdsService>().initialize();
  await getIt<RewardedAdManager>().preload();
}
