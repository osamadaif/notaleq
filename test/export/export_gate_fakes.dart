import 'package:fpdart/fpdart.dart';
import 'package:notaleq/core/ads/rewarded_ad_manager.dart';
import 'package:notaleq/core/errors/failures.dart';
import 'package:notaleq/features/export/domain/export_network_status.dart';

class FakeExportNetworkStatus implements ExportNetworkStatus {
  FakeExportNetworkStatus({this.connected = true});

  bool connected;

  @override
  Future<bool> get hasConnection async => connected;
}

class FakeRewardedAdManager implements RewardedAdManager {
  FakeRewardedAdManager({
    this.ready = false,
    this.preloadSucceeds = true,
    this.showOutcome = const Right(unit),
  });

  bool ready;
  bool preloadSucceeds;
  Either<Failures, Unit> showOutcome;
  int showCount = 0;

  @override
  bool get isReady => ready;

  @override
  Future<void> preload() async {
    ready = preloadSucceeds;
  }

  @override
  Future<Either<Failures, Unit>> showForExport() async {
    showCount++;
    ready = false;
    return showOutcome;
  }
}
