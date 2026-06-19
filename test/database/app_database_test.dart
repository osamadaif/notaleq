import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('creates a draft as the active sheet', () async {
    final id = await db.calculationsDao.createDraft();
    final draft = await db.calculationsDao.getActiveDraft();
    expect(draft, isNotNull);
    expect(draft!.id, id);
    expect(draft.isDraft, 1);
    expect(draft.cachedTotal, '0');
  });

  test('lines are returned ordered by position', () async {
    final id = await db.calculationsDao.createDraft();
    await db.linesDao.insertLine(LinesCompanion.insert(
      calculationId: id,
      position: 1,
      computedValue: const Value('-1000'),
    ));
    await db.linesDao.insertLine(LinesCompanion.insert(
      calculationId: id,
      position: 0,
      computedValue: const Value('10000'),
    ));

    final lines = await db.linesDao.getLines(id);
    expect(lines.map((l) => l.position), [0, 1]);
    expect(lines.first.computedValue, '10000');
  });

  test('saveAs promotes a draft to a saved, named sheet', () async {
    final id = await db.calculationsDao.createDraft();
    await db.calculationsDao.saveAs(id, 'مصاريف الشهر');

    final saved = await db.calculationsDao.getById(id);
    expect(saved!.isDraft, 0);
    expect(saved.name, 'مصاريف الشهر');

    final history = await db.calculationsDao.watchSavedSheets().first;
    expect(history.map((c) => c.id), contains(id));
  });

  test('deleting a sheet cascades to its lines', () async {
    final id = await db.calculationsDao.createDraft();
    await db.linesDao.insertLine(
        LinesCompanion.insert(calculationId: id, position: 0));

    await db.calculationsDao.deleteCalculation(id);

    expect(await db.linesDao.getLines(id), isEmpty);
  });
}
