import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';

/// Settings row with a −/value/+ stepper (e.g. "الخانات العشرية", default 2).
class StepperRow extends StatelessWidget {
  const StepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 6,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(color: c.textPrimary),
            ),
          ),
          _StepButton(
            glyph: '−',
            background: c.surfaceSunken,
            foreground: c.textSecondary,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(width: AppSpacing.md),
          SizedBox(
            width: 18,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTextStyles.amountSettled.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: c.textPrimary,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          _StepButton(
            glyph: '+',
            background: c.accentSoft,
            foreground: c.accent,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.glyph,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String glyph;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.chip - 2),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.chip - 2),
          child: SizedBox(
            width: 32,
            height: 32,
            child: Center(
              child: Text(
                glyph,
                style: AppTextStyles.keyFunction.copyWith(color: foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
