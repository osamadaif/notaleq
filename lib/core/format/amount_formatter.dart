import 'package:decimal/decimal.dart';

/// Formats money for display per `SCHEMA.md`: Western digits `0-9`, `,` thousands
/// grouping on the **integer part only**, `.` decimal, and the design's minus
/// glyph `−` for negatives. Rounds to `decimalPlaces` and strips trailing zeros
/// so round numbers read cleanly (e.g. `1750` → `"1,750"`, not `"1,750.00"`).
///
/// Pure Dart over `decimal` — no `double`, so large/precise amounts stay exact.
class AmountFormatter {
  const AmountFormatter();

  /// U+2212 MINUS SIGN (matches the design's tabular figures).
  static const String minus = '−';

  /// Formats a computed amount or total.
  String format(Decimal value, {int decimalPlaces = 2}) {
    final rounded = value.abs().round(scale: decimalPlaces);
    final negative = value < Decimal.zero && rounded != Decimal.zero;

    final parts = rounded.toString().split('.');
    final grouped = _group(parts[0]);
    final fraction = parts.length > 1 ? parts[1] : '';

    final buffer = StringBuffer();
    if (negative) buffer.write(minus);
    buffer.write(grouped);
    if (fraction.isNotEmpty) {
      buffer
        ..write('.')
        ..write(fraction);
    }
    return buffer.toString();
  }

  /// Formats the raw expression of the active line for display: thousands
  /// grouping on each number's integer part, operators shown as `× ÷ −`. Empty
  /// input shows `"0"` (Samsung-style).
  String formatExpression(String raw) {
    if (raw.trim().isEmpty) return '0';

    final buffer = StringBuffer();
    var i = 0;
    while (i < raw.length) {
      final ch = raw[i];
      if (_isDigit(ch) || ch == '.') {
        final start = i;
        while (i < raw.length && (_isDigit(raw[i]) || raw[i] == '.')) {
          i++;
        }
        buffer.write(_groupNumber(raw.substring(start, i)));
        continue;
      }
      switch (ch) {
        case '*':
        case '×':
          buffer.write('×');
        case '/':
        case '÷':
          buffer.write('÷');
        case '-':
        case '−':
          buffer.write('−');
        default:
          buffer.write(ch);
      }
      i++;
    }
    return buffer.toString();
  }

  String _groupNumber(String token) {
    final parts = token.split('.');
    var intPart = parts[0];
    final hasFraction = parts.length > 1 || token.endsWith('.');
    if (intPart.isEmpty) intPart = '0';
    final grouped = _group(intPart);
    if (!hasFraction) return grouped;
    final fraction = parts.length > 1 ? parts[1] : '';
    return '$grouped.$fraction';
  }

  String _group(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39;
  }
}
