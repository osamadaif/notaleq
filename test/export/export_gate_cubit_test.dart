import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:notaleq/core/errors/failures.dart';
import 'package:notaleq/features/export/presentation/cubit/export_gate_cubit.dart';
import 'package:notaleq/features/export/presentation/cubit/export_gate_state.dart';

import 'export_gate_fakes.dart';

void main() {
  late FakeExportNetworkStatus networkStatus;
  late FakeRewardedAdManager rewardedAds;
  late ExportGateCubit exportGate;

  setUp(() {
    networkStatus = FakeExportNetworkStatus();
    rewardedAds = FakeRewardedAdManager();
    exportGate = ExportGateCubit(networkStatus, rewardedAds);
  });

  tearDown(() => exportGate.close());

  test('offline export attempt stops before opt-in', () async {
    networkStatus.connected = false;

    await exportGate.begin();

    expect(exportGate.state, isA<ExportGateOffline>());
    expect(rewardedAds.showCount, 0);
  });

  test('cancelled opt-in returns to initial without showing an ad', () async {
    await exportGate.begin();
    expect(exportGate.state, isA<ExportGateAwaitingOptIn>());

    exportGate.cancel();
    await exportGate.showPreparedAd();

    expect(exportGate.state, isA<ExportGateInitial>());
    expect(rewardedAds.showCount, 0);
  });

  test('failed ad load keeps export locked', () async {
    rewardedAds.preloadSucceeds = false;
    await exportGate.begin();

    final prepared = await exportGate.prepareAd();

    expect(prepared, isFalse);
    expect(exportGate.state, isA<ExportGateError>());
    expect((exportGate.state as ExportGateError).failure, isA<AdLoadFailure>());
  });

  test('dismissal before reward keeps export locked', () async {
    rewardedAds
      ..ready = true
      ..showOutcome = const Left(AdDismissedFailure('ad_dismissed'));
    await exportGate.begin();
    expect(await exportGate.prepareAd(), isTrue);

    await exportGate.showPreparedAd();

    expect(exportGate.state, isA<ExportGateError>());
    expect(
      (exportGate.state as ExportGateError).failure,
      isA<AdDismissedFailure>(),
    );
  });

  test('earned reward unlocks current attempt and reset clears it', () async {
    rewardedAds.ready = true;
    await exportGate.begin();
    expect(await exportGate.prepareAd(), isTrue);

    await exportGate.showPreparedAd();

    expect(exportGate.state, isA<ExportGateUnlocked>());
    expect(rewardedAds.showCount, 1);
    exportGate.reset();
    expect(exportGate.state, isA<ExportGateInitial>());
  });
}
