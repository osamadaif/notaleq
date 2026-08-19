import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/database/app_database.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/format/amount_formatter.dart';
import '../../../../core/format/currencies.dart';
import '../../../../core/format/ledger_amount_formatter.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../calculator/presentation/widgets/ledger_row.dart';
import '../../../calculator/domain/entities/ledger_line.dart';
import '../../../calculator/presentation/widgets/subtotal_row.dart';
import '../../../calculator/presentation/widgets/total_bar.dart';
import '../../../export/data/sheet_export_service.dart';
import '../../../export/domain/sheet_export_document.dart';
import '../../../export/presentation/sheet_export_ui.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../../settings/presentation/cubit/settings_state.dart';
import '../cubit/sheet_detail_cubit.dart';
import '../cubit/sheet_detail_state.dart';

/// Read-only detail of a saved sheet (opened from history). Shows the lines and
/// the saved total — **no numpad, no editing** — so a saved sheet can never be
/// changed by viewing it.
class SheetDetailScreen extends StatelessWidget {
  const SheetDetailScreen({super.key, required this.calculationId});

  final int calculationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SheetDetailCubit>()..load(calculationId),
      child: const _SheetDetailView(),
    );
  }
}

class _SheetDetailView extends StatefulWidget {
  const _SheetDetailView();

  @override
  State<_SheetDetailView> createState() => _SheetDetailViewState();
}

class _SheetDetailViewState extends State<_SheetDetailView> {
  static const AmountFormatter _formatter = AmountFormatter();
  static const LedgerAmountFormatter _ledgerAmounts = LedgerAmountFormatter();

  bool _isExporting = false;

  String _date(int epochMillis) => DateFormat(
    'yyyy/MM/dd · HH:mm',
  ).format(DateTime.fromMillisecondsSinceEpoch(epochMillis));

  String? _currencySymbol(BuildContext context, String? code) =>
      code == null ? null : context.tr(Currencies.symbolKey(code));

  LedgerAmountDisplay _amountDisplay(Line line, int decimalPlaces) =>
      _ledgerAmounts.format(
        rawExpression: line.rawExpression,
        computedAmount: Decimal.tryParse(line.computedValue) ?? Decimal.zero,
        isError: line.isError == 1,
        decimalPlaces: decimalPlaces,
      );

