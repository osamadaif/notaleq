import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show HapticFeedback, SystemSound, SystemSoundType;

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/widgets/app_icons.dart';
import 'numpad_key.dart';

/// The full custom numpad — the only keyboard for amounts (the OS keyboard must
/// never appear for amounts).
///
/// Layout (Samsung-inspired): a compact function strip on top
/// (✎to-comment · ( · ) · % · ⌫), digits in phone order with the operator
/// column weighted on the right, a wide accent commit bar + an "=" key.
///
/// Pure presentation: it emits semantic key events; parsing and the
/// operator-count limit live in the calculator feature. On each press a light
/// haptic fires when [hapticEnabled] and the device key-click sound when
/// [soundEnabled]. Pass [operatorsEnabled] = false to disable
/// `+ − × ÷` at the operator cap. Pass [numbersEnabled] = false to disable the
/// number / `.` / `( ) %` keys while the line still needs a leading operator.
class Numpad extends StatelessWidget {
  const Numpad({
    super.key,
    required this.commitLabel,
    this.onDigit,
    this.onOperator,
    this.onParen,
    this.onPercent,
    this.onClearAll,
    this.onBackspace,
    this.onCommentJump,
    this.onCommit,
    this.operatorsEnabled = true,
    this.numbersEnabled = true,
    this.hapticEnabled = true,
    this.soundEnabled = true,
  });

  final String commitLabel;

  /// `0`–`9` and `.`.
  final ValueChanged<String>? onDigit;

  /// One of `+ − × ÷`.
  final ValueChanged<String>? onOperator;

  /// `(` or `)`.
  final ValueChanged<String>? onParen;

  final VoidCallback? onPercent;
  final VoidCallback? onClearAll;
  final VoidCallback? onBackspace;
  final VoidCallback? onCommentJump;
  final VoidCallback? onCommit;

  final bool operatorsEnabled;

  /// Disables number entry (`0`–`9`, `.`, `(`, `)`, `%`) while the active line
  /// must still begin with a join operator (tape model).
  final bool numbersEnabled;

  final bool hapticEnabled;

  /// Plays the device's built-in key-click sound on each press when enabled.
  final bool soundEnabled;

  static const double _gap = 6;

  /// Wraps a key callback with the device's key feedback (haptic + click sound)
  /// per the user's toggles.
  VoidCallback? _tap(VoidCallback? cb) {
    if (cb == null) return null;
    return () {
      if (hapticEnabled) HapticFeedback.mediumImpact();
      if (soundEnabled) SystemSound.play(SystemSoundType.click);
      cb();
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.padSurface,
        borderRadius: BorderRadius.vertical(top: AppRadii.cardR),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Function strip: ✎ comment-jump · ( · ) · % · ⌫ backspace.
          Row(
            children: [
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                iconAsset: AppIcons.commentJump,
                onPressed: _tap(onCommentJump),
              )),
              const SizedBox(width: _gap),
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                label: '(',
                enabled: numbersEnabled,
                onPressed: _tap(onParen == null ? null : () => onParen!('(')),
              )),
              const SizedBox(width: _gap),
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                label: ')',
                enabled: numbersEnabled,
                onPressed: _tap(onParen == null ? null : () => onParen!(')')),
              )),
              const SizedBox(width: _gap),
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                label: '%',
                enabled: numbersEnabled,
                onPressed: _tap(onPercent),
              )),
              const SizedBox(width: _gap),
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                iconAsset: AppIcons.backspace,
                onPressed: _tap(onBackspace),
              )),
            ],
          ),
          const SizedBox(height: _gap),
          _digitRow(['7', '8', '9'], '÷'),
          const SizedBox(height: _gap),
          _digitRow(['4', '5', '6'], '×'),
          const SizedBox(height: _gap),
          _digitRow(['1', '2', '3'], '−'),
          const SizedBox(height: _gap),
          // AC · 0 · . · +
          Row(
            children: [
              _cell(NumpadKey(
                family: NumpadKeyFamily.functionKey,
                label: 'AC',
                height: AppSizes.keyDigitHeight,
                foreground: c.error,
                onPressed: _tap(onClearAll),
              )),
              const SizedBox(width: _gap),
              _cell(_digit('0')),
              const SizedBox(width: _gap),
              _cell(_digit('.')),
              const SizedBox(width: _gap),
              _cell(_operator('+')),
            ],
          ),
          const SizedBox(height: _gap),
          // Commit bar: wide "new line" + an "=" key sitting under the "+".
          Row(
            children: [
              Expanded(
                flex: 3,
                child: NumpadKey(
                  family: NumpadKeyFamily.commit,
                  label: commitLabel,
                  onPressed: _tap(onCommit),
                ),
              ),
              const SizedBox(width: _gap),
              Expanded(
                flex: 1,
                child: NumpadKey(
                  family: NumpadKeyFamily.operatorKey,
                  label: '=',
                  height: AppSizes.keyCommitHeight,
                  onPressed: _tap(onCommit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _digitRow(List<String> digits, String operator) {
    return Row(
      children: [
        for (final d in digits) ...[
          _cell(_digit(d)),
          const SizedBox(width: _gap),
        ],
        _cell(_operator(operator)),
      ],
    );
  }

  NumpadKey _digit(String d) => NumpadKey(
        family: NumpadKeyFamily.digit,
        label: d,
        enabled: numbersEnabled,
        onPressed: _tap(onDigit == null ? null : () => onDigit!(d)),
      );

  NumpadKey _operator(String op) => NumpadKey(
        family: NumpadKeyFamily.operatorKey,
        label: op,
        enabled: operatorsEnabled,
        onPressed: _tap(onOperator == null ? null : () => onOperator!(op)),
      );

  Widget _cell(Widget child) => Expanded(child: child);
}
