import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Spacing, radii, elevation and motion tokens — extracted from the Claude
/// Design handoff ("Spacing · radii · elevation · motion").
///
/// All dimensional values are scaled with `flutter_screenutil` against a
/// 360 × 800 design size, so layout holds across device sizes:
/// `.w` (width) for spacing, `.r` (radius/uniform) for corners, `.h` (height)
/// for key sizes, `.sp` for text (see `AppTextStyles`).
class AppSpacing {
  AppSpacing._();

  /// 4pt base scale.
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 24.w;
  static double get xxxl => 32.w;
}

/// Corner radii.
class AppRadii {
  AppRadii._();

  static double get chip => 12.r;
  static double get key => 16.r;
  static double get card => 24.r;
  static double get sheet => 28.r;
  static double get pill => 999.r;

  static Radius get chipR => Radius.circular(chip);
  static Radius get keyR => Radius.circular(key);
  static Radius get cardR => Radius.circular(card);
  static Radius get sheetR => Radius.circular(sheet);
}

/// Soft, low-contrast elevation. Shadows are intentionally restrained: the
/// numpad sits flush on its own surface; only cards, the total-bar lip, and
/// overlays lift.
class AppElevation {
  AppElevation._();

  /// 0 · key — barely-there lift on a digit key.
  static const List<BoxShadow> key = [
    BoxShadow(
      color: Color(0x12142823), // rgba(20,40,35,0.07)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// 1 · card.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x47142823), // rgba(20,40,35,0.28)
      blurRadius: 18,
      spreadRadius: -10,
      offset: Offset(0, 8),
    ),
  ];

  /// 2 · sheet / overlay (lifts upward).
  static const List<BoxShadow> sheet = [
    BoxShadow(
      color: Color(0x38142823), // rgba(20,40,35,0.22)
      blurRadius: 30,
      spreadRadius: -8,
      offset: Offset(0, -10),
    ),
  ];

  /// Lip under the sticky total bar (subtle upward shadow).
  static const List<BoxShadow> totalBarLip = [
    BoxShadow(
      color: Color(0x29142823), // rgba(20,40,35,0.16)
      blurRadius: 20,
      spreadRadius: -16,
      offset: Offset(0, -8),
    ),
  ];
}

/// Motion durations and the inset used for the depressed key state.
class AppMotion {
  AppMotion._();

  /// Key depress — inset + 1px down + haptic.
  static const Duration keyDepress = Duration(milliseconds: 80);

  /// Line commit — the big active amount settles into the list.
  static const Duration lineCommit = Duration(milliseconds: 180);

  /// Optional total count-up — figures roll to the new total.
  static const Duration totalCountUp = Duration(milliseconds: 240);

  /// Page transition (BaseRoute scale).
  static const Duration pageTransition = Duration(milliseconds: 220);

  /// Vertical offset applied to a key while pressed ("1px down").
  static double get keyPressOffset => 1.h;
}

/// Component sizing pulled from the numpad spec.
class AppSizes {
  AppSizes._();

  /// Function-strip keys (✎ · ( ) · % · ⌫).
  static double get keyFunctionHeight => 42.h;

  /// Digit / operator keys.
  static double get keyDigitHeight => 50.h;

  /// Wide accent commit (↵ new-line) bar.
  static double get keyCommitHeight => 46.h;

  /// Minimum thumb-friendly touch target.
  static double get minTouchTarget => 44.h;

  /// Icon stroke + grid (1.8px stroke · rounded · 24px grid).
  static double get iconStroke => 1.8.r;
  static double get iconGrid => 24.r;
}
