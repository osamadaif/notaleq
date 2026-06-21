import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Sheets. One row per saved sheet (`isDraft = 0`) plus the live working draft
/// (`isDraft = 1`). Mirrors the `calculations` table in `SCHEMA.md`.
class Calculations extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// User-chosen name. NULL while it's an unsaved draft.
  TextColumn get name => text().nullable()();

  /// 1 = the active working sheet; 0 = a saved sheet (history).
  IntColumn get isDraft => integer().withDefault(const Constant(1))();

  /// Last computed total as a decimal string (cached for history listing).
  TextColumn get cachedTotal => text().withDefault(const Constant('0'))();

  /// Optional ISO code (e.g. 'EGP'). NULL = no currency. Reserved for future.
  TextColumn get currencyCode => text().nullable()();

  /// Epoch millis (UTC).
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// Rows of each sheet. Mirrors the `lines` table in `SCHEMA.md`.
class Lines extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get calculationId =>
      integer().references(Calculations, #id, onDelete: KeyAction.cascade)();

  /// 0-based order within the sheet.
  IntColumn get position => integer()();

  /// Exact tokens the user typed, e.g. "100+200*3". Source of truth.
  TextColumn get rawExpression => text().withDefault(const Constant(''))();

  /// Evaluated signed result as a decimal string.
  TextColumn get computedValue => text().withDefault(const Constant('0'))();

  /// Optional note. May be NULL/empty; a comment-only line is a section header.
  TextColumn get comment => text().nullable()();

  /// 1 = invalid / incomplete / divide-by-zero. Excluded from the total.
  IntColumn get isError => integer().withDefault(const Constant(0))();
}

@DriftDatabase(
  tables: [Calculations, Lines],
  daos: [CalculationsDao, LinesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests: inject an in-memory or custom executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Indexes per SCHEMA.md (incl. the DESC on updated_at).
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_lines_calc ON lines (calculation_id, position)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_calc_updated ON calculations (updated_at DESC)');
          await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_calc_is_draft ON calculations (is_draft)');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notaleq.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Data access for sheets (`calculations`).
@DriftAccessor(tables: [Calculations, Lines])
class CalculationsDao extends DatabaseAccessor<AppDatabase>
    with _$CalculationsDaoMixin {
  CalculationsDao(super.db);

  int get _now => DateTime.now().toUtc().millisecondsSinceEpoch;

  /// Creates a fresh empty draft and returns its id.
  Future<int> createDraft({String? currencyCode}) {
    final now = _now;
    return into(calculations).insert(
      CalculationsCompanion.insert(
        isDraft: const Value(1),
        currencyCode: Value(currencyCode),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<Calculation?> getById(int id) =>
      (select(calculations)..where((c) => c.id.equals(id))).getSingleOrNull();

  Stream<Calculation?> watchById(int id) =>
      (select(calculations)..where((c) => c.id.equals(id))).watchSingleOrNull();

  /// The most recently updated draft, if any.
  Future<Calculation?> getActiveDraft() {
    return (select(calculations)
          ..where((c) => c.isDraft.equals(1))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Saved sheets (history), newest first.
  Stream<List<Calculation>> watchSavedSheets() {
    return (select(calculations)
          ..where((c) => c.isDraft.equals(0))
          ..orderBy([(c) => OrderingTerm.desc(c.updatedAt)]))
        .watch();
  }

  /// Saved sheets filtered by a name query, newest first. The `%` / `_` LIKE
  /// wildcards (and the escape char itself) are escaped so a query containing
  /// them matches literally instead of acting as a wildcard.
  Stream<List<Calculation>> watchSavedSheetsByName(String query) {
    final escaped = query
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    return customSelect(
      'SELECT * FROM calculations '
      "WHERE is_draft = 0 AND name LIKE ?1 ESCAPE '\\' "
      'ORDER BY updated_at DESC',
      variables: [Variable.withString('%$escaped%')],
      readsFrom: {calculations},
    ).watch().map(
          (rows) => rows.map((row) => calculations.map(row.data)).toList(),
        );
  }

  /// Caches the latest total and bumps `updatedAt`.
  Future<void> updateCachedTotal(int id, String total) {
    return (update(calculations)..where((c) => c.id.equals(id))).write(
      CalculationsCompanion(cachedTotal: Value(total), updatedAt: Value(_now)),
    );
  }

  /// Names a draft and promotes it to a saved sheet.
  Future<void> saveAs(int id, String name) {
    return (update(calculations)..where((c) => c.id.equals(id))).write(
      CalculationsCompanion(
        name: Value(name),
        isDraft: const Value(0),
        updatedAt: Value(_now),
      ),
    );
  }

  Future<void> touch(int id) {
    return (update(calculations)..where((c) => c.id.equals(id)))
        .write(CalculationsCompanion(updatedAt: Value(_now)));
  }

  /// Deletes a sheet; its lines cascade away.
  Future<int> deleteCalculation(int id) =>
      (delete(calculations)..where((c) => c.id.equals(id))).go();
}

/// Data access for line rows (`lines`).
@DriftAccessor(tables: [Lines])
class LinesDao extends DatabaseAccessor<AppDatabase> with _$LinesDaoMixin {
  LinesDao(super.db);

  Stream<List<Line>> watchLines(int calculationId) {
    return (select(lines)
          ..where((l) => l.calculationId.equals(calculationId))
          ..orderBy([(l) => OrderingTerm.asc(l.position)]))
        .watch();
  }

  Future<List<Line>> getLines(int calculationId) {
    return (select(lines)
          ..where((l) => l.calculationId.equals(calculationId))
          ..orderBy([(l) => OrderingTerm.asc(l.position)]))
        .get();
  }

  Future<int> insertLine(LinesCompanion line) => into(lines).insert(line);

  Future<bool> updateLine(LinesCompanion line) => update(lines).replace(line);

  Future<int> deleteLine(int id) =>
      (delete(lines)..where((l) => l.id.equals(id))).go();

  /// Clears every line of a sheet (the AC action).
  Future<int> deleteAllForCalculation(int calculationId) =>
      (delete(lines)..where((l) => l.calculationId.equals(calculationId))).go();
}
