import 'package:flutter/material.dart';

/// Design-system color tokens, extracted verbatim from the Claude Design
/// handoff (`Notaleq.dc.html` → "02 — DESIGN SYSTEM · Color tokens").
///
/// These are the *semantic* tokens the design defines (surfaces, text, accent,
/// the quiet `negative` clay tint, the louder `error` set, and the numpad's own
/// surface/key tokens). Most do not map onto Material's [ColorScheme], so they
/// live here as a [ThemeExtension] and are read with:
///
/// ```dart
/// final c = Theme.of(context).colors; // see ThemeData extension below
/// container.color = c.surface;
/// ```
///
/// Two first-class palettes only: [AppColors.light] and [AppColors.dark].
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    // Surfaces
    required this.appBg,
    required this.surface,
    required this.surfaceSunken,
    required this.hairline,
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    // Accent · semantic
    required this.accent,
    required this.accentStrong,
    required this.accentSoft,
    required this.error,
    required this.negative,
    required this.errorSoft,
    required this.onAccent,
    // Ledger
    required this.activeRowBg,
    // Numpad — surface
    required this.padSurface,
    // Numpad — keys
    required this.keyDigit,
    required this.keyDigitPressed,
    required this.keyDigitText,
    required this.keyOperator,
    required this.keyOperatorPressed,
    required this.keyOperatorText,
    required this.keyFunction,
    required this.keyFunctionPressed,
    required this.keyFunctionGlyph,
    required this.commitKey,
    required this.commitKeyPressed,
    required this.onCommit,
  });

  // --- Surfaces ---
  final Color appBg;
  final Color surface;
  final Color surfaceSunken;
  final Color hairline;

  // --- Text ---
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  // --- Accent · semantic ---
  final Color accent;
  final Color accentStrong;
  final Color accentSoft;
  final Color error;

  /// Quiet clay tint applied to *negative figures only* — calm, not a stoplight.
  final Color negative;
  final Color errorSoft;

  /// Text/icon color that sits on top of [accent] fills.
  final Color onAccent;

  // --- Ledger ---
  /// Background of the active / focused ledger row.
  final Color activeRowBg;

  // --- Numpad ---
  final Color padSurface;

  final Color keyDigit;
  final Color keyDigitPressed;
  final Color keyDigitText;

  final Color keyOperator;
  final Color keyOperatorPressed;
  final Color keyOperatorText;

  final Color keyFunction;
  final Color keyFunctionPressed;
  final Color keyFunctionGlyph;

  /// The wide accent commit (↵ new-line) key.
  final Color commitKey;
  final Color commitKeyPressed;
  final Color onCommit;

  /// Light palette — Notaleq.dc.html "LIGHT" column.
  static const AppColors light = AppColors(
    appBg: Color(0xFFF4F6F5),
    surface: Color(0xFFFFFFFF),
    surfaceSunken: Color(0xFFEAEEEC),
    hairline: Color(0xFFE0E6E3),
    textPrimary: Color(0xFF14201D),
    textSecondary: Color(0xFF52605C),
    textMuted: Color(0xFF8A968F),
    accent: Color(0xFF0E7A6B),
    accentStrong: Color(0xFF0A5347),
    accentSoft: Color(0xFFE3F1EE),
    error: Color(0xFFC8472F),
    negative: Color(0xFFA2604F),
    errorSoft: Color(0xFFFBEAE6),
    onAccent: Color(0xFFFFFFFF),
    activeRowBg: Color(0xFFE9F4F1),
    padSurface: Color(0xFFEAEEEC),
    keyDigit: Color(0xFFFFFFFF),
    keyDigitPressed: Color(0xFFEEF1EF),
    keyDigitText: Color(0xFF14201D),
    keyOperator: Color(0xFFDCE5E2),
    keyOperatorPressed: Color(0xFFCBD8D3),
    keyOperatorText: Color(0xFF0E7A6B),
    keyFunction: Color(0xFFD7DDDA),
    keyFunctionPressed: Color(0xFFC9D2CE),
    keyFunctionGlyph: Color(0xFF3E4B47),
    commitKey: Color(0xFF0E7A6B),
    commitKeyPressed: Color(0xFF0A5347),
    onCommit: Color(0xFFFFFFFF),
  );

  /// Dark palette — Notaleq.dc.html "DARK" column.
  ///
  /// Note: the design specified explicit *pressed* tints for the light numpad
  /// only. The dark pressed tints below are derived (a step darker than each
  /// key's default) to read as depressed; revisit if the design adds them.
  static const AppColors dark = AppColors(
    appBg: Color(0xFF0F100F),
    surface: Color(0xFF181A18),
    surfaceSunken: Color(0xFF151715),
    hairline: Color(0xFF262A27),
    textPrimary: Color(0xFFECEFEC),
    textSecondary: Color(0xFF9AA39E),
    textMuted: Color(0xFF6B746F),
    accent: Color(0xFF21A78F),
    accentStrong: Color(0xFF34D0B4),
    accentSoft: Color(0xFF1C2F2A),
    error: Color(0xFFF0876C),
    negative: Color(0xFFD0917F),
    errorSoft: Color(0xFF2A1916),
    onAccent: Color(0xFF04130F),
    activeRowBg: Color(0xFF1C2F2A),
    padSurface: Color(0xFF151715),
    keyDigit: Color(0xFF242825),
    keyDigitPressed: Color(0xFF1C201D),
    keyDigitText: Color(0xFFECEFEC),
    keyOperator: Color(0xFF2C322E),
    keyOperatorPressed: Color(0xFF242825),
    keyOperatorText: Color(0xFF34D0B4),
    keyFunction: Color(0xFF20251F),
    keyFunctionPressed: Color(0xFF181C18),
    keyFunctionGlyph: Color(0xFFAEB7B2),
    commitKey: Color(0xFF21A78F),
    commitKeyPressed: Color(0xFF1B8E79),
    onCommit: Color(0xFF04130F),
  );

  @override
  AppColors copyWith({
    Color? appBg,
    Color? surface,
    Color? surfaceSunken,
    Color? hairline,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentStrong,
    Color? accentSoft,
    Color? error,
    Color? negative,
    Color? errorSoft,
    Color? onAccent,
    Color? activeRowBg,
    Color? padSurface,
    Color? keyDigit,
    Color? keyDigitPressed,
    Color? keyDigitText,
    Color? keyOperator,
    Color? keyOperatorPressed,
    Color? keyOperatorText,
    Color? keyFunction,
    Color? keyFunctionPressed,
    Color? keyFunctionGlyph,
    Color? commitKey,
    Color? commitKeyPressed,
    Color? onCommit,
  }) {
    return AppColors(
      appBg: appBg ?? this.appBg,
      surface: surface ?? this.surface,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      hairline: hairline ?? this.hairline,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentStrong: accentStrong ?? this.accentStrong,
      accentSoft: accentSoft ?? this.accentSoft,
      error: error ?? this.error,
      negative: negative ?? this.negative,
      errorSoft: errorSoft ?? this.errorSoft,
      onAccent: onAccent ?? this.onAccent,
      activeRowBg: activeRowBg ?? this.activeRowBg,
      padSurface: padSurface ?? this.padSurface,
      keyDigit: keyDigit ?? this.keyDigit,
      keyDigitPressed: keyDigitPressed ?? this.keyDigitPressed,
      keyDigitText: keyDigitText ?? this.keyDigitText,
      keyOperator: keyOperator ?? this.keyOperator,
      keyOperatorPressed: keyOperatorPressed ?? this.keyOperatorPressed,
      keyOperatorText: keyOperatorText ?? this.keyOperatorText,
      keyFunction: keyFunction ?? this.keyFunction,
      keyFunctionPressed: keyFunctionPressed ?? this.keyFunctionPressed,
      keyFunctionGlyph: keyFunctionGlyph ?? this.keyFunctionGlyph,
      commitKey: commitKey ?? this.commitKey,
      commitKeyPressed: commitKeyPressed ?? this.commitKeyPressed,
      onCommit: onCommit ?? this.onCommit,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      appBg: c(appBg, other.appBg),
      surface: c(surface, other.surface),
      surfaceSunken: c(surfaceSunken, other.surfaceSunken),
      hairline: c(hairline, other.hairline),
      textPrimary: c(textPrimary, other.textPrimary),
      textSecondary: c(textSecondary, other.textSecondary),
      textMuted: c(textMuted, other.textMuted),
      accent: c(accent, other.accent),
      accentStrong: c(accentStrong, other.accentStrong),
      accentSoft: c(accentSoft, other.accentSoft),
      error: c(error, other.error),
      negative: c(negative, other.negative),
      errorSoft: c(errorSoft, other.errorSoft),
      onAccent: c(onAccent, other.onAccent),
      activeRowBg: c(activeRowBg, other.activeRowBg),
      padSurface: c(padSurface, other.padSurface),
      keyDigit: c(keyDigit, other.keyDigit),
      keyDigitPressed: c(keyDigitPressed, other.keyDigitPressed),
      keyDigitText: c(keyDigitText, other.keyDigitText),
      keyOperator: c(keyOperator, other.keyOperator),
      keyOperatorPressed: c(keyOperatorPressed, other.keyOperatorPressed),
      keyOperatorText: c(keyOperatorText, other.keyOperatorText),
      keyFunction: c(keyFunction, other.keyFunction),
      keyFunctionPressed: c(keyFunctionPressed, other.keyFunctionPressed),
      keyFunctionGlyph: c(keyFunctionGlyph, other.keyFunctionGlyph),
      commitKey: c(commitKey, other.commitKey),
      commitKeyPressed: c(commitKeyPressed, other.commitKeyPressed),
      onCommit: c(onCommit, other.onCommit),
    );
  }
}

/// Convenience accessor: `Theme.of(context).colors`.
extension AppColorsX on ThemeData {
  AppColors get colors => extension<AppColors>() ?? AppColors.light;
}

/// Convenience accessor straight off a [BuildContext].
extension AppColorsContextX on BuildContext {
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
