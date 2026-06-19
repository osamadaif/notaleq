import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/features/calculator/domain/expression_input.dart';

void main() {
  group('operators', () {
    test('append', () => expect(ExpressionInput.appendOperator('5', '+'), '5+'));
    test('replace a trailing operator', () =>
        expect(ExpressionInput.appendOperator('5+', '×'), '5*'));
    test('leading minus is a sign', () =>
        expect(ExpressionInput.appendOperator('', '-'), '-'));
    test('leading plus is a sign', () =>
        expect(ExpressionInput.appendOperator('', '+'), '+'));
    test('leading × starts a tape join', () =>
        expect(ExpressionInput.appendOperator('', '×'), '*'));
    test('leading ÷ starts a tape join', () =>
        expect(ExpressionInput.appendOperator('', '÷'), '/'));
    test('unary minus after a paren', () =>
        expect(ExpressionInput.appendOperator('(', '-'), '(-'));
    test('blocked at the 1-operator cap', () =>
        expect(ExpressionInput.appendOperator('1+2', '*'), '1+2'));
  });

  group('operatorsEnabled', () {
    test('enabled below the cap', () =>
        expect(ExpressionInput.operatorsEnabled('12'), isTrue));
    test('enabled to allow replace at the cap', () =>
        expect(ExpressionInput.operatorsEnabled('1+'), isTrue));
    test('disabled at the cap on an operand', () =>
        expect(ExpressionInput.operatorsEnabled('1+2'), isFalse));
  });

  group('decimal point', () {
    test('append', () => expect(ExpressionInput.appendDigit('5', '.'), '5.'));
    test('only one per number', () =>
        expect(ExpressionInput.appendDigit('5.', '.'), '5.'));
    test('leading dot becomes 0.', () =>
        expect(ExpressionInput.appendDigit('', '.'), '0.'));
    test('new number after operator', () =>
        expect(ExpressionInput.appendDigit('5+', '.'), '5+0.'));
    test('caps a number at 16 integer digits', () {
      const sixteen = '1234567890123456';
      expect(ExpressionInput.appendDigit(sixteen, '7'), sixteen);
    });
  });

  group('percent', () {
    test('after a number', () =>
        expect(ExpressionInput.appendPercent('50'), '50%'));
    test('not doubled', () =>
        expect(ExpressionInput.appendPercent('50%'), '50%'));
    test('not on empty', () => expect(ExpressionInput.appendPercent(''), ''));
  });

  group('parentheses', () {
    test('open on empty', () =>
        expect(ExpressionInput.appendParen('', '('), '('));
    test('no implicit multiply', () =>
        expect(ExpressionInput.appendParen('5', '('), '5'));
    test('open after operator', () =>
        expect(ExpressionInput.appendParen('5*', '('), '5*('));
    test('close a balanced group', () =>
        expect(ExpressionInput.appendParen('(5+2', ')'), '(5+2)'));
    test('no close without an open', () =>
        expect(ExpressionInput.appendParen('5', ')'), '5'));
  });

  test('backspace', () {
    expect(ExpressionInput.backspace('50'), '5');
    expect(ExpressionInput.backspace(''), '');
  });
}
