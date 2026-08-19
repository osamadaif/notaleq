import 'package:decimal/decimal.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';
import 'package:notaleq/features/calculator/data/repos/calculator_repository.dart';
import 'package:notaleq/features/calculator/domain/entities/ledger_line.dart';
import 'package:notaleq/features/calculator/presentation/cubit/calculator_cubit.dart';
import 'package:notaleq/features/calculator/presentation/cubit/calculator_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences prefs;
  late CalculatorCubit cubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    cubit = CalculatorCubit(CalculatorRepository(db, prefs));
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  test('load creates a draft with one empty active line', () async {
    await cubit.load();
    expect(cubit.state.status, CalcStatus.ready);
    expect(cubit.state.calculationId, isNotNull);
    expect(cubit.state.lines.length, 1);
    expect(cubit.state.isDraft, isTrue);
  });

  test('typing updates the live total', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    expect(cubit.state.total, Decimal.parse('100'));
  });

  test('commit descends to a new line and total accumulates', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    cubit.commit();
    expect(cubit.state.lines.length, 2);
    expect(cubit.state.activeIndex, 1);

    cubit
      ..inputOperator('+')
      ..inputDigit('5')
      ..inputDigit('0');
    expect(cubit.state.total, Decimal.parse('150'));
  });

  test('a non-first line must start with an operator', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    cubit.commit(); // line 1 is non-first

    cubit.inputDigit('5'); // rejected — needs a leading operator
    expect(cubit.state.activeLine!.rawExpression, isEmpty);

    cubit
      ..inputOperator('+')
      ..inputDigit('5'); // now allowed
    expect(cubit.state.activeLine!.rawExpression, '+5');
  });

  test(
    'deleting the leading operator deletes the whole non-first line',
    () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..inputDigit('0');
      cubit.commit();
      cubit
        ..inputOperator('+')
        ..inputDigit('5'); // line1 = +5
      expect(cubit.state.lines.length, 2);

      cubit.backspace(); // +5 → +
      cubit.backspace(); // + → empty → whole line removed, step up
      expect(cubit.state.lines.length, 1);
      expect(cubit.state.activeIndex, 0);
    },
  );

  test('commit is blocked while the line is incomplete', () async {
    await cubit.load();
    cubit
      ..inputDigit('5')
      ..inputOperator('×'); // dangling operator
    cubit.commit();
    expect(cubit.state.lines.length, 1); // not committed
  });

  test('an error line is excluded from the total', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputOperator('/')
      ..inputDigit('0'); // 1/0
    expect(cubit.state.activeLine!.isHardError, isTrue);
    expect(cubit.state.total, Decimal.zero);
  });

  test('AC clears the whole sheet', () async {
    await cubit.load();
    cubit
      ..inputDigit('9')
      ..inputDigit('9');
    await cubit.clearAll();
    expect(cubit.state.lines.length, 1);
    expect(cubit.state.lines.first.isBlank, isTrue);
    expect(cubit.state.total, Decimal.zero);
  });

  test('backspace deletes within the current line only', () async {
    await cubit.load();
    cubit
      ..inputDigit('5')
      ..inputDigit('0');
    cubit.backspace();
    expect(cubit.state.activeLine!.rawExpression, '5');
  });

  test('backspace on an empty line removes it and steps up', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    cubit.commit(); // [100, empty(active)]
    expect(cubit.state.lines.length, 2);

    cubit.backspace(); // empty active line → remove, step up
    expect(cubit.state.lines.length, 1);
    expect(cubit.state.activeIndex, 0);
    expect(cubit.state.lines.first.rawExpression, '100');
  });

  test(
    'leaving a blank line removes it (only one empty line survives)',
    () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..inputDigit('0');
      cubit.commit(); // [100, empty(active)]
      expect(cubit.state.lines.length, 2);

      cubit.setActive(0); // leave the trailing blank line
      expect(cubit.state.lines.length, 1);
      expect(cubit.state.activeIndex, 0);
      expect(cubit.state.lines.first.rawExpression, '100');
    },
  );

  test('a line can start with a sign', () async {
    await cubit.load();
    cubit
      ..inputOperator('-')
      ..inputDigit('5')
      ..inputDigit('0');
    expect(cubit.state.activeLine!.rawExpression, '-50');
    expect(cubit.state.total, Decimal.parse('-50'));
  });

  test(
    'the first line cannot start with × or ÷ (nothing above to join)',
    () async {
      await cubit.load();
      cubit.inputOperator('×'); // blocked
      expect(cubit.state.activeLine!.rawExpression, isEmpty);
      cubit.inputOperator('÷'); // blocked
      expect(cubit.state.activeLine!.rawExpression, isEmpty);

      // A sign still leads, and × works as a *binary* operator once there's a
      // value to its left.
      cubit
        ..inputDigit('5')
        ..inputOperator('×')
        ..inputDigit('2');
      expect(cubit.state.activeLine!.rawExpression, '5*2');
      expect(cubit.state.total, Decimal.parse('10'));
    },
  );

  group('automatic additive lines', () {
    for (final operator in ['+', '-']) {
      test('$operator commits a valid line and starts the next one', () async {
        await cubit.load();
        cubit
          ..inputDigit('1')
          ..inputDigit('0')
          ..inputOperator(operator);
        expect(cubit.state.lines, hasLength(2));
        expect(cubit.state.lines.first.rawExpression, '10');
        expect(cubit.state.activeLine!.rawExpression, operator);
      });
    }

    for (final scenario in [
      (trailing: '×', replacement: '+', expected: '+'),
      (trailing: '×', replacement: '−', expected: '-'),
      (trailing: '÷', replacement: '+', expected: '+'),
      (trailing: '÷', replacement: '−', expected: '-'),
    ]) {
      test('${scenario.replacement} after ${scenario.trailing} settles the row '
          'and descends', () async {
        await cubit.load();
        cubit
          ..inputDigit('5')
          ..inputOperator(scenario.trailing)
          ..inputOperator(scenario.replacement);
        expect(cubit.state.lines, hasLength(2));
        expect(cubit.state.lines.first.rawExpression, '5');
        expect(cubit.state.activeLine!.rawExpression, scenario.expected);
        expect(cubit.state.total, Decimal.parse('5'));
      });
    }

    for (final scenario in [
      (trailing: '×', replacement: '÷', expected: '5/'),
      (trailing: '÷', replacement: '×', expected: '5*'),
    ]) {
      test('${scenario.replacement} still replaces trailing '
          '${scenario.trailing} in place', () async {
        await cubit.load();
        cubit
          ..inputDigit('5')
          ..inputOperator(scenario.trailing)
          ..inputOperator(scenario.replacement);
        expect(cubit.state.lines, hasLength(1));
        expect(cubit.state.activeLine!.rawExpression, scenario.expected);
      });
    }

    test('an operator-only continuation still replaces in place', () async {
      await cubit.load();
      cubit
        ..inputDigit('5')
        ..inputOperator('+')
        ..inputOperator('-');
      expect(cubit.state.lines, hasLength(2));
      expect(cubit.state.activeLine!.rawExpression, '-');
    });

    test(
      'add stays in place while a parenthesized row is incomplete',
      () async {
        await cubit.load();
        cubit
          ..inputParen('(')
          ..inputDigit('1')
          ..inputOperator('+');
        expect(cubit.state.lines, hasLength(1));
        expect(cubit.state.activeLine!.rawExpression, '(1+');
      },
    );
  });

  group('subtotal', () {
    test('= inserts a subtotal and continues the running tape', () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..inputDigit('0')
        ..inputOperator('+')
        ..inputDigit('5')
        ..inputDigit('0')
        ..insertSubtotal();

      expect(cubit.state.lines, hasLength(4));
      expect(cubit.state.lines[2].isSubtotal, isTrue);
      expect(cubit.state.lines[2].computedValue, Decimal.parse('150'));
      expect(cubit.state.activeLine!.isBlank, isTrue);

      cubit
        ..inputOperator('×')
        ..inputDigit('2');
      expect(cubit.state.total, Decimal.parse('300'));
    });

    test('editing an earlier row refreshes the subtotal below it', () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..insertSubtotal()
        ..setActive(0)
        ..inputDigit('0');

      expect(cubit.state.lines[1].computedValue, Decimal.parse('100'));
    });

    test('= does nothing on a blank row', () async {
      await cubit.load();
      cubit.insertSubtotal();
      expect(cubit.state.lines, hasLength(1));
    });

    test('= does nothing on an error row', () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputOperator('÷')
        ..inputDigit('0')
        ..insertSubtotal();
      expect(cubit.state.lines, hasLength(1));
    });

    test('repeated = does not duplicate a subtotal marker', () async {
      await cubit.load();
      cubit
        ..inputDigit('5')
        ..insertSubtotal()
        ..insertSubtotal();
      expect(cubit.state.lines.where((line) => line.isSubtotal), hasLength(1));
    });

    test('backspace after = removes the blank row and subtotal', () async {
      await cubit.load();
      cubit
        ..inputDigit('5')
        ..insertSubtotal()
        ..backspace();
      expect(cubit.state.lines, hasLength(1));
      expect(cubit.state.activeLine!.rawExpression, '5');
    });

    test('an earlier excluded error does not block a valid subtotal', () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..commit()
        ..inputOperator('+')
        ..inputDigit('5')
        ..commit()
        ..setActive(0)
        ..clearActive()
        ..inputDigit('1')
        ..inputOperator('÷')
        ..inputDigit('0')
        ..setActive(1)
        ..insertSubtotal();

      expect(cubit.state.lines.first.isHardError, isTrue);
      expect(cubit.state.lines[2].isSubtotal, isTrue);
      expect(cubit.state.lines[2].computedValue, Decimal.parse('5'));
    });
  });

  test('tape: a ×-line multiplies the running total', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    cubit.commit(); // line0 = 100
    cubit
      ..inputOperator('×')
      ..inputDigit('2'); // line1 = ×2
    expect(cubit.state.activeLine!.join, LedgerJoin.mul);
    expect(cubit.state.total, Decimal.parse('200')); // 100 × 2
  });

  test('tape: a ÷-line by zero is flagged and skipped', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('0')
      ..inputDigit('0');
    cubit.commit();
    cubit
      ..inputOperator('÷')
      ..inputDigit('0'); // ÷0
    expect(cubit.state.activeLine!.isHardError, isTrue);
    expect(cubit.state.total, Decimal.parse('100')); // ÷0 excluded
  });

  test('save persists the named sheet and starts a fresh draft', () async {
    await cubit.load();
    cubit
      ..inputDigit('5')
      ..inputDigit('0')
      ..insertSubtotal();
    await cubit.save('مصاريف الشهر');

    // The editor resets to a fresh empty draft.
    expect(cubit.state.isDraft, isTrue);
    expect(cubit.state.lines.length, 1);
    expect(cubit.state.lines.first.isBlank, isTrue);

    // The named sheet is saved to history.
    final saved = await db.calculationsDao.watchSavedSheets().first;
    expect(saved.map((c) => c.name), contains('مصاريف الشهر'));
    final savedLines = await db.linesDao.getLines(saved.single.id);
    expect(savedLines.last.entryType, LedgerLineKind.subtotal.name);
  });

  test(
    'the editor never opens a saved sheet — it opens a draft instead',
    () async {
      // A saved sheet whose id is (stale-ly) marked active — e.g. left over from
      // an older build that loaded saved sheets into the editor.
      final savedId = await db.calculationsDao.createDraft();
      await db.calculationsDao.saveAs(savedId, 'مصاريف');
      await prefs.setInt(CalculatorRepository.activeIdKey, savedId);

      await cubit.load();

      // It refuses the saved sheet and opens a fresh/working draft instead, so
      // editing can never overwrite history and the name never leaks in.
      expect(cubit.state.calculationId, isNot(savedId));
      expect(cubit.state.sheetName, isNull);
      expect(cubit.state.isDraft, isTrue);
    },
  );

  test(
    'commit keeps the comment on its line; the new line starts clean',
    () async {
      await cubit.load();
      cubit
        ..inputDigit('1')
        ..inputDigit('0')
        ..inputDigit('0')
        ..updateComment('ايجار');
      cubit.commit();

      // The committed line keeps its amount and comment...
      expect(cubit.state.lines[0].rawExpression, '100');
      expect(cubit.state.lines[0].comment, 'ايجار');
      // ...and the fresh active line carries neither (no comment bleed).
      expect(cubit.state.activeLine!.comment, isNull);
      expect(cubit.state.activeLine!.isBlank, isTrue);
    },
  );

  test('an extra operator (one cap) descends to a new line with it', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputOperator('×')
      ..inputDigit('2');
    expect(
      cubit.state.activeLine!.rawExpression,
      '1*2',
    ); // one operator: the cap

    cubit.inputOperator('×'); // the extra operator → descends
    expect(cubit.state.lines.length, 2);
    expect(cubit.state.activeIndex, 1);
    expect(cubit.state.lines[1].rawExpression, '*');
  });

  test('a fresh non-first line requires a leading operator', () async {
    await cubit.load();
    // First line is exempt — it may start with a number.
    expect(cubit.state.requiresLeadingOperator, isFalse);
    cubit
      ..inputDigit('5')
      ..commit(); // line 0 = 5, line 1 empty + active
    // The new line must begin with a join operator (number keys disabled).
    expect(cubit.state.requiresLeadingOperator, isTrue);
    cubit.inputOperator('+');
    expect(cubit.state.requiresLeadingOperator, isFalse);
  });

  test('committing a comment-only line discards the comment', () async {
    await cubit.load();
    cubit.updateComment('ملاحظة'); // comment but no amount
    expect(cubit.state.activeLine!.hasComment, isTrue);
    cubit.commit();
    expect(cubit.state.activeLine!.isBlank, isTrue);
  });

  test('cannot focus away from a comment-only line', () async {
    await cubit.load();
    cubit
      ..inputDigit('5')
      ..commit(); // line 0 = 5, line 1 empty + active
    cubit.updateComment('ملاحظة'); // line 1 has a comment, no amount
    cubit.setActive(0);
    expect(cubit.state.activeIndex, 1); // rejected — stayed
  });

  test('draft persists and reloads', () async {
    await cubit.load();
    cubit
      ..inputDigit('1')
      ..inputDigit('2')
      ..inputDigit('5');
    // allow fire-and-forget persistence to flush
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final prefs = await SharedPreferences.getInstance();
    final reopened = CalculatorCubit(CalculatorRepository(db, prefs));
    await reopened.load();
    expect(reopened.state.total, Decimal.parse('125'));
    await reopened.close();
  });

  test('subtotal persists and reloads with a continuation row', () async {
    await cubit.load();
    cubit
      ..inputDigit('2')
      ..inputDigit('5')
      ..insertSubtotal();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final reopened = CalculatorCubit(CalculatorRepository(db, prefs));
    await reopened.load();
    expect(reopened.state.lines[1].isSubtotal, isTrue);
    expect(reopened.state.lines[1].computedValue, Decimal.parse('25'));
    expect(reopened.state.activeLine!.isBlank, isTrue);
    await reopened.close();
  });
}
