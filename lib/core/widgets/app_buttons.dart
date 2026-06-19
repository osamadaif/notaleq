import 'package:flutter/material.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';

/// Filled accent button — the primary action (e.g. "حفظ").
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// Stretch to the available width (default) or hug the label.
  final bool expand;

  /// Fills with the error color instead of the accent (e.g. AC confirm).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final child = Material(
      color: destructive ? c.error : c.accent,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: AppSizes.minTouchTarget,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            label,
            style: AppTextStyles.button.copyWith(color: c.onAccent),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}

/// Quiet button — the secondary / dismiss action (e.g. "إلغاء").
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.expand = true,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  /// Tints the label with the error color (for destructive confirmations).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final child = Material(
      color: c.surfaceSunken,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          height: AppSizes.minTouchTarget,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            label,
            style: AppTextStyles.button
                .copyWith(color: destructive ? c.error : c.textSecondary),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}
