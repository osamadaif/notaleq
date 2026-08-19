import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaleq/core/database/app_database.dart';

void main() {
  test('v1 migration preserves legacy rows as expression entries', () async {
    final executor = NativeDatabase.memory(
      setup: (rawDb) {
        rawDb
          ..execute('''
          CREATE TABLE calculations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            is_draft INTEGER NOT NULL DEFAULT 1,
            cached_total TEXT NOT NULL DEFAULT '0',
            currency_code TEXT,
            created_at INTEGER NOT NULL,
            updated_at INTEGER NOT NULL
          );
        ''')
          ..execute('''
          CREATE TABLE lines (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            calculation_id INTEGER NOT NULL,
            position INTEGER NOT NULL,
            raw_expression TEXT NOT NULL DEFAULT '',
            computed_value TEXT NOT NULL DEFAULT '0',
            comment TEXT,
            is_error INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (calculation_id) REFERENCES calculations(id)
              ON DELETE CASCADE
          );
        ''')
          ..execute(
            "INSERT INTO calculations "
            "(id, is_draft, cached_total, created_at, updated_at) "
            "VALUES (1, 1, '25', 0, 0);",
          )
          ..execute(
            "INSERT INTO lines "
            "(calculation_id, position, raw_expression, computed_value) "
            "VALUES (1, 0, '25', '25');",
          )
          ..execute('PRAGMA user_version = 1');
      },
    );
    final db = AppDatabase.forTesting(executor);
    addTearDown(db.close);

    final legacyLines = await db.linesDao.getLines(1);
    expect(legacyLines, hasLength(1));
    expect(legacyLines.single.rawExpression, '25');
    expect(legacyLines.single.entryType, 'expression');
  });
}
