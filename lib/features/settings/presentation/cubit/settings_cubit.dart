import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/style/app_theme.dart';
import '../../data/repos/settings_repository.dart';
import 'settings_state.dart';

/// App-wide settings. Registered as a singleton so the app root (theme) and the
/// settings screen share one instance.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(const SettingsState()) {
    _load();
    _loadVersion();
  }

  final SettingsRepository _repo;

  void _load() {
    emit(SettingsState(
      themeMode: AppThemeMode.fromString(_repo.themeMode),
      soundEnabled: _repo.soundEnabled,
      hapticEnabled: _repo.hapticEnabled,
      decimalPlaces: _repo.decimalPlaces,
      currencyCode: _repo.currencyCode,
      languageCode: _repo.languageCode,
    ));
  }

  /// Loads the real app version asynchronously; a failure just leaves it blank
  /// (the About row falls back to the name alone).
  Future<void> _loadVersion() async {
    try {
      final version = await _repo.appVersion();
      if (!isClosed) emit(state.copyWith(appVersion: version));
    } catch (_) {
      // Non-fatal — version display is cosmetic.
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _repo.setThemeMode(AppThemeMode.toStorage(mode));
  }

  Future<void> setSoundEnabled(bool value) async {
    emit(state.copyWith(soundEnabled: value));
    await _repo.setSoundEnabled(value);
  }

  Future<void> setHapticEnabled(bool value) async {
    emit(state.copyWith(hapticEnabled: value));
    await _repo.setHapticEnabled(value);
  }

  Future<void> setDecimalPlaces(int value) async {
    emit(state.copyWith(decimalPlaces: value));
    await _repo.setDecimalPlaces(value);
  }

  Future<void> setCurrencyCode(String? value) async {
    emit(state.copyWith(currencyCode: value));
    await _repo.setCurrencyCode(value);
  }

  Future<void> setLanguageCode(String? value) async {
    emit(state.copyWith(languageCode: value));
    await _repo.setLanguageCode(value);
  }
}
