import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/calculator/data/repos/calculator_repository.dart';
import '../../features/calculator/presentation/cubit/calculator_cubit.dart';
import '../../features/export/data/sheet_export_service.dart';
import '../../features/export/data/connectivity_export_network_status.dart';
import '../../features/export/domain/export_network_status.dart';
import '../../features/export/presentation/cubit/export_gate_cubit.dart';
import '../../features/history/data/repos/history_repository.dart';
import '../../features/history/presentation/cubit/history_cubit.dart';
import '../../features/history/presentation/cubit/sheet_detail_cubit.dart';
import '../../features/settings/data/repos/settings_repository.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../database/app_database.dart';
import '../ads/ads_service.dart';
import '../ads/consent_manager.dart';
import '../ads/rewarded_ad_manager.dart';

/// Global service locator.
final GetIt getIt = GetIt.instance;

/// Single entry point for dependency wiring. Called (and awaited) in `main()`
/// before `runApp`.
///
/// Registration conventions:
/// * Services / DB / SharedPreferences → `registerLazySingleton`.
/// * Repositories                      → `registerLazySingleton`.
/// * Cubits                            → `registerFactory` (fresh per screen).
///
/// Keep this thin: each feature owns an `_initX()` helper below so wiring stays
/// grouped and reviewable.
Future<void> setUpInjector() async {
  await _initCore();
  _initAds();
  _initExport();
  _initCalculator();
  _initHistory();
  _initSettings();
}

void _initExport() {
  getIt.registerLazySingleton<SheetExportService>(SheetExportService.new);
  getIt.registerLazySingleton<ExportNetworkStatus>(
    () => ConnectivityExportNetworkStatus(Connectivity()),
  );
  getIt.registerFactory<ExportGateCubit>(
    () => ExportGateCubit(
      getIt<ExportNetworkStatus>(),
      getIt<RewardedAdManager>(),
    ),
  );
}

void _initAds() {
  getIt.registerLazySingleton<ConsentManager>(ConsentManager.new);
  getIt.registerLazySingleton<AdsService>(
    () => AdsService(getIt<ConsentManager>()),
  );
  getIt.registerLazySingleton<RewardedAdManager>(
    () => AdMobRewardedAdManager(getIt<AdsService>()),
  );
}

/// Cross-cutting singletons: the drift DB, its DAOs, and SharedPreferences.
Future<void> _initCore() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<AppDatabase>(AppDatabase.new);
  getIt.registerLazySingleton<CalculationsDao>(
    () => getIt<AppDatabase>().calculationsDao,
  );
  getIt.registerLazySingleton<LinesDao>(() => getIt<AppDatabase>().linesDao);
}

void _initCalculator() {
  getIt.registerLazySingleton<CalculatorRepository>(
    () =>
        CalculatorRepository(getIt<AppDatabase>(), getIt<SharedPreferences>()),
  );
  getIt.registerFactory<CalculatorCubit>(
    () => CalculatorCubit(getIt<CalculatorRepository>()),
  );
}

void _initHistory() {
  getIt.registerLazySingleton<HistoryRepository>(
    () => HistoryRepository(
      getIt<AppDatabase>().calculationsDao,
      getIt<AppDatabase>().linesDao,
    ),
  );
  getIt.registerFactory<HistoryCubit>(
    () => HistoryCubit(getIt<HistoryRepository>()),
  );
  getIt.registerFactory<SheetDetailCubit>(
    () => SheetDetailCubit(getIt<HistoryRepository>()),
  );
}

void _initSettings() {
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepository(getIt<SharedPreferences>()),
  );
  // Singleton: shared by the app root (theme) and the settings screen.
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepository>()),
  );
}
