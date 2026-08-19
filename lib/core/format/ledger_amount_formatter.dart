import 'package:decimal/decimal.dart';

import 'amount_formatter.dart';

class LedgerAmountDisplay {
  const LedgerAmountDisplay({required this.text, required this.isNegative});

  final String text;
  final bool isNegative;
}

/// Formats a settled ledger row with its tape join (`+`, `−`, `×`, or `÷`).
class LedgerAmountFormatter {
  const LedgerAmountFormatter();

  static const AmountFormatter _amounts = AmountFormatter();

  LedgerAmountDisplay format({
    required String rawExpression,
    required Decimal computedAmount,
    required bool isError,
    required int decimalPlaces,
  }) {
    if (isError) {
      return LedgerAmountDisplay(
        text: _amounts.formatExpression(rawExpression),
        isNegative: false,
      );
    }
    final formatted = _amounts.format(
      computedAmount,
      decimalPlaces: decimalPlaces,
    );
    final leading = rawExpression.trimLeft();
    if (leading.startsWith('*') || leading.startsWith('×')) {
      return LedgerAmountDisplay(text: '×$formatted', isNegative: false);
    }
    if (leading.startsWith('/') || leading.startsWith('÷')) {
      return LedgerAmountDisplay(text: '÷$formatted', isNegative: false);
    }
    final beginsWithSign =
        leading.startsWith('+') ||
        leading.startsWith('-') ||
        leading.startsWith('−');
    if (beginsWithSign && computedAmount >= Decimal.zero) {
      return LedgerAmountDisplay(text: '+$formatted', isNegative: false);
    }
    return LedgerAmountDisplay(
      text: formatted,
      isNegative: computedAmount < Decimal.zero,
    );
  }
}
