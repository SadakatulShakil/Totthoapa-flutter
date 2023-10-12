import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

enum ConnectivityStatus { Online, Offline }

class ConnectivityProvider with ChangeNotifier {
  ConnectivityStatus _status = ConnectivityStatus.Offline;

  ConnectivityProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      _status = result == ConnectivityResult.none
          ? ConnectivityStatus.Offline
          : ConnectivityStatus.Online;

      notifyListeners();
    });
  }

  ConnectivityStatus get status => _status;
}
