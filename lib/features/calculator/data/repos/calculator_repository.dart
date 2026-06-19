import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart' show Either, Unit, unit;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/ledger_line.dart';

/// A loaded sheet: its `calculations` row + its `lines` rows (drift models).
class LoadedSheet {
  const LoadedSheet({required this.calculation, required this.lines});
  final Calculation calculation;
  final List<Line> lines;
}

/// Persistence for the calculator. Talks to the drift DAOs and
/// SharedPreferences; returns `Either<Failures, T>`.
///
/// The editor keeps lines in memory (the cubit) and writes the whole sheet on
/// each change so the draft survives an app kill (SCHEMA §7). The running total
/// is computed with `decimal` here/in the cubit — never in SQL.
class CalculatorRepository {
  CalculatorRepository(this._db, this._prefs);

  final AppDatabase _db;
  final SharedPreferences _prefs;

  CalculationsDao get _calcDao => _db.calculationsDao;
  LinesDao get _linesDao => _db.linesDao;

  static const String activeIdKey = 'active_calculation_id';

  /// Resolves the sheet to open in the editor: the one referenced by
  /// `active_calculation_id`, else the most recent draft, else a freshly created
  /// draft.
  ///
  /// The editor only ever opens a **draft** (`isDraft == 1`). A saved sheet is
  /// never editable — if the stored id points at one (e.g. stale state from an
  /// older build), it is ignored and a draft is opened/created instead, so
  /// editing can never overwrite history.
  Future<Either<Failures, LoadedSheet>> loadActiveSheet() async {
    try {
      Calculation? calc;
      final storedId = _prefs.getInt(activeIdKey);
      if (storedId != null) {
        final stored = await _calcDao.getById(storedId);
        if (stored != null && stored.isDraft == 1) calc = stored;
      }
      calc ??= await _calcDao.getActiveDraft();
      if (calc == null) {
        final id = await _calcDao.createDraft();
        calc = await _calcDao.getById(id);
      }
      await _prefs.setInt(activeIdKey, calc!.id);
      final lines = await _linesDao.getLines(calc.id);
      return Either.right(LoadedSheet(calculation: calc, lines: lines));
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }

  /// Rewrites every (non-blank) line of the sheet and caches the total.
  Future<Either<Failures, Unit>> persist({
    required int calculationId,
    required List<LedgerLine> lines,
    required Decimal total,
  }) async {
    try {
      final toStore = lines.where((l) => !l.isBlank).toList();
      await _db.transaction(() async {
        await _linesDao.deleteAllForCalculation(calculationId);
        for (var i = 0; i < toStore.length; i++) {
          final line = toStore[i];
          await _linesDao.insertLine(
            LinesCompanion.insert(
              calculationId: calculationId,
              position: i,
              rawExpression: Value(line.rawExpression),
              computedValue: Value(line.computedValue.toString()),
              comment: Value(line.comment),
              isError: Value(line.isError ? 1 : 0),
            ),
          );
        }
        await _calcDao.updateCachedTotal(calculationId, total.toString());
      });
      return Either.right(unit);
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }

  /// Creates a fresh empty draft and makes it the active sheet.
  Future<Either<Failures, Unit>> startNewDraft() async {
    try {
      final id = await _calcDao.createDraft();
      await _prefs.setInt(activeIdKey, id);
      return Either.right(unit);
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }

  /// Names a draft and promotes it to a saved sheet.
  Future<Either<Failures, Unit>> saveAs(int calculationId, String name) async {
    try {
      await _calcDao.saveAs(calculationId, name);
      return Either.right(unit);
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }

  /// Wipes every line of the sheet (AC) and resets the cached total.
  Future<Either<Failures, Unit>> clearLines(int calculationId) async {
    try {
      await _db.transaction(() async {
        await _linesDao.deleteAllForCalculation(calculationId);
        await _calcDao.updateCachedTotal(calculationId, '0');
      });
      return Either.right(unit);
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }
}
