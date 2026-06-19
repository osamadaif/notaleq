import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Typography tokens — extracted from the Claude Design handoff
/// ("Typography & figures").
///
/// Two families do all the work:
/// * [fontArabic] — IBM Plex Sans Arabic carries every Arabic comment / label /
///   UI string.
/// * [fontMono] — IBM Plex Mono carries every amount (tabular figures).
///
/// Font sizes are scaled with `flutter_screenutil`'s `.sp` (360 × 800 design).
/// Styles are intentionally **color-less**: color is theme-dependent and applied
/// by the consuming widget via `AppColors`.
class AppTextStyles {
  AppTextStyles._();

  static const String fontArabic = 'IBM Plex Sans Arabic';
  static const String fontMono = 'IBM Plex Mono';

  // --- Amounts — IBM Plex Mono, tabular figures. ---

  /// Active line, Samsung-style while typing. Mono · 56 · 500.
  static TextStyle get amountActive => TextStyle(
        fontFamily: fontMono,
        fontSize: 56.sp,
        fontWeight: FontWeight.w500,
        height: 1,
        letterSpacing: -0.56.sp,
      );

  /// The enlarged amount inside the active ledger row. Mono · 26 · 500.
  static TextStyle get amountActiveRow => TextStyle(
        fontFamily: fontMono,
        fontSize: 26.sp,
        fontWeight: FontWeight.w500,
        height: 1,
      );

  /// Big standalone total. Mono · 40 · 600.
  static TextStyle get total => TextStyle(
        fontFamily: fontMono,
        fontSize: 40.sp,
        fontWeight: FontWeight.w600,
        height: 1,
      );

  /// Total inside the sticky total bar. Mono · 28 · 600.
  static TextStyle get totalBar => TextStyle(
        fontFamily: fontMono,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        height: 1,
      );

  /// Settled amount once a line drops into the list. Mono · 18 · 500.
  static TextStyle get amountSettled => TextStyle(
        fontFamily: fontMono,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );

  /// Cached total preview in a history row. Mono · 18 · 600.
  static TextStyle get amountHistory => TextStyle(
        fontFamily: fontMono,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      );

  // --- Arabic text — IBM Plex Sans Arabic. ---

  /// Line comment. Arabic · 15 · 400.
  static TextStyle get comment => TextStyle(
        fontFamily: fontArabic,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );

  /// Comment-only section header. Arabic · 13 · 600.
  static TextStyle get sectionHeader => TextStyle(
        fontFamily: fontArabic,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.39.sp,
      );

  /// Sheet name / app-bar title. Arabic · 16 · 600.
  static TextStyle get title => TextStyle(
        fontFamily: fontArabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );

  /// Settings row label / general body. Arabic · 16 · 400.
  static TextStyle get body => TextStyle(
        fontFamily: fontArabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      );

  /// Button label. Arabic · 15 · 500.
  static TextStyle get button => TextStyle(
        fontFamily: fontArabic,
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
      );

  /// Empty-state title. Arabic · 17 · 600.
  static TextStyle get emptyTitle => TextStyle(
        fontFamily: fontArabic,
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
      );

  /// Empty-state body / secondary helper. Arabic · 14 · 400.
  static TextStyle get helper => TextStyle(
        fontFamily: fontArabic,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  /// Currency suffix shown next to a total (e.g. "ج.م"). Arabic · 15 · 400.
  static TextStyle get currency => TextStyle(
        fontFamily: fontArabic,
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );

  /// Mono meta / caption (line counts, dates). Mono · 11 · 400.
  static TextStyle get meta => TextStyle(
        fontFamily: fontMono,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      );

  // --- Numpad key labels — IBM Plex Mono. ---

  /// Digit key glyph (0–9, .). Mono · 22.
  static TextStyle get keyDigit => TextStyle(
        fontFamily: fontMono,
        fontSize: 22.sp,
      );

  /// Operator key glyph (+ − × ÷). Mono · 24.
  static TextStyle get keyOperator => TextStyle(
        fontFamily: fontMono,
        fontSize: 24.sp,
      );

  /// AC label. Mono · 16 · 600.
  static TextStyle get keyAc => TextStyle(
        fontFamily: fontMono,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );

  /// Function glyph ( ( ) % ). Mono · 20.
  static TextStyle get keyFunction => TextStyle(
        fontFamily: fontMono,
        fontSize: 20.sp,
      );

  /// Commit ("سطر جديد") label. Arabic · 16 · 500.
  static TextStyle get keyCommit => TextStyle(
        fontFamily: fontArabic,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      );
}
