/// Pure string-editing rules for the active line as keys are pressed
/// (SCHEMA §5). No Flutter, no state — every method maps a raw expression to the
/// next raw expression, so the rules are unit-testable in isolation.
class ExpressionInput {
  const ExpressionInput._();

  /// Max integer digits allowed in a single number.
  static const int maxIntegerDigits = 16;

  /// Max fractional digits allowed after the decimal point. Comfortably above
  /// the largest display rounding the user can pick (`decimal_places` ≤ 6), so
  /// it never clips a visible digit while still bounding `0.000…001`-style runs.
  static const int maxFractionDigits = 8;

  /// Appends a digit, or a decimal point (one per number; a leading `.` becomes
  /// `0.`). Caps a number's integer part at [maxIntegerDigits].
  static String appendDigit(String raw, String digit) {
    if (digit == '.') {
      final current = _currentNumber(raw);
      if (current.contains('.')) return raw;
      if (current.isEmpty) return '${raw}0.';
      return '$raw.';
    }
    final current = _currentNumber(raw);
    // Leading-zero collapse (Samsung-style): a bare "0" integer part never grows
    // into "00"/"000"; the first significant digit replaces it ("0" then "5" →
    // "5"). "0." / "0.0" already hold a decimal point, so they keep appending.
    if (current == '0') {
      return digit == '0' ? raw : raw.substring(0, raw.length - 1) + digit;
    }
    final dotIndex = current.indexOf('.');
    if (dotIndex < 0) {
      // Still on the integer part.
      if (current.length >= maxIntegerDigits) return raw;
    } else {
      // On the fractional part — cap its length too (the integer cap alone let
      // `0.000…` grow without bound).
      if (current.length - dotIndex - 1 >= maxFractionDigits) return raw;
    }
    return '$raw$digit';
  }

  /// Appends a binary operator, or **replaces** a trailing one
  /// (`5 +` then `*` → `5 *`). Honors the 1-operator cap (one binary operator
  /// besides the optional leading join) and allows a unary `-` at the start /
  /// after `(`.
  static String appendOperator(String raw, String op) {
    final o = _normalize(op);
    // A line may start with any operator: + / − are a sign, × / ÷ join this line
    // to the running total above it (tape model).
    if (raw.isEmpty) return o;

    final last = raw[raw.length - 1];
    if (_isOperator(last)) {
      return raw.substring(0, raw.length - 1) + o; // replace
    }
    if (last == '(') {
      return o == '-' ? '$raw-' : raw; // only unary minus after '('
    }
    if (binaryOperatorCount(raw) >= 1) return raw; // at the cap
    return '$raw$o';
  }

  static String appendParen(String raw, String paren) {
    if (paren == '(') {
      if (raw.isEmpty) return '(';
      final last = raw[raw.length - 1];
      return (_isOperator(last) || last == '(') ? '$raw(' : raw;
    }
    // ')'
    final opens = '('.allMatches(raw).length;
    final closes = ')'.allMatches(raw).length;
    if (opens <= closes) return raw;
    final last = raw[raw.length - 1];
    return _isOperandEnd(last) ? '$raw)' : raw;
  }

  /// Postfix `%` attaches to the number it follows.
  static String appendPercent(String raw) {
    if (raw.isEmpty) return raw;
    final last = raw[raw.length - 1];
    return _isDigit(last) ? '$raw%' : raw;
  }

  static String backspace(String raw) =>
      raw.isEmpty ? raw : raw.substring(0, raw.length - 1);

  /// True when the line already holds its one binary operator and ends on an
  /// operand — a further operator should descend to a new line.
  static bool atOperatorCap(String raw) {
    if (raw.isEmpty) return false;
    return binaryOperatorCount(raw) >= 1 && _isOperandEnd(raw[raw.length - 1]);
  }

  /// Number of *binary* operators (an operator preceded by an operand end).
  static int binaryOperatorCount(String raw) {
    var count = 0;
    for (var i = 0; i < raw.length; i++) {
      if (_isOperator(raw[i]) && i > 0 && _isOperandEnd(raw[i - 1])) count++;
    }
    return count;
  }

  /// Whether the numpad's `+ − × ÷` keys should be enabled: always, unless the
  /// one binary operator is already placed and the line ends on an operand (then
  /// the only allowed action would be a replace, which needs a trailing
  /// operator).
  static bool operatorsEnabled(String raw) {
    if (raw.isEmpty) return true;
    final last = raw[raw.length - 1];
    if (_isOperator(last)) return true;
    return !(binaryOperatorCount(raw) >= 1 && _isOperandEnd(last));
  }

  // --- helpers ---

  static String _currentNumber(String raw) {
    var i = raw.length;
    while (i > 0 && (_isDigit(raw[i - 1]) || raw[i - 1] == '.')) {
      i--;
    }
    return raw.substring(i);
  }

  static String _normalize(String op) {
    switch (op) {
      case '−':
        return '-';
      case '×':
        return '*';
      case '÷':
        return '/';
      default:
        return op;
    }
  }

  static bool _isOperator(String ch) =>
      ch == '+' || ch == '-' || ch == '*' || ch == '/';

  static bool _isOperandEnd(String ch) =>
      _isDigit(ch) || ch == '.' || ch == ')' || ch == '%';

  static bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39;
  }
}
