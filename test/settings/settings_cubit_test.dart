import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/features/settings/data/repos/settings_repository.dart';
import 'package:notaleq/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late SettingsCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Notaleq',
      packageName: 'com.osama.daif.notaleq',
      version: '1.2.3',
      buildNumber: '7',
      buildSignature: '',
    );
    prefs = await SharedPreferences.getInstance();
    cubit = SettingsCubit(SettingsRepository(prefs));
  });

  tearDown(() => cubit.close());

  test('sensible defaults', () {
    expect(cubit.state.themeMode, ThemeMode.system);
    expect(cubit.state.soundEnabled, isTrue);
    expect(cubit.state.hapticEnabled, isTrue);
    expect(cubit.state.decimalPlaces, 2);
    expect(cubit.state.currencyCode, isNull);
  });

  test('updates are emitted and persisted', () async {
    await cubit.setThemeMode(ThemeMode.dark);
    await cubit.setDecimalPlaces(3);
    await cubit.setCurrencyCode('EGP');
    await cubit.setHapticEnabled(false);

    expect(cubit.state.themeMode, ThemeMode.dark);
    expect(cubit.state.decimalPlaces, 3);
    expect(cubit.state.currencyCode, 'EGP');
    expect(cubit.state.hapticEnabled, isFalse);

    // A fresh cubit reads the persisted values.
    final reopened = SettingsCubit(SettingsRepository(prefs));
    expect(reopened.state.themeMode, ThemeMode.dark);
    expect(reopened.state.decimalPlaces, 3);
    expect(reopened.state.currencyCode, 'EGP');
    expect(reopened.state.hapticEnabled, isFalse);
    await reopened.close();
  });

  test('clearing the currency removes it', () async {
    await cubit.setCurrencyCode('USD');
    await cubit.setCurrencyCode(null);
    expect(cubit.state.currencyCode, isNull);
    expect(SettingsRepository(prefs).currencyCode, isNull);
  });

  test('loads the real app version (not hard-coded)', () async {
    // The version is fetched asynchronously in the constructor.
    await cubit.stream.firstWhere((s) => s.appVersion.isNotEmpty);
    expect(cubit.state.appVersion, '1.2.3');
  });
}