  Future<void> _shareSheet(
    BuildContext context,
    SheetDetailState state,
    SettingsState settings,
    SheetExportFormat format,
  ) async {
    final sheet = state.sheet;
    if (sheet == null || _isExporting) return;
    setState(() => _isExporting = true);
    try {
      final document = _exportDocument(context, state, sheet, settings);
      await getIt<SheetExportService>().share(
        document,
        sheetShareOrigin(context),
        format,
      );
    } on SheetExportException {
      if (context.mounted) _showExportError(context);
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  SheetExportDocument _exportDocument(
    BuildContext context,
    SheetDetailState state,
    Calculation sheet,
    SettingsState settings,
  ) {
    final total = Decimal.tryParse(sheet.cachedTotal) ?? Decimal.zero;
    final viewData = SheetExportViewData(
      title: sheet.name ?? context.tr(LangKeys.draft),
      dateText: DateFormat(
        'yyyy/MM/dd | HH:mm',
      ).format(DateTime.fromMillisecondsSinceEpoch(sheet.updatedAt)),
      totalText: _formatter.format(
        total,
        decimalPlaces: settings.decimalPlaces,
      ),
      lineCount: _contentLineCount(state.lines),
      decimalPlaces: settings.decimalPlaces,
      currency: _currencySymbol(
        context,
        sheet.currencyCode ?? settings.currencyCode,
      ),
    );
    return SheetExportDocument.fromStored(
      state.lines,
      sheetExportRequestOf(context, viewData),
    );
  }

  int _contentLineCount(List<Line> lines) => lines.where((line) {
    if (line.entryType == LedgerLineKind.subtotal.name) return false;
    return line.rawExpression.trim().isNotEmpty ||
        (line.comment?.trim().isNotEmpty ?? false);
  }).length;

  void _showExportError(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(context.tr(LangKeys.exportFailed))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final settings = context.watch<SettingsCubit>().state;
    final dp = settings.decimalPlaces;
    return BlocBuilder<SheetDetailCubit, SheetDetailState>(
      builder: (context, state) {
        final sheet = state.sheet;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: c.appBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              sheet?.name ?? '',
              style: AppTextStyles.title.copyWith(color: c.textPrimary),
            ),
            actions: [
              IconButton(
                tooltip: context.tr(LangKeys.exportImage),
                onPressed: sheet == null || _isExporting
                    ? null
                    : () => _shareSheet(
                        context,
                        state,
                        settings,
                        SheetExportFormat.image,
                      ),
                icon: AppSvgIcon(AppIcons.image, color: c.textSecondary),
              ),
              IconButton(
                tooltip: context.tr(LangKeys.exportPdf),
                onPressed: sheet == null || _isExporting
                    ? null
                    : () => _shareSheet(
                        context,
                        state,
                        settings,
                        SheetExportFormat.pdf,
                      ),
                icon: AppSvgIcon(AppIcons.pdf, color: c.textSecondary),
              ),
              SizedBox(width: AppSpacing.xs),
            ],
          ),
          body: SafeArea(
            top: false,
            child: _body(
              context,
              state,
              sheet,
              dp,
              _currencySymbol(context, settings.currencyCode),
            ),
          ),
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    SheetDetailState state,
    Calculation? sheet,
    int dp,
    String? currency,
  ) {
    final c = context.colors;
    if (state.status == SheetDetailStatus.loading) {
      return Center(child: CircularProgressIndicator(color: c.accent));
    }
    if (state.status == SheetDetailStatus.error || sheet == null) {
      return EmptyState(
        icon: AppIcons.history,
        title: context.tr(LangKeys.emptyHistoryTitle),
        body: context.tr(LangKeys.emptyHistoryBody),
      );
    }

    final total = Decimal.tryParse(sheet.cachedTotal) ?? Decimal.zero;
    return Column(
      children: [
        if (_isExporting)
          LinearProgressIndicator(
            minHeight: 2,
            color: c.accent,
            backgroundColor: c.accentSoft,
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.xs,
            AppSpacing.lg,
            AppSpacing.xs,
          ),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              _date(sheet.updatedAt),
              style: AppTextStyles.meta.copyWith(color: c.textMuted),
            ),
          ),
        ),
        Expanded(child: _ledger(context, state.lines, dp)),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: TotalBar(
            label: context.tr(LangKeys.total),
            totalText: _formatter.format(total, decimalPlaces: dp),
            currency: currency,
          ),
        ),
      ],
    );
  }

  /// The read-only ledger — always LTR, like the editor, but with no tap/edit.
  Widget _ledger(BuildContext context, List<Line> lines, int dp) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final line = lines[index];
          if (line.entryType == LedgerLineKind.subtotal.name) {
            final subtotal =
                Decimal.tryParse(line.computedValue) ?? Decimal.zero;
            return SubtotalRow(
              label: context.tr(LangKeys.subtotal),
              totalText: _formatter.format(subtotal, decimalPlaces: dp),
            );
          }
          final raw = line.rawExpression.trim();
          final hasComment = line.comment?.trim().isNotEmpty ?? false;
          if (raw.isEmpty && hasComment) {
            return LedgerRow.sectionHeader(title: line.comment!);
          }
          final isError = line.isError == 1;
          final display = _amountDisplay(line, dp);
          return LedgerRow(
            amountText: display.text,
            comment: line.comment,
            isNegative: display.isNegative,
            isError: isError,
            excludedLabel: isError ? context.tr(LangKeys.excluded) : null,
            noCommentLabel: context.tr(LangKeys.noComment),
          );
        },
      ),
    );
  }
}
