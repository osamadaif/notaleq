import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/style/app_colors.dart';
import 'package:notaleq/core/style/app_theme.dart';

void main() {
  testWidgets('themes register the AppColors design-token extension',
      (tester) async {
    // AppTheme builds text styles via `.sp`, so ScreenUtil must be initialized.
    await tester.pumpWidget(ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (_, __) => const SizedBox(),
    ));
    expect(AppTheme.light.extension<AppColors>(), same(AppColors.light));
    expect(AppTheme.dark.extension<AppColors>(), same(AppColors.dark));
  });

  test('light and dark palettes are distinct', () {
    expect(AppColors.light.appBg, isNot(AppColors.dark.appBg));
    expect(AppColors.light.accent, isNot(AppColors.dark.accent));
  });

  test('status bar stays transparent with readable icons in both themes', () {
    final expectedIconBrightness = <Brightness, Brightness>{
      Brightness.light: Brightness.dark,
      Brightness.dark: Brightness.light,
    };

    for (final themeBrightness in Brightness.values) {
      final style = AppTheme.systemUiOverlayStyle(themeBrightness);
      expect(style.statusBarColor, Colors.transparent);
      expect(
        style.statusBarIconBrightness,
        expectedIconBrightness[themeBrightness],
      );
      expect(style.statusBarBrightness, themeBrightness);
      expect(style.systemStatusBarContrastEnforced, isFalse);
    }
  });
}
