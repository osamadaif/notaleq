import 'package:fpdart/fpdart.dart' show Either, Unit, unit;

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/failures.dart';

/// A saved sheet read for the (read-only) detail view: its `calculations` row
/// plus its `lines` rows (drift models).
class SheetData {
  const SheetData({required this.calculation, required this.lines});
  final Calculation calculation;
  final List<Line> lines;
}

/// Read/delete access to saved sheets (history). The list is reactive via a
/// drift `watch()` stream. Saved sheets are **read-only** here — opening one
/// shows a detail view; it is never loaded back into the editor (that would let
/// edits overwrite history), so this repo never writes lines or moves the active
/// sheet.
class HistoryRepository {
  HistoryRepository(this._calcDao, this._linesDao);

  final CalculationsDao _calcDao;
  final LinesDao _linesDao;

  /// Watches saved sheets (newest first), optionally filtered by name.
  Stream<List<Calculation>> watchSheets(String query) {
    final q = query.trim();
    return q.isEmpty
        ? _calcDao.watchSavedSheets()
        : _calcDao.watchSavedSheetsByName(q);
  }

  /// Loads one saved sheet (its row + ordered lines) for the detail view.
  Future<Either<Failures, SheetData>> loadSheet(int id) async {
    try {
      final calc = await _calcDao.getById(id);
      if (calc == null) {
        return Either.left(const NotFoundFailure('Sheet not found'));
      }
      final lines = await _linesDao.getLines(id);
      return Either.right(SheetData(calculation: calc, lines: lines));
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }

  Future<Either<Failures, Unit>> deleteSheet(int id) async {
    try {
      await _calcDao.deleteCalculation(id);
      return Either.right(unit);
    } catch (e) {
      return Either.left(DatabaseFailure(e.toString()));
    }
  }
}
