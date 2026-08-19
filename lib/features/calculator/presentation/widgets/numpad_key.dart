import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';

/// The four key families from the design, each with a distinct visual weight.
enum NumpadKeyFamily { digit, operatorKey, functionKey, subtotal, commit }

/// A single, tactile numpad key.
///
/// Core feel requirement from the design: a **clearly depressed** pressed state
/// (inset look + 1px down, 80ms). Any key can be disabled via `enabled: false`
/// — operators at the cap, or the number / `.` / `( ) %` keys while the active
/// line still needs a leading operator.
///
/// Presentation only — it calls [onPressed]; haptic + click-sound feedback is
/// layered on later (respecting the user toggles + system silent mode).
class NumpadKey extends StatefulWidget {
  const NumpadKey({
    super.key,
    required this.family,
    this.label,
    this.iconAsset,
    this.onPressed,
    this.enabled = true,
    this.height,
    this.foreground,
  }) : assert(label != null || iconAsset != null, 'Provide a label or an icon');

  final NumpadKeyFamily family;
  final String? label;

  /// An [AppIcons] SVG asset path (used for ⌫ and the comment-jump key).
  final String? iconAsset;
  final VoidCallback? onPressed;
  final bool enabled;

  /// Defaults to the family height; the grid can override.
  final double? height;

  /// Overrides the family's text/glyph color (e.g. the error color on AC).
  final Color? foreground;

  @override
  State<NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<NumpadKey> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_interactive) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final spec = _spec(c);
    final height = widget.height ?? _defaultHeight;
    final disabled = !widget.enabled;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: _interactive ? widget.onPressed : null,
      child: AnimatedContainer(
        duration: AppMotion.keyDepress,
        curve: Curves.easeOut,
        height: height,
        transform: Matrix4.translationValues(
          0,
          _pressed ? AppMotion.keyPressOffset : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: disabled
              ? c.surfaceSunken
              : (_pressed ? spec.pressedBg : spec.bg),
          borderRadius: BorderRadius.circular(AppRadii.key),
          border: spec.border,
          boxShadow: _pressed || disabled ? null : spec.shadow,
          // Simulated inset: a soft top-down darkening while pressed.
          gradient: _pressed
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x24000000), Color(0x00000000)],
                  stops: [0, 0.5],
                )
              : null,
        ),
        alignment: Alignment.center,
        child: _content(spec, disabled, _pressed, c),
      ),
    );
  }

  Widget _content(_KeySpec spec, bool disabled, bool pressed, AppColors c) {
    // On press the glyph shifts to the design's depressed colour (the strong
    // accent), unless a per-key [foreground] override (e.g. AC's error red) is
    // set — that wins in every state.
    final base = widget.foreground ?? (pressed ? spec.pressedFg : spec.fg);
    final fg = disabled ? c.textMuted : base;

    if (widget.family == NumpadKeyFamily.commit) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              '↵',
              style: AppTextStyles.keyCommit.copyWith(
                fontSize: 24.sp,
                color: fg,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          if (widget.label != null)
            Text(
              widget.label!,
              style: AppTextStyles.keyCommit.copyWith(color: fg),
            ),
        ],
      );
    }
    if (widget.iconAsset != null) {
      return AppSvgIcon(widget.iconAsset!, size: 22.r, color: fg);
    }
    return Text(widget.label!, style: spec.textStyle.copyWith(color: fg));
  }

  double get _defaultHeight {
    switch (widget.family) {
      case NumpadKeyFamily.functionKey:
        return AppSizes.keyFunctionHeight;
      case NumpadKeyFamily.commit:
        return AppSizes.keyCommitHeight;
      case NumpadKeyFamily.digit:
      case NumpadKeyFamily.operatorKey:
      case NumpadKeyFamily.subtotal:
        return AppSizes.keyDigitHeight;
    }
  }

  _KeySpec _spec(AppColors c) {
    switch (widget.family) {
      case NumpadKeyFamily.digit:
        return _KeySpec(
          bg: c.keyDigit,
          pressedBg: c.keyDigitPressed,
          fg: c.keyDigitText,
          pressedFg: c.accentStrong,
          textStyle: AppTextStyles.keyDigit,
          border: Border.all(color: c.hairline),
          shadow: AppElevation.key,
        );
      case NumpadKeyFamily.operatorKey:
        return _KeySpec(
          bg: c.keyOperator,
          pressedBg: c.keyOperatorPressed,
          fg: c.keyOperatorText,
          pressedFg: c.accentStrong,
          textStyle: AppTextStyles.keyOperator,
        );
      case NumpadKeyFamily.subtotal:
        return _KeySpec(
          bg: c.keyOperator,
          pressedBg: c.keyOperatorPressed,
          fg: c.keyOperatorText,
          pressedFg: c.accentStrong,
          textStyle: AppTextStyles.keyOperator,
          border: Border.all(color: c.keyOperatorText, width: 1.5),
        );
      case NumpadKeyFamily.functionKey:
        return _KeySpec(
          bg: c.keyFunction,
          pressedBg: c.keyFunctionPressed,
          fg: c.keyFunctionGlyph,
          pressedFg: c.accentStrong,
          textStyle: AppTextStyles.keyFunction,
        );
      case NumpadKeyFamily.commit:
        return _KeySpec(
          bg: c.commitKey,
          pressedBg: c.commitKeyPressed,
          fg: c.onCommit,
          pressedFg: c.onCommit,
          textStyle: AppTextStyles.keyCommit,
        );
    }
  }
}

class _KeySpec {
  const _KeySpec({
    required this.bg,
    required this.pressedBg,
    required this.fg,
    required this.pressedFg,
    required this.textStyle,
    this.border,
    this.shadow,
  });

  final Color bg;
  final Color pressedBg;
  final Color fg;

  /// Glyph colour while the key is held down (the design's depressed accent).
  final Color pressedFg;
  final TextStyle textStyle;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
}
