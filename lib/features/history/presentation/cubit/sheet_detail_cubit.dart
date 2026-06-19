import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/history_repository.dart';
import 'sheet_detail_state.dart';

/// Loads one saved sheet for the **read-only** detail view. It never writes back
/// to the DB, so viewing a saved sheet can't change it.
class SheetDetailCubit extends Cubit<SheetDetailState> {
  SheetDetailCubit(this._repo) : super(const SheetDetailState());

  final HistoryRepository _repo;

  Future<void> load(int id) async {
    emit(state.copyWith(status: SheetDetailStatus.loading));
    final result = await _repo.loadSheet(id);
    result.match(
      (failure) => emit(state.copyWith(
        status: SheetDetailStatus.error,
        failureMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: SheetDetailStatus.loaded,
        sheet: data.calculation,
        lines: data.lines,
      )),
    );
  }
}
