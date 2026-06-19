import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';

/// A single row of the ledger. Variants (from the design's `LedgerRow`):
/// normal, negative, active/focused (enlarged), error (flagged & excluded),
/// section-header (comment-only), and amount-only.
///
/// Pure presentation: amounts arrive **already formatted** for display
/// (e.g. `"−3,000"`); money math/formatting lives in the calculator domain.
class LedgerRow extends StatelessWidget {
  /// A value line.
  const LedgerRow({
    super.key,
    required this.amountText,
    this.comment,
    this.isNegative = false,
    this.isActive = false,
    this.isError = false,
    this.excludedLabel,
    this.noCommentLabel = '—',
    this.onTap,
  }) : _isSectionHeader = false,
       _headerTitle = null;

  /// A comment-only section header (contributes 0, excluded from the total).
  const LedgerRow.sectionHeader({
    super.key,
    required String title,
    this.onTap,
  })  : _isSectionHeader = true,
        _headerTitle = title,
        amountText = null,
        comment = null,
        isNegative = false,
        isActive = false,
        isError = false,
        excludedLabel = null,
        noCommentLabel = '—';

  /// Display-formatted amount (null only for a section header).
  final String? amountText;
  final String? comment;
  final bool isNegative;
  final bool isActive;
  final bool isError;

  /// Pill text shown on an error row (e.g. "مُستبعد").
  final String? excludedLabel;

  /// Placeholder shown when a value line has no comment.
  final String noCommentLabel;

  final VoidCallback? onTap;

  final bool _isSectionHeader;
  final String? _headerTitle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (_isSectionHeader) return _sectionHeader(c);

    return _tappable(
      child: Container(
        decoration: BoxDecoration(
          color: isError ? c.errorSoft : Colors.transparent,
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Amount in the first half; the comment begins at the midpoint.
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _amountSide(c),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _commentSide(c),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commentSide(AppColors c) {
    if (isError) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(AppIcons.error, size: 16.r, color: c.error),
          SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              comment ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.comment.copyWith(color: c.textPrimary),
            ),
          ),
        ],
      );
    }

    final hasComment = comment != null && comment!.trim().isNotEmpty;
    if (!hasComment) {
      return Text(
        noCommentLabel,
        style: AppTextStyles.comment
            .copyWith(fontSize: 15.sp, color: c.textMuted),
      );
    }
    return Text(
      comment!,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.comment.copyWith(
        color: isActive ? c.accentStrong : c.textPrimary,
      ),
    );
  }

  Widget _amountSide(AppColors c) {
    if (isError) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (excludedLabel != null) ...[
            _excludedPill(c),
            SizedBox(width: AppSpacing.sm),
          ],
          Text(
            amountText ?? '',
            style: AppTextStyles.amountSettled.copyWith(color: c.error),
          ),
        ],
      );
    }

    final Color amountColor =
        isActive ? c.accentStrong : (isNegative ? c.negative : c.textPrimary);
    final TextStyle style =
        isActive ? AppTextStyles.amountActiveRow : AppTextStyles.amountSettled;

    return Text(
      amountText ?? '',
      textDirection: TextDirection.ltr,
      style: style.copyWith(color: amountColor),
    );
  }

  Widget _excludedPill(AppColors c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border.all(color: c.error.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        excludedLabel!,
        style: AppTextStyles.meta.copyWith(
          fontFamily: AppTextStyles.fontArabic,
          color: c.error,
        ),
      ),
    );
  }

  Widget _sectionHeader(AppColors c) {
    return _tappable(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.hairline)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Text(
          _headerTitle ?? '',
          style: AppTextStyles.sectionHeader.copyWith(color: c.accent),
        ),
      ),
    );
  }

  Widget _tappable({required Widget child}) {
    if (onTap == null) return child;
    return InkWell(onTap: onTap, child: child);
  }
}
