import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';

part 'export_gate_state.freezed.dart';

@freezed
sealed class ExportGateState with _$ExportGateState {
  const factory ExportGateState.initial() = ExportGateInitial;
  const factory ExportGateState.offline() = ExportGateOffline;
  const factory ExportGateState.awaitingOptIn() = ExportGateAwaitingOptIn;
  const factory ExportGateState.loadingAd() = ExportGateLoadingAd;
  const factory ExportGateState.showingAd() = ExportGateShowingAd;
  const factory ExportGateState.unlocked() = ExportGateUnlocked;
  const factory ExportGateState.error(Failures failure) = ExportGateError;
}
