import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/database/app_database.dart';
import '../../data/repos/history_repository.dart';
import 'history_state.dart';

/// Watches the saved sheets and reacts to search queries.
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repo) : super(const HistoryState());

  final HistoryRepository _repo;
  StreamSubscription<List<Calculation>>? _sub;

  void start() => _subscribe(state.query);

  void search(String query) {
    emit(state.copyWith(query: query));
    _subscribe(query);
  }

  void _subscribe(String query) {
    _sub?.cancel();
    emit(state.copyWith(status: HistoryStatus.loading));
    _sub = _repo.watchSheets(query).listen(
      (sheets) => emit(
        state.copyWith(status: HistoryStatus.loaded, sheets: sheets),
      ),
      onError: (Object e) => emit(
        state.copyWith(status: HistoryStatus.error, failureMessage: '$e'),
      ),
    );
  }

  Future<void> delete(int id) async {
    final result = await _repo.deleteSheet(id);
    result.match(
      (failure) => emit(state.copyWith(failureMessage: failure.message)),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
