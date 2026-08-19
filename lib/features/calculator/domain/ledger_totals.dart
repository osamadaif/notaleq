import 'package:decimal/decimal.dart';

import 'entities/ledger_line.dart';

/// Running-tape calculations shared by state and subtotal maintenance.
class LedgerTotals {
  const LedgerTotals._();

  static Decimal calculate(Iterable<LedgerLine> lines) {
    var runningTotal = Decimal.zero;
    for (final line in lines) {
      runningTotal = _apply(runningTotal, line);
    }
    return runningTotal;
  }

  /// Recomputes every marker from the expression rows physically above it.
  static List<LedgerLine> refreshSubtotals(List<LedgerLine> lines) {
    var runningTotal = Decimal.zero;
    final refreshed = <LedgerLine>[];
    for (final line in lines) {
      if (line.isSubtotal) {
        refreshed.add(line.copyWith(computedValue: runningTotal));
      } else {
        refreshed.add(line);
        runningTotal = _apply(runningTotal, line);
      }
    }
    return refreshed;
  }

  static Decimal _apply(Decimal runningTotal, LedgerLine line) {
    if (!line.countsTowardTotal) return runningTotal;
    switch (line.join) {
      case LedgerJoin.add:
        return runningTotal + line.computedValue;
      case LedgerJoin.mul:
        return runningTotal * line.computedValue;
      case LedgerJoin.div:
        return (runningTotal / line.computedValue).toDecimal(
          scaleOnInfinitePrecision: 20,
        );
    }
  }
}
