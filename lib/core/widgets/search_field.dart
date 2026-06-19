import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';
import 'app_icons.dart';

/// Rounded search input used on the History screen.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.appBg,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(AppRadii.chip + 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          AppSvgIcon(AppIcons.search, size: 18.r, color: c.textMuted),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.body.copyWith(
                fontSize: 15.sp,
                color: c.textPrimary,
              ),
              cursorColor: c.accent,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: AppSpacing.md),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: AppTextStyles.body
                    .copyWith(fontSize: 15.sp, color: c.textMuted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
