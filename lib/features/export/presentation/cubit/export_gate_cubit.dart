import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ads/rewarded_ad_manager.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/export_network_status.dart';
import 'export_gate_state.dart';

class ExportGateCubit extends Cubit<ExportGateState> {
  ExportGateCubit(this._networkStatus, this._rewardedAds)
    : super(const ExportGateState.initial());

  static const Duration _adLoadTimeout = Duration(seconds: 20);

  final ExportNetworkStatus _networkStatus;
  final RewardedAdManager _rewardedAds;
  int _attemptId = 0;
  bool _isCheckingConnectivity = false;

  Future<void> begin() async {
    if (_isCheckingConnectivity || _isBusy) return;
    _isCheckingConnectivity = true;
    final attemptId = ++_attemptId;
    final hasConnection = await _networkStatus.hasConnection;
    _isCheckingConnectivity = false;
    if (!_isCurrent(attemptId)) return;
    emit(
      hasConnection
          ? const ExportGateState.awaitingOptIn()
          : const ExportGateState.offline(),
    );
  }

  Future<bool> prepareAd() async {
    if (state is! ExportGateAwaitingOptIn) return false;
    final attemptId = ++_attemptId;
    if (_rewardedAds.isReady) {
      emit(const ExportGateState.showingAd());
      return true;
    }

    emit(const ExportGateState.loadingAd());
    try {
      await _rewardedAds.preload().timeout(_adLoadTimeout);
    } on TimeoutException {
      if (_isCurrent(attemptId)) {
        emit(const ExportGateState.error(AdLoadFailure('ad_failed')));
      }
      return false;
    }
    if (!_isCurrent(attemptId)) return false;
    if (!_rewardedAds.isReady) {
      emit(const ExportGateState.error(AdLoadFailure('ad_failed')));
      return false;
    }
    emit(const ExportGateState.showingAd());
    return true;
  }

  Future<void> showPreparedAd() async {
    if (state is! ExportGateShowingAd) return;
    final attemptId = _attemptId;
    final outcome = await _rewardedAds.showForExport();
    if (!_isCurrent(attemptId)) return;
    outcome.match(
      (failure) => emit(ExportGateState.error(failure)),
      (_) => emit(const ExportGateState.unlocked()),
    );
  }

  void cancel() => reset();

  void reset() {
    _attemptId++;
    _isCheckingConnectivity = false;
    emit(const ExportGateState.initial());
  }

  bool get _isBusy =>
      state is ExportGateLoadingAd || state is ExportGateShowingAd;

  bool _isCurrent(int attemptId) => !isClosed && attemptId == _attemptId;
}
