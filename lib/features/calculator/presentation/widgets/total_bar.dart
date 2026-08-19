import 'package:flutter/material.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';

/// The sticky live total — sits directly above the numpad, never scrolls away.
class TotalBar extends StatelessWidget {
  const TotalBar({
    super.key,
    required this.label,
    required this.totalText,
    this.currency,
  });

  final String label;

  /// Display-formatted total (e.g. `"1,750"`).
  final String totalText;

  /// Optional currency suffix (e.g. `"ج.م"`).
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.appBg,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppElevation.totalBarLip,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md - 1,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          // The total shrinks to fit the remaining width instead of overflowing.
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    totalText,
                    style: AppTextStyles.totalBar.copyWith(color: c.accent),
                  ),
                  if (currency != null) ...[
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      currency!,
                      style: AppTextStyles.currency.copyWith(
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
