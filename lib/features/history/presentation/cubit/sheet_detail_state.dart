import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/database/app_database.dart';

part 'sheet_detail_state.freezed.dart';

enum SheetDetailStatus { loading, loaded, error }

/// State of the read-only saved-sheet detail view.
@freezed
sealed class SheetDetailState with _$SheetDetailState {
  const factory SheetDetailState({
    @Default(SheetDetailStatus.loading) SheetDetailStatus status,
    Calculation? sheet,
    @Default(<Line>[]) List<Line> lines,
    String? failureMessage,
  }) = _SheetDetailState;
}
