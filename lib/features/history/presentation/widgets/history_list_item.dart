import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';

/// A saved sheet in the History list: name + date (start), cached total preview
/// and a delete affordance (end). Tap the row to load it back into the ledger.
class HistoryListItem extends StatelessWidget {
  const HistoryListItem({
    super.key,
    required this.name,
    required this.dateText,
    required this.totalText,
    this.onTap,
    this.onDelete,
  });

  final String name;

  /// Display-formatted date (e.g. `"2026/06/01 · 14:30"`).
  final String dateText;

  /// Display-formatted cached total (e.g. `"1,750"`).
  final String totalText;

  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadii.key),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.key),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: c.hairline),
            borderRadius: BorderRadius.circular(AppRadii.key),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title.copyWith(color: c.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText,
                      style: AppTextStyles.meta.copyWith(
                        fontSize: 12.sp,
                        color: c.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                totalText,
                textDirection: TextDirection.ltr,
                style: AppTextStyles.amountHistory.copyWith(color: c.accent),
              ),
              if (onDelete != null) ...[
                SizedBox(width: AppSpacing.md),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: AppSvgIcon(
                      AppIcons.delete,
                      size: 19.r,
                      color: c.textMuted,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
