import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/di/injection_container.dart';
import '../../../../core/format/amount_formatter.dart';
import '../../../../core/format/currencies.dart';
import '../../../../core/language/app_localizations.dart';
import '../../../../core/language/language_keys.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_dimens.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
import '../../domain/entities/ledger_line.dart';
import '../cubit/calculator_cubit.dart';
import '../cubit/calculator_state.dart';
import '../widgets/ledger_row.dart';
import '../widgets/ledger_top_bar.dart';
import '../widgets/numpad.dart';
import '../widgets/save_sheet_form.dart';
import '../widgets/total_bar.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CalculatorCubit>()..load(),
      child: const _CalculatorView(),
    );
  }
}

class _CalculatorView extends StatefulWidget {
  const _CalculatorView();

  @override
  State<_CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<_CalculatorView> {
  static const AmountFormatter _formatter = AmountFormatter();

  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _lastOperatorNoticeTick = 0;
  int _lastLineCount = 0;
  int _lastActiveIndex = -1;
  bool _lastCommentEditing = false;

  @override
  void initState() {
    super.initState();
    _commentFocus.addListener(() {
      final cubit = context.read<CalculatorCubit>();
      if (_commentFocus.hasFocus) {
        cubit.startCommentEditing();
      } else {
        cubit.stopCommentEditing();
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Keeps the newest line in view (chat-style) when it's the last line.
  void _scrollToBottomIfAtEnd(CalculatorState state) {
    if (state.activeIndex != state.lines.length - 1) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppMotion.lineCommit,
          curve: Curves.easeOut,
        );
      }
    });
  }

  String? _currencySymbol(BuildContext context, String? code) =>
      code == null ? null : context.tr(Currencies.symbolKey(code));

  /// Settled-line amount: the operand prefixed by its join (+ / − / × / ÷). The
  /// first/base line (no leading operator) shows the bare value.
  String _settledAmount(LedgerLine line, int decimalPlaces) {
    // An excluded (error) line shows what was typed — not its zeroed value —
    // next to the "excluded" pill, so the user can see what failed.
    if (line.isHardError) {
      return _formatter.formatExpression(line.rawExpression);
    }
    final value = _formatter.format(
      line.computedValue,
      decimalPlaces: decimalPlaces,
    );
    switch (line.join) {
      case LedgerJoin.mul:
        return '×$value';
      case LedgerJoin.div:
        return '÷$value';
      case LedgerJoin.add:
        // A subsequent add line begins with a + / − join — show that sign like
        // the other operators. Negatives already carry the − glyph; only a
        // non-negative join line needs an explicit leading +.
        final lead = line.rawExpression.trimLeft();
        final isJoinLine = lead.isNotEmpty &&
            (lead[0] == '+' || lead[0] == '-' || lead[0] == '−');
        if (isJoinLine && line.computedValue >= Decimal.zero) {
          return '+$value';
        }
        return value;
    }
  }

  Future<void> _onSave(BuildContext context, CalculatorState state) async {
    final cubit = context.read<CalculatorCubit>();
    // Only allow saving a sheet that has at least one valid amount.
    if (!state.lines.any((l) => l.countsTowardTotal)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.tr(LangKeys.saveNeedsAmount))),
        );
      return;
    }
    final defaultName = state.isDraft
        ? DateFormat('yyyy/MM/dd · HH:mm').format(DateTime.now())
        : state.sheetName!;
    final name = await showSaveSheet(context, initialName: defaultName);
    if (name != null) await cubit.save(name);
  }

  Future<void> _onClearAll(BuildContext context) async {
    final cubit = context.read<CalculatorCubit>();
    final confirmed = await showConfirmDialog(
      context: context,
      title: context.tr(LangKeys.clearAllTitle),
      body: context.tr(LangKeys.clearAllBody),
      confirmLabel: context.tr(LangKeys.clearAll),
      cancelLabel: context.tr(LangKeys.cancel),
    );
    if (confirmed) await cubit.clearAll();
  }

  /// History is **view-only**: tapping a saved sheet opens its read-only detail
  /// (inside the history stack). The editor keeps working on its own draft and
  /// is never repointed at a saved sheet, so saved sheets can't be overwritten.
  void _onHistory(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.history);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      // We swap the numpad for the system keyboard ourselves (the bottom slot
      // below), so the Scaffold must NOT also resize for the keyboard. If it
      // did, the two would fight: the body's bottom inset would read 0, and a
      // frame of the open/close animation would render the numpad inside an
      // already-shrunk viewport → a RenderFlex overflow. With resize off the
      // body keeps full height and we reserve the keyboard's space explicitly.
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<CalculatorCubit, CalculatorState>(
          listenWhen: (prev, next) =>
              prev.activeIndex != next.activeIndex ||
              prev.lines.length != next.lines.length ||
              prev.activeLine?.comment != next.activeLine?.comment ||
              prev.commentEditing != next.commentEditing ||
              prev.operatorNoticeTick != next.operatorNoticeTick ||
              prev.failureMessage != next.failureMessage,
          listener: (context, state) {
            final comment = state.activeLine?.comment ?? '';
            // The comment field uses one shared controller. When the *active
            // line* changes (e.g. committing a new line) the controller must
            // follow it even while it still has focus — otherwise the previous
            // line's comment bleeds into the new one. When the same line's
            // comment changes externally, only sync while unfocused so we don't
            // disrupt the user's own typing.
            if (state.activeIndex != _lastActiveIndex) {
              _lastActiveIndex = state.activeIndex;
              if (_commentController.text != comment) {
                _commentController.value = TextEditingValue(
                  text: comment,
                  selection: TextSelection.collapsed(offset: comment.length),
                );
              }
            } else if (!_commentFocus.hasFocus &&
                _commentController.text != comment) {
              _commentController.text = comment;
            }
            // Chat-style: jump to the newest line only when a line is added.
            if (state.lines.length > _lastLineCount) {
              _scrollToBottomIfAtEnd(state);
            }
            _lastLineCount = state.lines.length;
            // Keep the line being commented visible above the keyboard.
            if (state.commentEditing && !_lastCommentEditing) {
              _scrollToBottomIfAtEnd(state);
            }
            _lastCommentEditing = state.commentEditing;
            if (state.operatorNoticeTick != _lastOperatorNoticeTick) {
              _lastOperatorNoticeTick = state.operatorNoticeTick;
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    duration: const Duration(milliseconds: 1200),
                    content: Text(context.tr(LangKeys.needsOperatorFirst)),
                  ),
                );
            }
          },
          builder: (context, state) {
            if (state.status == CalcStatus.loading) {
              return Center(child: CircularProgressIndicator(color: c.accent));
            }
            final cubit = context.read<CalculatorCubit>();
            final settings = context.watch<SettingsCubit>().state;
            final dp = settings.decimalPlaces;
            // The running total walks every line — compute (and format) it once
            // per build and share it between the top bar and the total bar.
            final totalText = _formatter.format(state.total, decimalPlaces: dp);
            // True keyboard height (readable because the Scaffold no longer
            // hides the inset). Rebuilds each animation frame so the spacer
            // tracks the keyboard smoothly.
            final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: LedgerTopBar(
                    title: state.isDraft
                        ? context.tr(LangKeys.draft)
                        : state.sheetName!,
                    meta: '${state.contentLineCount} · $totalText',
                    onHistory: () => _onHistory(context),
                    onSave: () => _onSave(context, state),
                    onSettings: () =>
                        Navigator.of(context).pushNamed(AppRoutes.settings),
                  ),
                ),
                Expanded(child: _ledger(context, state, cubit, dp)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: TotalBar(
                    label: context.tr(LangKeys.total),
                    totalText: totalText,
                    currency: _currencySymbol(context, settings.currencyCode),
                  ),
                ),
                // Bottom slot: either the custom numpad, or — while a comment is
                // being edited or the keyboard is still animating — a spacer the
                // exact height of the keyboard, so the total bar + active line
                // rest just above it. Gating on BOTH the focus flag and the live
                // inset means the numpad never pops back on top of a closing
                // keyboard (it returns only once the inset is fully gone).
                // The numpad itself is always LTR regardless of the app's RTL.
                if (state.commentEditing || keyboardInset > 0)
                  SizedBox(height: keyboardInset)
                else
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Numpad(
                      commitLabel: context.tr(LangKeys.newLine),
                      hapticEnabled: settings.hapticEnabled,
                      soundEnabled: settings.soundEnabled,
                      numbersEnabled: !state.requiresLeadingOperator,
                      onDigit: cubit.inputDigit,
                      onOperator: cubit.inputOperator,
                      onParen: cubit.inputParen,
                      onPercent: cubit.inputPercent,
                      onBackspace: cubit.backspace,
                      onClearAll: () => _onClearAll(context),
                      onCommit: cubit.commit,
                      // "=" doesn't add a line (the total is live); it just
                      // blurs the active row so the sheet reads as a settled
                      // result. The next edit or tap re-engages it.
                      onEquals: cubit.unfocus,
                      onCommentJump: () {
                        // Toggle between the comment (system keyboard) and the
                        // amount (numpad).
                        if (_commentFocus.hasFocus) {
                          _commentFocus.unfocus();
                        } else {
                          _commentFocus.requestFocus();
                        }
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _ledger(
    BuildContext context,
    CalculatorState state,
    CalculatorCubit cubit,
    int decimalPlaces,
  ) {
    final onlyEmptyDraft = state.lines.length == 1 && state.lines.first.isBlank;

    // The ledger is always LTR: amount + operator at the start, comment in the
    // second half. (The total bar and top bar stay RTL.)
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: cubit.commit,
        child: ListView.builder(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: state.lines.length + (onlyEmptyDraft ? 1 : 0),
          itemBuilder: (context, index) {
            if (onlyEmptyDraft && index == 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 48),
                child: EmptyState(
                  icon: AppIcons.emptyLedger,
                  title: context.tr(LangKeys.emptyDraftTitle),
                  body: context.tr(LangKeys.emptyDraftBody),
                ),
              );
            }
            final line = state.lines[index];
            // After `=` the active line is blurred: nothing renders as the
            // enlarged active row.
            final active = index == state.activeIndex && state.focused;
            if (active) {
              return _ActiveLine(
                line: line,
                formatter: _formatter,
                commentController: _commentController,
                commentFocus: _commentFocus,
                onCommentChanged: cubit.updateComment,
                onCommentSubmitted: (_) {
                  cubit.commit();
                  _commentFocus.unfocus();
                },
                onAmountTap: () => _commentFocus.unfocus(),
              );
            }
            // A blank line is only ever the (now blurred) trailing active line —
            // hide it instead of rendering a stray "0" row.
            if (line.isBlank) return const SizedBox.shrink();
            if (line.isSectionHeader) {
              return LedgerRow.sectionHeader(
                title: line.comment!,
                onTap: () => cubit.setActive(index),
              );
            }
            return LedgerRow(
              amountText: _settledAmount(line, decimalPlaces),
              comment: line.comment,
              isNegative:
                  line.join == LedgerJoin.add &&
                  line.computedValue < Decimal.zero,
              isError: line.isHardError,
              excludedLabel: line.isHardError
                  ? context.tr(LangKeys.excluded)
                  : null,
              noCommentLabel: context.tr(LangKeys.noComment),
              onTap: () => cubit.setActive(index),
            );
          },
        ),
      ),
    );
  }
}

