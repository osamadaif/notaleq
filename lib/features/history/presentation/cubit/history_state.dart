import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/app_database.dart';

part 'history_state.freezed.dart';

enum HistoryStatus { loading, loaded, error }

@freezed
sealed class HistoryState with _$HistoryState {
  const HistoryState._();

  const factory HistoryState({
    @Default(HistoryStatus.loading) HistoryStatus status,
    @Default(<Calculation>[]) List<Calculation> sheets,
    @Default('') String query,
    String? failureMessage,
  }) = _HistoryState;

  bool get isEmpty => status == HistoryStatus.loaded && sheets.isEmpty;
}
