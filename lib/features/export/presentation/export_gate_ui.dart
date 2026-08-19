import 'package:flutter/material.dart';

import '../../../core/errors/failures.dart';
import '../../../core/language/app_localizations.dart';
import '../../../core/language/language_keys.dart';
import 'cubit/export_gate_cubit.dart';
import 'cubit/export_gate_state.dart';

Future<bool> requestRewardedExport(
  BuildContext context,
  ExportGateCubit exportGate,
) => _RewardedExportFlow(context, exportGate).run();

enum _FlowAction { proceed, retry, cancel, unlocked }

class _RewardedExportFlow {
  const _RewardedExportFlow(this.context, this.exportGate);

  final BuildContext context;
  final ExportGateCubit exportGate;

  Future<bool> run() async {
    while (context.mounted) {
      final connectivityAction = await _connectivityAction();
      if (connectivityAction == _FlowAction.cancel) return false;
      if (connectivityAction == _FlowAction.retry) continue;

      if (await _optInAction() == _FlowAction.cancel) return false;
      final preparationAction = await _preparationAction();
      if (preparationAction == _FlowAction.cancel) return false;
      if (preparationAction == _FlowAction.retry) continue;

      final rewardAction = await _rewardAction();
      if (rewardAction == _FlowAction.unlocked) return true;
      if (rewardAction == _FlowAction.cancel) return false;
    }
    return false;
  }

  Future<_FlowAction> _connectivityAction() async {
    await exportGate.begin();
    if (!context.mounted) return _FlowAction.cancel;
    if (exportGate.state is! ExportGateOffline) return _FlowAction.proceed;
    return _retryAction(LangKeys.exportRequiresInternet);
  }

  Future<_FlowAction> _optInAction() async {
    final optedIn = await _showOptInDialog(context);
    if (optedIn && context.mounted) return _FlowAction.proceed;
    exportGate.cancel();
    return _FlowAction.cancel;
  }

  Future<_FlowAction> _preparationAction() async {
    final prepared = await _prepareAd(context, exportGate);
    if (!context.mounted || exportGate.state is ExportGateInitial) {
      return _FlowAction.cancel;
    }
    if (prepared) return _FlowAction.proceed;
    return _retryAction(LangKeys.adFailed);
  }

  Future<_FlowAction> _rewardAction() async {
    await exportGate.showPreparedAd();
    if (!context.mounted) return _FlowAction.cancel;
    if (exportGate.state is ExportGateUnlocked) {
      exportGate.reset();
      return _FlowAction.unlocked;
    }
    final gateState = exportGate.state;
    if (gateState is ExportGateError &&
        gateState.failure is AdDismissedFailure) {
      _showMessage(context, LangKeys.adDismissed);
      exportGate.reset();
      return _FlowAction.cancel;
    }
    return _retryAction(LangKeys.adFailed);
  }

  Future<_FlowAction> _retryAction(String messageKey) async {
    final retry = await _showRetryDialog(context, messageKey: messageKey);
    if (!retry) {
      exportGate.cancel();
      return _FlowAction.cancel;
    }
    exportGate.reset();
    return _FlowAction.retry;
  }
}

Future<bool> _prepareAd(
  BuildContext context,
  ExportGateCubit exportGate,
) async {
  final preparation = exportGate.prepareAd();
  if (exportGate.state is! ExportGateLoadingAd) return preparation;

  final cancelled = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) =>
        _AdLoadingDialog(preparation: preparation, onCancel: exportGate.cancel),
  );
  if (cancelled == true) return false;
  return preparation;
}

Future<bool> _showOptInDialog(BuildContext context) async {
  final watchAd = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(dialogContext.tr(LangKeys.exportAdTitle)),
      content: Text(dialogContext.tr(LangKeys.exportAdBody)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(dialogContext.tr(LangKeys.cancel)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(dialogContext.tr(LangKeys.watchAd)),
        ),
      ],
    ),
  );
  return watchAd ?? false;
}

Future<bool> _showRetryDialog(
  BuildContext context, {
  required String messageKey,
}) async {
  final retry = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      content: Text(dialogContext.tr(messageKey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(dialogContext.tr(LangKeys.cancel)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(dialogContext.tr(LangKeys.retry)),
        ),
      ],
    ),
  );
  return retry ?? false;
}

void _showMessage(BuildContext context, String messageKey) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(context.tr(messageKey))));
}

class _AdLoadingDialog extends StatefulWidget {
  const _AdLoadingDialog({required this.preparation, required this.onCancel});

  final Future<bool> preparation;
  final VoidCallback onCancel;

  @override
  State<_AdLoadingDialog> createState() => _AdLoadingDialogState();
}

class _AdLoadingDialogState extends State<_AdLoadingDialog> {
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    widget.preparation.whenComplete(() {
      if (mounted && !_dismissed) Navigator.of(context).pop(false);
    });
  }

  void _cancel() {
    _dismissed = true;
    widget.onCancel();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(context.tr(LangKeys.loadingAd))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text(context.tr(LangKeys.cancel)),
        ),
      ],
    );
  }
}
