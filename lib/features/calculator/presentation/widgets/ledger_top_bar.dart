import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';

/// The calculator's top bar: sheet name (or "مسودّة") + a meta line, with
/// access to history, save and settings.
class LedgerTopBar extends StatelessWidget {
  const LedgerTopBar({
    super.key,
    required this.title,
    required this.themeIcon,
    required this.themeTooltip,
    required this.shareTooltip,
    this.meta,
    this.onTitleTap,
    this.onHistory,
    this.onShare,
    this.onSave,
    this.onThemeToggle,
    this.onSettings,
    this.isSharing = false,
  });

  final String title;
  final String themeIcon;
  final String themeTooltip;
  final String shareTooltip;

  /// e.g. "8 lines · 1,750".
  final String? meta;

  final VoidCallback? onTitleTap;
  final VoidCallback? onHistory;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onThemeToggle;
  final VoidCallback? onSettings;
  final bool isSharing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.appBg,
        border: Border.all(color: c.hairline),
        borderRadius: BorderRadius.circular(AppRadii.key),
      ),
      padding: EdgeInsetsDirectional.only(
        start: AppSpacing.lg,
        end: AppSpacing.sm,
        top: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTitleTap,
              borderRadius: BorderRadius.circular(AppRadii.chip),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.title.copyWith(
                            color: c.textPrimary,
                          ),
                        ),
                        if (meta != null)
                          Text(
                            meta!,
                            style: AppTextStyles.meta.copyWith(
                              color: c.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (onTitleTap != null)
                    AppSvgIcon(
                      AppIcons.chevronDown,
                      size: 16.r,
                      color: c.textMuted,
                    ),
                ],
              ),
            ),
          ),
          _action(c, AppIcons.history, onHistory),
          Semantics(
            button: true,
            label: shareTooltip,
            child: isSharing
                ? _sharingAction(c)
                : _action(c, AppIcons.share, onShare),
          ),
          _action(c, AppIcons.save, onSave, highlighted: true),
          Semantics(
            button: true,
            label: themeTooltip,
            child: _action(c, themeIcon, onThemeToggle),
          ),
          _action(c, AppIcons.settings, onSettings),
        ],
      ),
    );
  }

  Widget _sharingAction(AppColors c) {
    return SizedBox(
      width: 42,
      height: 38,
      child: Center(
        child: SizedBox.square(
          dimension: 17.r,
          child: CircularProgressIndicator(strokeWidth: 1.8, color: c.accent),
        ),
      ),
    );
  }

  Widget _action(
    AppColors c,
    String icon,
    VoidCallback? onTap, {
    bool highlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: highlighted ? c.accentSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(
              child: AppSvgIcon(
                icon,
                size: 20.r,
                color: highlighted ? c.accent : c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
