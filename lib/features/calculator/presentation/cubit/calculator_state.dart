import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/ledger_line.dart';

part 'calculator_state.freezed.dart';

enum CalcStatus { loading, ready, failure }

@freezed
sealed class CalculatorState with _$CalculatorState {
  const CalculatorState._();

  const factory CalculatorState({
    @Default(CalcStatus.loading) CalcStatus status,
    @Default(<LedgerLine>[]) List<LedgerLine> lines,
    @Default(0) int activeIndex,
    int? calculationId,

    /// Sheet name; null = unsaved draft.
    String? sheetName,
    String? currencyCode,
    @Default(2) int decimalPlaces,

    /// True while the comment field of the active line has focus (system
    /// keyboard up, numpad swapped out).
    @Default(false) bool commentEditing,

    /// Bumped each time a non-operator key is rejected on a line that still
    /// needs a leading operator — the screen shows a quick notice.
    @Default(0) int operatorNoticeTick,
    String? failureMessage,
  }) = _CalculatorState;

  bool get isDraft => sheetName == null || sheetName!.trim().isEmpty;

  LedgerLine? get activeLine =>
      (activeIndex >= 0 && activeIndex < lines.length)
          ? lines[activeIndex]
          : null;

  /// Every line after the first value line must begin with a join operator
  /// (tape model). True when the active line is still empty *and* a value line
  /// precedes it — the number / `.` / `(` / `)` / `%` keys are disabled until an
  /// operator is pressed.
  bool get requiresLeadingOperator {
    final active = activeLine;
    if (active == null) return true;
    if (active.rawExpression.isNotEmpty) return false; // operator already placed
    for (var i = 0; i < activeIndex; i++) {
      if (lines[i].hasExpression) return true; // a value line precedes it
    }
    return false; // this is the first value line — exempt
  }

  /// Running tape total: each valid line joins the result above it by its
  /// [LedgerJoin] (add a signed value, or multiply/divide by a magnitude).
  Decimal get total {
    var total = Decimal.zero;
    for (final line in lines) {
      if (!line.countsTowardTotal) continue;
      switch (line.join) {
        case LedgerJoin.add:
          total += line.computedValue;
        case LedgerJoin.mul:
          total *= line.computedValue;
        case LedgerJoin.div:
          if (line.computedValue == Decimal.zero) continue;
          total = (total / line.computedValue)
              .toDecimal(scaleOnInfinitePrecision: 20);
      }
    }
    return total;
  }

  /// Lines that actually carry content (for the top-bar "{n} lines" meta).
  int get contentLineCount =>
      lines.where((l) => l.hasExpression || l.isSectionHeader).length;
}
