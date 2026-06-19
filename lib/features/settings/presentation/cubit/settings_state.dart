import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool soundEnabled,
    @Default(true) bool hapticEnabled,
    @Default(2) int decimalPlaces,
    String? currencyCode,

    /// App language code; null = follow the device language.
    String? languageCode,

    /// Real app version from the platform bundle (empty until loaded).
    @Default('') String appVersion,
  }) = _SettingsState;
}
