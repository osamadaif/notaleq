import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/database/app_database.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/format/amount_formatter.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/search_field.dart';
import '../cubit/history_cubit.dart';
import '../cubit/history_state.dart';
import '../widgets/history_list_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HistoryCubit>()..start(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatefulWidget {
  const _HistoryView();

  @override
  State<_HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<_HistoryView> {
  static const AmountFormatter _formatter = AmountFormatter();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _date(int epochMillis) => DateFormat(
    'yyyy/MM/dd · HH:mm',
  ).format(DateTime.fromMillisecondsSinceEpoch(epochMillis));

  Future<void> _delete(BuildContext context, Calculation sheet) async {
    final cubit = context.read<HistoryCubit>();
    final confirmed = await showConfirmDialog(
      context: context,
      title: context.tr(LangKeys.delete),
      body: sheet.name ?? '',
      confirmLabel: context.tr(LangKeys.delete),
      cancelLabel: context.tr(LangKeys.cancel),
      icon: AppIcons.delete,
    );
    if (confirmed) await cubit.delete(sheet.id);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.appBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.tr(LangKeys.history),
          style: AppTextStyles.title.copyWith(color: c.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: SearchField(
              controller: _searchController,
              hint: context.tr(LangKeys.searchHint),
              onChanged: (q) => context.read<HistoryCubit>().search(q),
            ),
          ),
          Expanded(
            child: BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, state) {
                if (state.status == HistoryStatus.loading) {
                  return Center(
                    child: CircularProgressIndicator(color: c.accent),
                  );
                }
                if (state.isEmpty) {
                  return EmptyState(
                    icon: AppIcons.history,
                    title: context.tr(LangKeys.emptyHistoryTitle),
                    body: context.tr(LangKeys.emptyHistoryBody),
                  );
                }
                return ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  itemCount: state.sheets.length,
                  separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final sheet = state.sheets[index];
                    return HistoryListItem(
                      name: sheet.name ?? '',
                      dateText: _date(sheet.updatedAt),
                      totalText: _formatter.format(
                        Decimal.tryParse(sheet.cachedTotal) ?? Decimal.zero,
                      ),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.sheetDetail, arguments: sheet.id),
                      onDelete: () => _delete(context, sheet),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
