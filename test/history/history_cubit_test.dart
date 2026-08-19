import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';
import 'package:notaleq/features/history/data/repos/history_repository.dart';
import 'package:notaleq/features/history/presentation/cubit/history_cubit.dart';
import 'package:notaleq/features/history/presentation/cubit/history_state.dart';

void main() {
  late AppDatabase db;
  late HistoryCubit cubit;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    cubit = HistoryCubit(HistoryRepository(db.calculationsDao, db.linesDao));
  });

  tearDown(() async {
    await cubit.close();
    await db.close();
  });

  Future<int> savedSheet(String name) async {
    final id = await db.calculationsDao.createDraft();
    await db.calculationsDao.saveAs(id, name);
    return id;
  }

  test('start loads saved sheets, newest first', () async {
    await savedSheet('مصاريف الشهر');
    cubit.start();
    await cubit.stream.firstWhere((s) => s.status == HistoryStatus.loaded);
    expect(cubit.state.sheets, hasLength(1));
    expect(cubit.state.sheets.first.name, 'مصاريف الشهر');
  });

  test('empty when there are no saved sheets', () async {
    cubit.start();
    await cubit.stream.firstWhere((s) => s.status == HistoryStatus.loaded);
    expect(cubit.state.isEmpty, isTrue);
  });

  test('search filters by name', () async {
    await savedSheet('مصاريف الشهر');
    await savedSheet('إيجار البيت');
    cubit.start();
    await cubit.stream.firstWhere((s) => s.status == HistoryStatus.loaded);

    cubit.search('إيجار');
    await cubit.stream.firstWhere(
      (s) => s.status == HistoryStatus.loaded && s.sheets.length == 1,
    );
    expect(cubit.state.sheets.first.name, 'إيجار البيت');
  });

  test('delete removes a sheet from the list', () async {
    final id = await savedSheet('مصاريف الشهر');
    cubit.start();
    await cubit.stream.firstWhere((s) => s.status == HistoryStatus.loaded);

    await cubit.delete(id);
    await cubit.stream.firstWhere(
      (s) => s.status == HistoryStatus.loaded && s.sheets.isEmpty,
    );
    expect(cubit.state.isEmpty, isTrue);
  });

  test(
    'loadSheet returns a saved sheet with its ordered lines (read-only)',
    () async {
      final repo = HistoryRepository(db.calculationsDao, db.linesDao);
      final id = await savedSheet('مصاريف');
      await db.linesDao.insertLine(
        LinesCompanion.insert(
          calculationId: id,
          position: 0,
          rawExpression: const Value('100'),
          computedValue: const Value('100'),
        ),
      );
      await db.linesDao.insertLine(
        LinesCompanion.insert(
          calculationId: id,
          position: 1,
          entryType: const Value('subtotal'),
          computedValue: const Value('100'),
        ),
      );

      final result = await repo.loadSheet(id);
      result.match((f) => fail('expected success but got ${f.message}'), (
        data,
      ) {
        expect(data.calculation.name, 'مصاريف');
        expect(data.lines, hasLength(2));
        expect(data.lines.first.rawExpression, '100');
        expect(data.lines.last.entryType, 'subtotal');
      });

      // Reading a saved sheet must not change it.
      final still = await db.calculationsDao.getById(id);
      expect(still!.isDraft, 0);
    },
  );
}
