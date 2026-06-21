import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/calculator_repository.dart';
import '../../domain/entities/ledger_line.dart';
import '../../domain/expression_input.dart';
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
      (failure) => emit(state.copyWith(
        status: CalcStatus.failure,
        failureMessage: failure.message,
      )),
      (sheet) {
        final lines = sheet.lines
            .map((l) => _evaluate(l.rawExpression, l.comment))
            .toList();
        if (lines.isEmpty) lines.add(LedgerLine.empty());
        // Build the state fresh so nullable fields (sheetName/currencyCode)
        // reset cleanly — e.g. a fresh draft after a named sheet. The transient
        // operator-notice tick is preserved so it doesn't fire a spurious notice.
        emit(CalculatorState(
          status: CalcStatus.ready,
          calculationId: sheet.calculation.id,
          sheetName: sheet.calculation.name,
          currencyCode: sheet.calculation.currencyCode,
          lines: lines,
          activeIndex: lines.length - 1,
          operatorNoticeTick: state.operatorNoticeTick,
        ));
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
    // A leading × / ÷ joins this line to the running total *above* it; the first
    // value line has nothing above, so `0 × n` / `0 ÷ n` would just zero the
    // total. Block it there — only a sign (+ / −) may lead the first line.
    if (active.rawExpression.isEmpty &&
        !state.requiresLeadingOperator &&
        _isMulDiv(op)) {
      return;
    }
    // An extra operator on a complete line (already holding its one binary
    // operator) descends to a new line, written with that operator at its start.
    if (ExpressionInput.atOperatorCap(active.rawExpression)) {
      if (!active.isError) _commitWithLeadingOperator(op);
      return;
    }
    _editActiveRaw((raw) => ExpressionInput.appendOperator(raw, op));
  }

  /// A multiply/divide key (in either glyph or ASCII form).
  static bool _isMulDiv(String op) =>
      op == '×' || op == '*' || op == '÷' || op == '/';

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
    emit(state.copyWith(
      focused: true,
      operatorNoticeTick: state.operatorNoticeTick + 1,
    ));
    return true;
  }

  /// `=` — blurs the active line so the sheet reads as a settled result with no
  /// focused row. The running total is already live, so it settles nothing else.
  void unfocus() => emit(state.copyWith(focused: false, commentEditing: false));

  /// Re-engages editing after [unfocus]: settles the current line onto a fresh
  /// one if it's complete, otherwise just re-focuses it in place.
  void _refocus() {
    if (state.focused) return;
    emit(state.copyWith(focused: true));
    commit(); // now focused → commits if the line is complete, else no-ops
  }

  void _commitWithLeadingOperator(String op) {
    final lines = [...state.lines]
      ..insert(state.activeIndex + 1, LedgerLine.empty());
    final newIndex = state.activeIndex + 1;
    lines[newIndex] = _evaluate(ExpressionInput.appendOperator('', op), null);
    emit(state.copyWith(
      lines: lines,
      activeIndex: newIndex,
      focused: true,
      commentEditing: false,
    ));
    _persist();
  }

  void backspace() {
    final active = state.activeLine;
    if (active == null) return;
    final raw = active.rawExpression;

    if (raw.isEmpty) {
      // Already empty: drop the blank line and step up to the previous one.
      if (active.isBlank && state.activeIndex > 0) _removeActiveAndStepUp();
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
    emit(state.copyWith(
      lines: lines,
      activeIndex: state.activeIndex - 1,
      focused: true,
      commentEditing: false,
    ));
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
    emit(state.copyWith(
      lines: [LedgerLine.empty()],
      activeIndex: 0,
      focused: true,
      commentEditing: false,
    ));
    final id = state.calculationId;
    if (id != null) await _repo.clearLines(id);
  }

  /// ↵ / tap-below / comment-return — commit the active line and descend.
  /// Blocked while the line is incomplete (SCHEMA §5).
  void commit() {
    final active = state.activeLine;
    if (active == null) return;
    // Tapping/committing while blurred (after `=`) re-engages instead.
    if (!state.focused) {
      _refocus();
      return;
    }
    // A comment with no amount isn't kept: discard it and stay on a fresh line.
    if (active.hasComment && !active.hasExpression) {
      _replaceActive(LedgerLine.empty());
      return;
    }
    if (!canCommit) return;
    final lines = [...state.lines]
      ..insert(state.activeIndex + 1, LedgerLine.empty());
    emit(state.copyWith(
      lines: lines,
      activeIndex: state.activeIndex + 1,
      focused: true,
      commentEditing: false,
    ));
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
    if (index == state.activeIndex) {
      emit(state.copyWith(focused: true, commentEditing: false));
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
    emit(state.copyWith(
      lines: lines,
      activeIndex: target,
      focused: true,
      commentEditing: false,
    ));
    _persist();
  }

  void startCommentEditing() =>
      emit(state.copyWith(focused: true, commentEditing: true));
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
    emit(state.copyWith(lines: lines, focused: true));
    _persist();
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
    if (join == LedgerJoin.div &&
        result.isOk &&
        result.value == Decimal.zero) {
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
    unawaited(_repo.persist(
      calculationId: id,
      lines: state.lines,
      total: state.total,
    ));
  }
}
