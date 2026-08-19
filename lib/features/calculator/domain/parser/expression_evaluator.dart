import 'package:decimal/decimal.dart';

/// Why a line couldn't be evaluated. Lets the UI distinguish a neutral
/// still-typing state ([empty] / [incomplete]) from a real, red error
/// ([divisionByZero] / [invalidSyntax] / [tooManyOperands]).
enum ExpressionErrorKind {
  /// No tokens at all.
  empty,

  /// Ends on a dangling operator or is otherwise unfinished (e.g. "200*").
  incomplete,

  /// A division by zero (incl. `/ 0%`).
  divisionByZero,

  /// Malformed input (bad number, stray paren, percent on a group, …).
  invalidSyntax,

  /// Exceeds the 3-operand / 2-operator cap.
  tooManyOperands,
}

/// Result of evaluating one ledger line. `value` is meaningful only when
/// [isOk]; on error it is [Decimal.zero] and the line is excluded from the total.
class EvalResult {
  const EvalResult._(this.value, this.error);

  factory EvalResult.ok(Decimal value) => EvalResult._(value, null);

  factory EvalResult.failure(ExpressionErrorKind kind) =>
      EvalResult._(Decimal.zero, kind);

  final Decimal value;
  final ExpressionErrorKind? error;

  bool get isOk => error == null;
  bool get isError => error != null;

  @override
  String toString() =>
      isOk ? 'EvalResult.ok($value)' : 'EvalResult.failure($error)';
}

/// Evaluates a single line expression — Samsung-style basic calculator, capped
/// at 3 operands / 2 binary operators (see `SCHEMA.md` §4–5).
///
/// Pure Dart, no Flutter. The only dependency is `decimal` (amounts are never
/// `double`). Division is computed exactly and rounded only on infinite
/// precision.
class ExpressionEvaluator {
  const ExpressionEvaluator();

  /// Decimal places kept for non-terminating division results (e.g. 10 / 3).
  /// Display rounding to the user's `decimal_places` happens separately.
  static const int _divisionScale = 20;

  EvalResult evaluate(String raw) {
    try {
      final tokens = _tokenize(raw);
      if (tokens.isEmpty) return EvalResult.failure(ExpressionErrorKind.empty);

      final parser = _Parser(tokens);
      final node = parser.parse();
      final value = _eval(node);
      return EvalResult.ok(value);
    } on _ParseException catch (e) {
      return EvalResult.failure(e.kind);
    }
  }

  // --- Evaluation ---

  Decimal _eval(_Node node) {
    switch (node) {
      case _Num():
        return node.percent ? _percentOf(node.value) : node.value;
      case _Unary():
        return -_eval(node.child);
      case _Binary():
        return _evalBinary(node);
    }
  }

  Decimal _evalBinary(_Binary node) {
    final left = _eval(node.left);

    // Samsung-style additive percent is relative to the running left value:
    //   100 + 10%  → 100 + 100*0.10 = 110
    //   100 - 10%  → 100 - 100*0.10 = 90
    final right = node.right;
    if ((node.op == _Op.add || node.op == _Op.sub) &&
        right is _Num &&
        right.percent) {
      final portion = left * _percentOf(right.value);
      return node.op == _Op.add ? left + portion : left - portion;
    }

    final rightValue = _eval(node.right);
    switch (node.op) {
      case _Op.add:
        return left + rightValue;
      case _Op.sub:
        return left - rightValue;
      case _Op.mul:
        return left * rightValue;
      case _Op.div:
        if (rightValue == Decimal.zero) {
          throw const _ParseException(ExpressionErrorKind.divisionByZero);
        }
        return (left / rightValue).toDecimal(
          scaleOnInfinitePrecision: _divisionScale,
        );
    }
  }

  Decimal _percentOf(Decimal value) => (value / Decimal.fromInt(100)).toDecimal(
    scaleOnInfinitePrecision: _divisionScale,
  );

  // --- Tokenizer ---

  List<_Token> _tokenize(String raw) {
    final tokens = <_Token>[];
    final input = raw.trim();
    var i = 0;

    while (i < input.length) {
      final ch = input[i];

      if (ch == ' ' || ch == '\t' || ch == ',') {
        i++;
        continue;
      }

      if (_isDigit(ch) || ch == '.') {
        final start = i;
        var dots = 0;
        while (i < input.length && (_isDigit(input[i]) || input[i] == '.')) {
          if (input[i] == '.') dots++;
          i++;
        }
        final text = input.substring(start, i);
        if (dots > 1) {
          throw const _ParseException(ExpressionErrorKind.invalidSyntax);
        }
        tokens.add(_Token(_TokenType.number, _normalizeNumber(text)));
        continue;
      }

      final type = _operatorType(ch);
      if (type == null) {
        throw const _ParseException(ExpressionErrorKind.invalidSyntax);
      }
      tokens.add(_Token(type, ch));
      i++;
    }
    return tokens;
  }

