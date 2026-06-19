/// Centralised asset paths.
///
/// The brand mark is a typographic "=" glyph. Every UI icon is the exact vector
/// from the design (1.8px stroke, rounded, 24px grid), shipped as SVG under
/// `assets/icons/` and rendered via `flutter_svg` — see
/// `core/widgets/app_icons.dart` ([AppIcons] + [AppSvgIcon]).
///
/// Fonts are declared in `pubspec.yaml` and referenced by family name through
/// [AppTextStyles] (`IBM Plex Sans Arabic`, `IBM Plex Mono`), so they are not
/// listed here.
class AppAssets {
  AppAssets._();

  static const String _translations = 'assets/translations';

  /// Manual-i18n bundle for a language code, e.g. `assets/translations/ar.json`.
  static String translations(String languageCode) =>
      '$_translations/$languageCode.json';
}
