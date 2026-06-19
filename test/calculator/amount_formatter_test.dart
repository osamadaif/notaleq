import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/format/amount_formatter.dart';

void main() {
  const f = AmountFormatter();
  Decimal d(String s) => Decimal.parse(s);
  const minus = AmountFormatter.minus;

  group('format', () {
    test('groups thousands', () => expect(f.format(d('10000')), '10,000'));
    test('total', () => expect(f.format(d('1750')), '1,750'));
    test('negative uses the minus glyph', () =>
        expect(f.format(d('-3000')), '${minus}3,000'));
    test('strips trailing zeros', () =>
        expect(f.format(d('1750.00'), decimalPlaces: 2), '1,750'));
    test('keeps significant decimals', () =>
        expect(f.format(d('1750.5'), decimalPlaces: 2), '1,750.5'));
    test('rounds to decimalPlaces', () =>
        expect(f.format(d('3.333'), decimalPlaces: 2), '3.33'));
    test('zero', () => expect(f.format(Decimal.zero), '0'));
    test('tiny negative rounds to plain zero', () =>
        expect(f.format(d('-0.001'), decimalPlaces: 2), '0'));
  });

  group('formatExpression', () {
    test('empty shows 0', () => expect(f.formatExpression(''), '0'));
    test('operators become glyphs', () =>
        expect(f.formatExpression('100+200*3'), '100+200×3'));
    test('groups each number', () =>
        expect(f.formatExpression('1000+2000'), '1,000+2,000'));
    test('negative literal', () =>
        expect(f.formatExpression('-3000'), '${minus}3,000'));
    test('trailing operator kept', () =>
        expect(f.formatExpression('1000+'), '1,000+'));
    test('decimals are not grouped', () =>
        expect(f.formatExpression('1234.5'), '1,234.5'));
  });
}
