import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/settings/presentation/cubit/settings_state.dart';
import '../di/injection_container.dart';
import '../language/app_localizations.dart';
import '../routes/app_router.dart';
import '../routes/app_routes.dart';
import '../style/app_theme.dart';

/// Root application widget: wires the light/dark themes, manual i18n and locale.
///
/// Arabic is the default locale and the app is RTL-first. `themeMode` is
/// currently [ThemeMode.system]; once the settings feature lands it will be
/// driven by a `ThemeCubit` reading the persisted `theme_mode` preference.
class NotaleqApp extends StatelessWidget {
  const NotaleqApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 360 × 800 design size; all `.w/.h/.r/.sp` tokens scale against it.
    // SettingsCubit is provided above MaterialApp so the theme reacts to it and
    // pushed routes (settings screen) share the one instance.
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        builder: (context, child) =>
            BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settings) => MaterialApp(
            title: 'Notaleq',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            // Chosen language, or null to follow the device (see callback below).
            locale: settings.languageCode == null
                ? null
                : Locale(settings.languageCode!),
            supportedLocales: AppLocalizations.supportedLocales,
            // Follow the device language when supported, else fall back to English.
            localeResolutionCallback: (deviceLocale, supported) {
              if (deviceLocale != null) {
                for (final l in supported) {
                  if (l.languageCode == deviceLocale.languageCode) return l;
                }
              }
              return const Locale('en');
            },
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRoutes.calculator,
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
