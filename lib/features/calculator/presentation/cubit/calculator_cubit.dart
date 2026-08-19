import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repos/calculator_repository.dart';
import '../../domain/entities/ledger_line.dart';
import '../../domain/expression_input.dart';
import '../../domain/ledger_totals.dart';
import '../../domain/parser/expression_evaluator.dart';
import 'calculator_state.dart';

/// Drives the ledger editor: holds the lines in memory, evaluates the active
/// line live, keeps the running total, and persists the draft on every change.
class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit(this._repo) : super(const CalculatorState());

  final CalculatorRepository _repo;
  static const ExpressionEvaluator _evaluator = ExpressionEvaluator();

  Future<void> load() async {
    emit(state.copyWith(status: CalcStatus.loading));
    final result = await _repo.loadActiveSheet();
    result.match(
      (failure) => emit(
        state.copyWith(
          status: CalcStatus.failure,
          failureMessage: failure.message,
        ),
      ),
      (sheet) {
        var lines = sheet.lines.map(_restoreLine).toList();
        lines = LedgerTotals.refreshSubtotals(lines);
        if (lines.isEmpty) lines.add(LedgerLine.empty());
        if (lines.last.isSubtotal) lines.add(LedgerLine.empty());
        // Build the state fresh so nullable fields (sheetName/currencyCode)
        // reset cleanly — e.g. a fresh draft after a named sheet. The transient
        // operator-notice tick is preserved so it doesn't fire a spurious notice.
        emit(
          CalculatorState(
            status: CalcStatus.ready,
            calculationId: sheet.calculation.id,
            sheetName: sheet.calculation.name,
            currencyCode: sheet.calculation.currencyCode,
            lines: lines,
            activeIndex: lines.length - 1,
            operatorNoticeTick: state.operatorNoticeTick,
          ),
        );
      },
    );
  }

  // --- Numpad input (amount) ---

  void inputDigit(String digit) {
    if (_rejectLeadingNonOperator()) return;
    _editActiveRaw((raw) => ExpressionInput.appendDigit(raw, digit));
  }

  void inputOperator(String op) {
    final active = state.activeLine;
    if (active == null) return;
    if (_blocksLeadingMulDiv(active, op)) return;
    if (_replacesTrailingMulDivWithAddSub(active, op)) {
      _settleTrailingMulDivAndDescend(active, op);
      return;
    }
    if (active.rawExpression.isEmpty ||
        ExpressionInput.endsWithOperator(active.rawExpression)) {
      _editActiveRaw((raw) => ExpressionInput.appendOperator(raw, op));
      return;
    }
    if (_isAddSub(op)) {
      _inputAddSub(active, op);
      return;
    }
    if (ExpressionInput.atOperatorCap(active.rawExpression)) {
      if (!active.isError) _commitWithLeadingOperator(op);
      return;
    }
    _editActiveRaw((raw) => ExpressionInput.appendOperator(raw, op));
  }

  /// A multiply/divide key (in either glyph or ASCII form).
  static bool _isMulDiv(String op) =>
      op == '×' || op == '*' || op == '÷' || op == '/';

  static bool _isAddSub(String op) => op == '+' || op == '-' || op == '−';

  bool _blocksLeadingMulDiv(LedgerLine active, String op) =>
      active.rawExpression.isEmpty &&
      !state.requiresLeadingOperator &&
      _isMulDiv(op);

  bool _replacesTrailingMulDivWithAddSub(LedgerLine active, String op) {
    final raw = active.rawExpression;
    return raw.length > 1 && _isAddSub(op) && _isMulDiv(raw[raw.length - 1]);
  }

  void _settleTrailingMulDivAndDescend(LedgerLine active, String op) {
    final prefix = active.rawExpression.substring(
      0,
      active.rawExpression.length - 1,
    );
    final settled = _evaluate(prefix, active.comment);
    if (settled.isError) {
      _editActiveRaw((raw) => ExpressionInput.appendOperator(raw, op));
      return;
    }
    _insertAfterSettledLine(settled, op);
  }

  void _insertAfterSettledLine(LedgerLine settled, String op) {
    final lines = [...state.lines];
    lines[state.activeIndex] = settled;
    final nextIndex = state.activeIndex + 1;
    final leadingOperator = ExpressionInput.appendOperator('', op);
    lines.insert(nextIndex, _evaluate(leadingOperator, null));
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: nextIndex,
        commentEditing: false,
      ),
    );
    _persist();
  }

  void _inputAddSub(LedgerLine active, String op) {
    if (active.isError) {
      _editActiveRaw((raw) => ExpressionInput.appendOperator(raw, op));
    } else {
      _commitWithLeadingOperator(op);
    }
  }

  void inputParen(String paren) {
    if (_rejectLeadingNonOperator()) return;
    _editActiveRaw((raw) => ExpressionInput.appendParen(raw, paren));
  }

  void inputPercent() {
    if (_rejectLeadingNonOperator()) return;
    _editActiveRaw(ExpressionInput.appendPercent);
  }

  /// Returns true (and raises a quick notice) when a non-operator key is pressed
  /// on a line that must still begin with an operator.
  bool _rejectLeadingNonOperator() {
    if (!state.requiresLeadingOperator) return false;
    emit(state.copyWith(operatorNoticeTick: state.operatorNoticeTick + 1));
    return true;
  }

  /// `=` — records the current running total, then opens a continuation line.
  void insertSubtotal() {
    if (!canCommit) return;
    final nextIndex = state.activeIndex + 1;
    if (nextIndex < state.lines.length && state.lines[nextIndex].isSubtotal) {
      return;
    }
    final lines = [...state.lines]
      ..insert(nextIndex, LedgerLine.subtotal(state.total))
      ..insert(nextIndex + 1, LedgerLine.empty());
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: nextIndex + 1,
        commentEditing: false,
      ),
    );
    _persist();
  }

  void _commitWithLeadingOperator(String op) {
    final lines = [...state.lines]
      ..insert(state.activeIndex + 1, LedgerLine.empty());
    final newIndex = state.activeIndex + 1;
    lines[newIndex] = _evaluate(ExpressionInput.appendOperator('', op), null);
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: newIndex,
        commentEditing: false,
      ),
    );
    _persist();
  }

  void backspace() {
    final active = state.activeLine;
    if (active == null) return;
    final raw = active.rawExpression;

    if (raw.isEmpty) {
      // Already empty: drop the blank line and step up to the previous one.
      if (active.isBlank && state.activeIndex > 0) {
        if (state.lines[state.activeIndex - 1].isSubtotal) {
          _removeActiveAndSubtotal();
        } else {
          _removeActiveAndStepUp();
        }
      }
      return;
    }

    final next = ExpressionInput.backspace(raw);
    // Deleting the leading operator empties a non-first line → delete the whole
    // line and step up (each line is independent).
    if (next.isEmpty && state.activeIndex > 0) {
      _removeActiveAndStepUp();
      return;
    }
    _replaceActive(_evaluate(next, active.comment));
  }

  void _removeActiveAndStepUp() {
    final lines = [...state.lines]..removeAt(state.activeIndex);
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: state.activeIndex - 1,
        commentEditing: false,
      ),
    );
    _persist();
  }

  void _removeActiveAndSubtotal() {
    final lines = [...state.lines]
      ..removeAt(state.activeIndex)
      ..removeAt(state.activeIndex - 1);
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: state.activeIndex - 2,
        commentEditing: false,
      ),
    );
    _persist();
  }

  /// C — clear the active line's expression (keeps its comment).
  void clearActive() {
    final active = state.activeLine;
    if (active == null) return;
    _replaceActive(_evaluate('', active.comment));
  }

  /// AC — clear the whole sheet (after the caller's confirmation).
  Future<void> clearAll() async {
    emit(
      state.copyWith(
        lines: [LedgerLine.empty()],
        activeIndex: 0,
        commentEditing: false,
      ),
    );
    final id = state.calculationId;
    if (id != null) await _repo.clearLines(id);
  }

  /// ↵ / tap-below / comment-return — commit the active line and descend.
  /// Blocked while the line is incomplete (SCHEMA §5).
  void commit() {
    final active = state.activeLine;
    if (active == null) return;
    // A comment with no amount isn't kept: discard it and stay on a fresh line.
    if (active.hasComment && !active.hasExpression) {
      _replaceActive(LedgerLine.empty());
      return;
    }
    if (!canCommit) return;
    final lines = [...state.lines]
      ..insert(state.activeIndex + 1, LedgerLine.empty());
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: state.activeIndex + 1,
        commentEditing: false,
      ),
    );
    _persist();
  }

  /// True when the active line carries a valid expression.
  bool get canCommit {
    final active = state.activeLine;
    if (active == null) return false;
    if (active.rawExpression.trim().isEmpty) return false;
    return !active.isError;
  }

  // --- Focus / selection ---

  /// Focuses another line. Leaving a blank line removes it, so at most one
  /// empty line (the active trailing one) ever exists.
  void setActive(int index) {
    if (index < 0 || index >= state.lines.length) return;
    if (state.lines[index].isSubtotal) return;
    if (index == state.activeIndex) {
      emit(state.copyWith(commentEditing: false));
      return;
    }
    // A comment with no amount must be resolved first — can't focus away from it.
    final activeLine = state.activeLine;
    if (activeLine != null &&
        activeLine.hasComment &&
        !activeLine.hasExpression) {
      return;
    }
    final lines = [...state.lines];
    var target = index;
    final current = state.activeIndex;
    if (current >= 0 && current < lines.length && lines[current].isBlank) {
      lines.removeAt(current);
      if (current < target) target -= 1;
    }
    emit(
      state.copyWith(
        lines: LedgerTotals.refreshSubtotals(lines),
        activeIndex: target,
        commentEditing: false,
      ),
    );
    _persist();
  }

  void startCommentEditing() => emit(state.copyWith(commentEditing: true));
  void stopCommentEditing() => emit(state.copyWith(commentEditing: false));

  /// Comment editing (system keyboard).
  void updateComment(String text) {
    final active = state.activeLine;
    if (active == null) return;
    _replaceActive(active.copyWith(comment: text.isEmpty ? null : text));
  }

  // --- Save ---

  Future<void> save(String name) async {
    final id = state.calculationId;
    if (id == null) return;
    final persistError = await _persistCurrentState(id);
    if (persistError != null) {
      emit(state.copyWith(failureMessage: persistError));
      return;
    }
    final result = await _repo.saveAs(id, name);
    final error = result.fold((f) => f.message, (_) => null);
    if (error != null) {
      emit(state.copyWith(failureMessage: error));
      return;
    }
    // After saving, start a fresh empty draft ready for new entry.
    await _repo.startNewDraft();
    await load();
  }

  Future<String?> _persistCurrentState(int calculationId) async {
    final persisted = await _repo.persist(
      calculationId: calculationId,
      lines: state.lines,
      total: state.total,
    );
    return persisted.fold((failure) => failure.message, (_) => null);
  }

  // --- internals ---

  void _editActiveRaw(String Function(String raw) transform) {
    final active = state.activeLine;
    if (active == null) return;
    final next = transform(active.rawExpression);
    if (next == active.rawExpression) return;
    _replaceActive(_evaluate(next, active.comment));
  }

  void _replaceActive(LedgerLine line) {
    final lines = [...state.lines];
    lines[state.activeIndex] = line;
    emit(state.copyWith(lines: LedgerTotals.refreshSubtotals(lines)));
    _persist();
  }

  LedgerLine _restoreLine(Line line) {
    if (line.entryType == LedgerLineKind.subtotal.name) {
      return LedgerLine.subtotal(
        Decimal.tryParse(line.computedValue) ?? Decimal.zero,
      );
    }
    return _evaluate(line.rawExpression, line.comment);
  }

  LedgerLine _evaluate(String raw, String? comment) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return LedgerLine(
        rawExpression: '',
        comment: comment,
        computedValue: Decimal.zero,
      );
    }

    // A leading × / ÷ joins this line to the running total; everything else is
    // an added signed value. The operand is whatever follows the join.
    final first = trimmed[0];
    LedgerJoin join;
    String operandExpr;
    if (first == '*' || first == '×') {
      join = LedgerJoin.mul;
      operandExpr = trimmed.substring(1);
    } else if (first == '/' || first == '÷') {
      join = LedgerJoin.div;
      operandExpr = trimmed.substring(1);
    } else {
      join = LedgerJoin.add;
      operandExpr = trimmed;
    }

    final result = _evaluator.evaluate(operandExpr);
    var isError = result.isError;
    var errorKind = result.error;
    if (join == LedgerJoin.div && result.isOk && result.value == Decimal.zero) {
      isError = true;
      errorKind = ExpressionErrorKind.divisionByZero;
    }

    return LedgerLine(
      rawExpression: raw,
      comment: comment,
      join: join,
      computedValue: result.value,
      isError: isError,
      errorKind: errorKind,
    );
  }

  void _persist() {
    final id = state.calculationId;
    if (id == null) return;
    unawaited(
      _repo.persist(calculationId: id, lines: state.lines, total: state.total),
    );
  }
}
