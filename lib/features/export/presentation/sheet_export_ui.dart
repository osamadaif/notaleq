import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/language/app_localizations.dart';
import '../../../core/language/language_keys.dart';
import '../../../core/style/app_colors.dart';
import '../../../core/style/app_dimens.dart';
import '../../../core/style/app_text_styles.dart';
import '../../../core/widgets/app_bottom_sheet.dart';
import '../../../core/widgets/app_icons.dart';
import '../domain/sheet_export_document.dart';

class SheetExportViewData {
  const SheetExportViewData({
    required this.title,
    required this.dateText,
    required this.totalText,
    required this.lineCount,
    required this.decimalPlaces,
    this.currency,
  });

  final String title;
  final String dateText;
  final String totalText;
  final int lineCount;
  final int decimalPlaces;
  final String? currency;
}

SheetExportRequest sheetExportRequestOf(
  BuildContext context,
  SheetExportViewData viewData,
) {
  return SheetExportRequest(
    identity: _identityOf(context, viewData),
    summary: _summaryOf(context, viewData),
    labels: _labelsOf(context),
    decimalPlaces: viewData.decimalPlaces,
  );
}

SheetExportIdentity _identityOf(
  BuildContext context,
  SheetExportViewData viewData,
) => SheetExportIdentity(
  brand: context.tr(LangKeys.appName),
  title: viewData.title,
  dateText: viewData.dateText,
  isRtl: Directionality.of(context) == TextDirection.rtl,
);

SheetExportSummary _summaryOf(
  BuildContext context,
  SheetExportViewData viewData,
) => SheetExportSummary(
  lineCountText: context.tr(
    LangKeys.linesCount,
    params: {'count': viewData.lineCount.toString()},
  ),
  totalText: viewData.totalText,
  currency: viewData.currency,
);

SheetExportLabels _labelsOf(BuildContext context) => SheetExportLabels(
  operation: context.tr(LangKeys.operation),
  details: context.tr(LangKeys.details),
  total: context.tr(LangKeys.total),
  subtotal: context.tr(LangKeys.subtotal),
  excluded: context.tr(LangKeys.excluded),
  page: context.tr(LangKeys.page),
  createdWith: context.tr(LangKeys.createdWith),
);

Rect sheetShareOrigin(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return Rect.fromLTWH(0, 0, size.width, size.height);
}

Future<SheetExportFormat?> showSheetExportOptions(BuildContext context) {
  return showAppBottomSheet<SheetExportFormat>(
    context: context,
    title: context.tr(LangKeys.shareSheet),
    builder: (sheetContext) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ExportFormatTile(
          icon: AppIcons.image,
          title: sheetContext.tr(LangKeys.exportImage),
          subtitle: sheetContext.tr(LangKeys.exportImageHint),
          onTap: () => Navigator.pop(sheetContext, SheetExportFormat.image),
        ),
        SizedBox(height: AppSpacing.sm),
        _ExportFormatTile(
          icon: AppIcons.pdf,
          title: sheetContext.tr(LangKeys.exportPdf),
          subtitle: sheetContext.tr(LangKeys.exportPdfHint),
          onTap: () => Navigator.pop(sheetContext, SheetExportFormat.pdf),
        ),
      ],
    ),
  );
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surfaceSunken,
      borderRadius: BorderRadius.circular(AppRadii.key),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.key),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              _iconBox(c),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _labels(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBox(AppColors c) => Container(
    width: 44.r,
    height: 44.r,
    decoration: BoxDecoration(
      color: c.accentSoft,
      borderRadius: BorderRadius.circular(AppRadii.chip),
    ),
    child: Center(
      child: AppSvgIcon(icon, size: 23.r, color: c.accent),
    ),
  );

  Widget _labels(AppColors c) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.button.copyWith(color: c.textPrimary)),
      SizedBox(height: AppSpacing.xs),
      Text(
        subtitle,
        style: AppTextStyles.helper.copyWith(
          color: c.textSecondary,
          fontSize: 12.sp,
          height: 1.35,
        ),
      ),
    ],
  );
}
