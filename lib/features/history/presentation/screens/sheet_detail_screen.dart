import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/database/app_database.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/format/amount_formatter.dart';
import '../../../../core/format/currencies.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../calculator/presentation/widgets/ledger_row.dart';
import '../../../calculator/presentation/widgets/total_bar.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
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

class _SheetDetailView extends StatelessWidget {
  const _SheetDetailView();

  static const AmountFormatter _formatter = AmountFormatter();

  String _date(int epochMillis) => DateFormat('yyyy/MM/dd · HH:mm')
      .format(DateTime.fromMillisecondsSinceEpoch(epochMillis));

  String? _currencySymbol(BuildContext context, String? code) =>
      code == null ? null : context.tr(Currencies.symbolKey(code));

  /// Settled-line amount: the operand prefixed by its join (+ / − / × / ÷).
  /// Mirrors the editor's display.
  ({String amount, bool isNegative}) _amountDisplay(Line line, int dp) {
    // An excluded (error) line shows what was typed — not its zeroed value —
    // mirroring the editor.
    if (line.isError == 1) {
      return (
        amount: _formatter.formatExpression(line.rawExpression),
        isNegative: false,
      );
    }
    final value = Decimal.tryParse(line.computedValue) ?? Decimal.zero;
    final raw = line.rawExpression.trim();
    final first = raw.isEmpty ? '' : raw[0];
    final formatted = _formatter.format(value, decimalPlaces: dp);
    if (first == '*' || first == '×') {
      return (amount: '×$formatted', isNegative: false);
    }
    if (first == '/' || first == '÷') {
      return (amount: '÷$formatted', isNegative: false);
    }
    // A subsequent add line begins with a + / − join — show that sign. The
    // first/base line (starts with a digit/paren) shows the bare value.
    final isJoinLine = first == '+' || first == '-' || first == '−';
    if (isJoinLine && value >= Decimal.zero) {
      return (amount: '+$formatted', isNegative: false);
    }
    return (amount: formatted, isNegative: value < Decimal.zero);
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
          ),
          body: SafeArea(
            top: false,
            child: _body(context, state, sheet, dp,
                _currencySymbol(context, settings.currencyCode)),
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
        Padding(
          padding: EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xs),
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
              AppSpacing.md, 0, AppSpacing.md, AppSpacing.sm),
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
          final raw = line.rawExpression.trim();
          final hasComment = line.comment?.trim().isNotEmpty ?? false;
          if (raw.isEmpty && hasComment) {
            return LedgerRow.sectionHeader(title: line.comment!);
          }
          final isError = line.isError == 1;
          final display = _amountDisplay(line, dp);
          return LedgerRow(
            amountText: display.amount,
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
