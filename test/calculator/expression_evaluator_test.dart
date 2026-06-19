import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/features/calculator/domain/parser/expression_evaluator.dart';

void main() {
  const evaluator = ExpressionEvaluator();

  Decimal value(String expr) {
    final r = evaluator.evaluate(expr);
    expect(r.isOk, isTrue, reason: 'expected "$expr" to be valid, got ${r.error}');
    return r.value;
  }

  ExpressionErrorKind? error(String expr) => evaluator.evaluate(expr).error;

  Decimal dec(String s) => Decimal.parse(s);

  group('plain numbers & operators', () {
    test('single number', () => expect(value('10000'), dec('10000')));
    test('leading negative', () => expect(value('-1000'), dec('-1000')));
    test('addition', () => expect(value('1000+750'), dec('1750')));
    test('multiplication', () => expect(value('-200*4'), dec('-800')));
    test('division', () => expect(value('100/2'), dec('50')));
  });

  group('precedence & parentheses', () {
    test('* binds before +', () => expect(value('100+200*3'), dec('700')));
    test('parentheses override', () => expect(value('(100+200)*3'), dec('900')));
    test('paren on the right', () => expect(value('2*(3+4)'), dec('14')));
    test('three operands, two operators', () =>
        expect(value('(2+3)*4'), dec('20')));
  });

  group('unary sign', () {
    test('leading unary minus', () => expect(value('-5+3'), dec('-2')));
    test('unary after a binary operator', () =>
        expect(value('5*-3'), dec('-15')));
    test('leading plus is a no-op', () => expect(value('+5'), dec('5')));
  });

  group('Samsung-style percent', () {
    test('add percent is base-relative', () =>
        expect(value('100+10%'), dec('110')));
    test('subtract percent is base-relative', () =>
        expect(value('100-10%'), dec('90')));
    test('multiply percent is a fraction', () =>
        expect(value('200*50%'), dec('100')));
    test('divide by percent', () => expect(value('200/50%'), dec('400')));
    test('lone percent is value/100', () => expect(value('50%'), dec('0.5')));
    test('percent cannot attach to a group', () =>
        expect(error('(1+2)%'), ExpressionErrorKind.invalidSyntax));
  });

  group('decimals', () {
    test('decimal arithmetic stays exact (0.1 + 0.2)', () =>
        expect(value('0.1+0.2'), dec('0.3')));
    test('leading dot becomes 0.', () => expect(value('.5+.5'), dec('1')));
    test('trailing dot allowed', () => expect(value('1.+1'), dec('2')));
    test('multiple dots are invalid', () =>
        expect(error('1.2.3'), ExpressionErrorKind.invalidSyntax));
    test('non-terminating division is rounded, not errored', () {
      final r = evaluator.evaluate('10/3');
      expect(r.isOk, isTrue);
      expect(r.value.toDouble(), closeTo(3.33333333, 1e-6));
    });
  });

  group('errors', () {
    test('empty', () => expect(error(''), ExpressionErrorKind.empty));
    test('whitespace only', () => expect(error('   '), ExpressionErrorKind.empty));
    test('dangling operator', () =>
        expect(error('200*'), ExpressionErrorKind.incomplete));
    test('division by zero', () =>
        expect(error('1/0'), ExpressionErrorKind.divisionByZero));
    test('division by 0%', () =>
        expect(error('5/0%'), ExpressionErrorKind.divisionByZero));
    test('stray closing paren', () =>
        expect(error('5)'), ExpressionErrorKind.invalidSyntax));
    test('empty parentheses', () =>
        expect(error('()'), ExpressionErrorKind.invalidSyntax));
    test('double operator', () =>
        expect(error('5+*3'), ExpressionErrorKind.invalidSyntax));
    test('letters are invalid', () =>
        expect(error('5a'), ExpressionErrorKind.invalidSyntax));
    test('four operands exceed the cap', () =>
        expect(error('1+2+3+4'), ExpressionErrorKind.tooManyOperands));
  });

  group('glyph operators are accepted', () {
    test('× ÷ −', () {
      expect(value('6×7'), dec('42'));
      expect(value('84÷2'), dec('42'));
      expect(value('50−8'), dec('42'));
    });
  });

  test('canonical "مصاريف الشهر" sheet sums to 1750', () {
    const lines = [
      '10000',
      '-1000',
      '-500',
      '-3000',
      '-5000',
      '2000',
      '-200*4',
      '100/2',
    ];
    var total = Decimal.zero;
    for (final line in lines) {
      final r = evaluator.evaluate(line);
      expect(r.isOk, isTrue, reason: 'line "$line" should be valid');
      total += r.value;
    }
    expect(total, dec('1750'));
  });
}
