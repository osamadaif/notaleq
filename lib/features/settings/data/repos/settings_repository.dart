import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/style/app_theme.dart';

/// Reads/writes the app-wide preferences (SCHEMA §7). Plain key-values in
/// SharedPreferences — no `Either`, reads are synchronous. Also exposes the
/// app's real version (from the platform bundle) for the "About" row.
class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  /// The app's user-facing version (e.g. `"1.0.0"`), read from the native
  /// bundle — never hard-coded.
  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static const String _soundKey = 'sound_enabled';
  static const String _hapticKey = 'haptic_enabled';
  static const String _decimalsKey = 'decimal_places';
  static const String _currencyKey = 'currency_code';
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  bool get soundEnabled => _prefs.getBool(_soundKey) ?? true;
  bool get hapticEnabled => _prefs.getBool(_hapticKey) ?? true;
  int get decimalPlaces => _prefs.getInt(_decimalsKey) ?? 2;
  String? get currencyCode => _prefs.getString(_currencyKey);
  String get themeMode => _prefs.getString(_themeKey) ?? AppThemeMode.system;
  String? get languageCode => _prefs.getString(_languageKey);

  Future<void> setSoundEnabled(bool value) =>
      _prefs.setBool(_soundKey, value);
  Future<void> setHapticEnabled(bool value) =>
      _prefs.setBool(_hapticKey, value);
  Future<void> setDecimalPlaces(int value) =>
      _prefs.setInt(_decimalsKey, value);
  Future<void> setThemeMode(String value) =>
      _prefs.setString(_themeKey, value);

  Future<void> setCurrencyCode(String? value) => value == null
      ? _prefs.remove(_currencyKey)
      : _prefs.setString(_currencyKey, value);

  Future<void> setLanguageCode(String? value) => value == null
      ? _prefs.remove(_languageKey)
      : _prefs.setString(_languageKey, value);
}
