import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';
import 'app_buttons.dart';
import 'app_icons.dart';

/// Destructive confirmation dialog — the guard before wiping the whole sheet
/// (AC). Returns `true` when the user confirms.
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  String icon = AppIcons.error,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      icon: icon,
    ),
  );
  return result ?? false;
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.cancelLabel,
    this.icon = AppIcons.error,
  });

  final String title;
  final String body;
  final String confirmLabel;
  final String cancelLabel;

  /// An [AppIcons] SVG asset path.
  final String icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // The tinted background hugs the icon only (a centered 48×48 chip),
            // not the full dialog width — the Column stretches its children, so
            // the box is wrapped in an Align to keep its own size.
            Align(
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c.errorSoft,
                  borderRadius: BorderRadius.circular(AppRadii.chip),
                ),
                alignment: Alignment.center,
                child: AppSvgIcon(icon, color: c.error, size: 24.r),
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                title,
                style: AppTextStyles.title.copyWith(
                  fontSize: 18.sp,
                  color: c.textPrimary,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: AppTextStyles.helper.copyWith(color: c.textSecondary),
            ),
            SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: PrimaryButton(
                    label: confirmLabel,
                    destructive: true,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
