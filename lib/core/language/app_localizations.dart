import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';

import '../style/app_assets.dart';

/// Lightweight manual i18n: loads `assets/translations/<lang>.json` and looks up
/// strings by key. Arabic is the primary language; English is the fallback.
///
/// Usage: `context.tr(LangKeys.total)`. For interpolation, pass `params`:
/// `context.tr(LangKeys.linesCount, params: {'count': '8'})`.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  Map<String, String> _strings = const {};

  /// Arabic (primary) + English and the most-used world languages.
  static const List<Locale> supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
    Locale('hi'),
  ];

  static AppLocalizations of(BuildContext context) {
    final instance = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(instance != null, 'AppLocalizations not found in context');
    return instance!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<void> load() async {
    final raw = await rootBundle.loadString(
      AppAssets.translations(locale.languageCode),
    );
    final Map<String, dynamic> decoded =
        json.decode(raw) as Map<String, dynamic>;
    _strings = decoded.map((k, v) => MapEntry(k, v.toString()));
  }

  /// Returns the translation for [key], interpolating `{name}` placeholders from
  /// [params]. Falls back to the key itself if missing (and warns in debug).
  String tr(String key, {Map<String, String>? params}) {
    var value = _strings[key];
    if (value == null) {
      if (kDebugMode) {
        debugPrint('Missing translation: $key (${locale.languageCode})');
      }
      return key;
    }
    if (params != null) {
      params.forEach((k, v) => value = value!.replaceAll('{$k}', v));
    }
    return value!;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

/// `context.tr(...)` sugar.
extension AppLocalizationsX on BuildContext {
  String tr(String key, {Map<String, String>? params}) =>
      AppLocalizations.of(this).tr(key, params: params);
}
