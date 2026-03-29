import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../localization/main_texts.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../snackbar_toast/snack_bar.dart';

/// Manages the network connectivity status and provides methods to check and handle connectivity changes.
class NetworkManager with ChangeNotifier {
  static NetworkManager get instance => _instance;
  static final NetworkManager _instance = NetworkManager._internal();

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final ValueNotifier<List<ConnectivityResult>> _connectionStatus =
      ValueNotifier<List<ConnectivityResult>>([ConnectivityResult.none]);

  NetworkManager._internal() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  ValueNotifier<List<ConnectivityResult>> get connectionStatus =>
      _connectionStatus;

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus.value = result;
    if (_connectionStatus.value.contains(ConnectivityResult.none)) {
      DSnackBar.warning(title: DTexts.instance.noInternetConnection);
    }
    notifyListeners();
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (!result.contains(ConnectivityResult.none)) {
        return true;
      }

      // Fallback: Check actual internet access
      try {
        final list = await InternetAddress.lookup('google.com');
        return list.isNotEmpty && list[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        return false;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
