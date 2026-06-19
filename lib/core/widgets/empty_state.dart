import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';
import 'app_icons.dart';

/// Centered empty-state treatment: a soft accent glyph tile, a title, and a
/// helper line. Used for the empty draft and the empty history.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
  });

  /// An [AppIcons] SVG asset path.
  final String icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: c.accentSoft,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: AppSvgIcon(icon, size: 30.r, color: c.accent),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyTitle.copyWith(color: c.textPrimary),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppTextStyles.helper.copyWith(color: c.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
