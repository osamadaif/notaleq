import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../domain/export_network_status.dart';

class ConnectivityExportNetworkStatus implements ExportNetworkStatus {
  ConnectivityExportNetworkStatus(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get hasConnection async {
    try {
      final connections = await _connectivity.checkConnectivity();
      return !connections.contains(ConnectivityResult.none);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