  static bool _isDigit(String ch) {
    final code = ch.codeUnitAt(0);
    return code >= 0x30 && code <= 0x39;
  }

  static String _normalizeNumber(String text) {
    var t = text;
    if (t.startsWith('.')) t = '0$t';
    if (t.endsWith('.')) t = t.substring(0, t.length - 1);
    if (t.isEmpty || t == '0' && text == '.') t = '0';
    try {
      // Canonicalise (also validates).
      return Decimal.parse(t).toString();
    } on FormatException {
      throw const _ParseException(ExpressionErrorKind.invalidSyntax);
    }
  }

  static _TokenType? _operatorType(String ch) {
    switch (ch) {
      case '+':
        return _TokenType.plus;
      case '-':
      case '−': // −
      case '–': // –
        return _TokenType.minus;
      case '*':
      case '×': // ×
        return _TokenType.mul;
      case '/':
      case '÷': // ÷
        return _TokenType.div;
      case '(':
        return _TokenType.lparen;
      case ')':
        return _TokenType.rparen;
      case '%':
        return _TokenType.percent;
      default:
        return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Tokens
// ---------------------------------------------------------------------------

enum _TokenType { number, plus, minus, mul, div, lparen, rparen, percent }

class _Token {
  const _Token(this.type, this.text);
  final _TokenType type;
  final String text;
}

// ---------------------------------------------------------------------------
// AST
// ---------------------------------------------------------------------------

enum _Op { add, sub, mul, div }

sealed class _Node {}

class _Num extends _Node {
  _Num(this.value, {this.percent = false});
  final Decimal value;
  final bool percent;
}

class _Unary extends _Node {
  _Unary(this.child);
  final _Node child;
}

class _Binary extends _Node {
  _Binary(this.op, this.left, this.right);
  final _Op op;
  final _Node left;
  final _Node right;
}

// ---------------------------------------------------------------------------
// Parser — recursive descent with precedence (* / before + -), the grammar's
// 3-operand / 2-operator cap, and leading/after-operator/after-paren unary sign.
// ---------------------------------------------------------------------------

class _ParseException implements Exception {
  const _ParseException(this.kind);
  final ExpressionErrorKind kind;
}

class _Parser {
  _Parser(this._tokens);

  final List<_Token> _tokens;
  int _pos = 0;
  int _operands = 0;
  int _binops = 0;

  _Token? get _peek => _pos < _tokens.length ? _tokens[_pos] : null;

  _Token _advance() => _tokens[_pos++];

  _Node parse() {
    final node = _additive();
    if (_peek != null) {
      // Unconsumed tokens — malformed.
      throw const _ParseException(ExpressionErrorKind.invalidSyntax);
    }
    if (_operands > 3 || _binops > 2) {
      throw const _ParseException(ExpressionErrorKind.tooManyOperands);
    }
    return node;
  }

  _Node _additive() {
    var left = _multiplicative();
    while (_peek?.type == _TokenType.plus || _peek?.type == _TokenType.minus) {
      final op = _advance().type == _TokenType.plus ? _Op.add : _Op.sub;
      _binops++;
      final right = _multiplicative();
      left = _Binary(op, left, right);
    }
    return left;
  }

  _Node _multiplicative() {
    var left = _unary();
    while (_peek?.type == _TokenType.mul || _peek?.type == _TokenType.div) {
      final op = _advance().type == _TokenType.mul ? _Op.mul : _Op.div;
      _binops++;
      final right = _unary();
      left = _Binary(op, left, right);
    }
    return left;
  }

  _Node _unary() {
    final t = _peek;
    if (t == null) {
      throw const _ParseException(ExpressionErrorKind.incomplete);
    }
    if (t.type == _TokenType.minus) {
      _advance();
      return _Unary(_unary());
    }
    if (t.type == _TokenType.plus) {
      _advance();
      return _unary();
    }
    return _primary();
  }

  _Node _primary() {
    final t = _peek;
    if (t == null) {
      throw const _ParseException(ExpressionErrorKind.incomplete);
    }

    if (t.type == _TokenType.lparen) {
      _advance();
      final inner = _additive();
      if (_peek?.type != _TokenType.rparen) {
        throw const _ParseException(ExpressionErrorKind.invalidSyntax);
      }
      _advance();
      // Grammar attaches percent to numbers only, never to a group.
      if (_peek?.type == _TokenType.percent) {
        throw const _ParseException(ExpressionErrorKind.invalidSyntax);
      }
      return inner;
    }

    if (t.type == _TokenType.number) {
      _advance();
      _operands++;
      final value = Decimal.parse(t.text);
      if (_peek?.type == _TokenType.percent) {
        _advance();
        return _Num(value, percent: true);
      }
      return _Num(value);
    }

    // An operator / stray token where an operand was expected.
    throw const _ParseException(ExpressionErrorKind.invalidSyntax);
  }
}
