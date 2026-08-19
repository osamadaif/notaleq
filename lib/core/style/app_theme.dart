import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_text_styles.dart';

/// Builds the light and dark [ThemeData] from the design-system tokens and
/// registers [AppColors] as a [ThemeExtension] so the full token set is
/// reachable via `context.colors`.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppColors.light);
  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  static SystemUiOverlayStyle systemUiOverlayStyle(Brightness brightness) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      systemStatusBarContrastEnforced: false,
    );
  }

  static ThemeData _build(Brightness brightness, AppColors c) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: c.accent,
          brightness: brightness,
        ).copyWith(
          primary: c.accent,
          onPrimary: c.onAccent,
          surface: c.surface,
          onSurface: c.textPrimary,
          error: c.error,
          outline: c.hairline,
        );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.appBg,
      fontFamily: AppTextStyles.fontArabic,
      splashFactory: InkRipple.splashFactory,
      extensions: <ThemeExtension<dynamic>>[c],
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme, c),
      dividerColor: c.hairline,
      dividerTheme: DividerThemeData(color: c.hairline, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: c.textSecondary, size: AppSizes.iconGrid),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: AppRadii.sheetR),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base, AppColors c) {
    return base
        .copyWith(
          titleMedium: AppTextStyles.title,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.body,
          bodySmall: AppTextStyles.helper,
          labelLarge: AppTextStyles.button,
        )
        .apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);
  }
}

/// Maps the persisted `theme_mode` setting (SharedPreferences) to/from
/// [ThemeMode]. The runtime selection is driven by the settings feature; this
/// helper keeps the string contract in one place.
class AppThemeMode {
  AppThemeMode._();

  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';

  static ThemeMode fromString(String? value) {
    switch (value) {
      case light:
        return ThemeMode.light;
      case dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String toStorage(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return light;
      case ThemeMode.dark:
        return dark;
      case ThemeMode.system:
        return system;
    }
  }
}
