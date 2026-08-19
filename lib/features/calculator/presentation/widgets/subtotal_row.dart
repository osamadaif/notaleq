import 'package:flutter/material.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';

/// A non-editable checkpoint showing the running total of the rows above it.
class SubtotalRow extends StatelessWidget {
  const SubtotalRow({super.key, required this.label, required this.totalText});

  final String label;
  final String totalText;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.accent, width: 1.5)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              totalText,
              textDirection: TextDirection.ltr,
              style: AppTextStyles.amountSettled.copyWith(
                color: c.accentStrong,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: c.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