/// The active (being-edited) ledger row: editable comment + the enlarged,
/// live-formatted amount with an accent caret.
class _ActiveLine extends StatelessWidget {
  const _ActiveLine({
    required this.line,
    required this.formatter,
    required this.commentController,
    required this.commentFocus,
    required this.onCommentChanged,
    required this.onCommentSubmitted,
    required this.onAmountTap,
  });

  final LedgerLine line;
  final AmountFormatter formatter;
  final TextEditingController commentController;
  final FocusNode commentFocus;
  final ValueChanged<String> onCommentChanged;
  final ValueChanged<String> onCommentSubmitted;
  final VoidCallback onAmountTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final amountColor = line.isHardError ? c.error : c.accentStrong;
    return Container(
      decoration: BoxDecoration(
        color: c.activeRowBg,
        border: Border(bottom: BorderSide(color: c.hairline)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: c.accent),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Amount in the first half (start of the line).
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: onAmountTap,
                        behavior: HitTestBehavior.opaque,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: formatter.formatExpression(
                                    line.rawExpression,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    width: 2,
                                    height: 22,
                                    margin: const EdgeInsets.only(left: 3),
                                    decoration: BoxDecoration(
                                      color: c.accent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            style: AppTextStyles.amountActiveRow.copyWith(
                              color: amountColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    // Comment in the second half (begins at the midpoint).
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: commentController,
                        focusNode: commentFocus,
                        onChanged: onCommentChanged,
                        onSubmitted: onCommentSubmitted,
                        textInputAction: TextInputAction.next,
                        cursorColor: c.accent,
                        style: AppTextStyles.comment.copyWith(
                          color: c.accentStrong,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: context.tr(LangKeys.commentHint),
                          hintStyle: AppTextStyles.comment.copyWith(
                            color: c.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
