import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/toast_helper.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  bool _isInitialCheck = true;
  
  // ✅ Advanced Features
  final RxBool isOffline = false.obs;
  final RxBool isLowNetworkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    final result = await _connectivity.checkConnectivity();
    _handleConnectivityResult(result);
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    if (_isInitialCheck) {
      _isInitialCheck = false;
      return;
    }
    _handleConnectivityResult(results);
  }

  void _handleConnectivityResult(List<ConnectivityResult> results) {
    final offline = results.isEmpty || results.contains(ConnectivityResult.none);
    isOffline.value = offline;

    // ✅ Detect Low Network (Mobile Data vs WiFi)
    isLowNetworkMode.value = results.contains(ConnectivityResult.mobile);

    if (offline) {
      _showOfflineSnackbar();
    } else {
      if (!_isInitialCheck) {
        Get.closeAllSnackbars();
        ToastHelper.showSuccess("You are back online!", title: "Connected");
      }
    }
  }

  void _showOfflineSnackbar() {
    Get.rawSnackbar(
      title: "No Internet Connection",
      message: "Please check your network settings.",
      isDismissible: false,
      backgroundColor: Colors.red.shade800,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      mainButton: TextButton(
        onPressed: () => retryConnection(),
        child: const Text("RETRY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // ✅ Retry Logic
  Future<void> retryConnection() async {
    ToastHelper.showInfo("Attempting to reconnect...", title: "Connecting");
    await Future.delayed(const Duration(seconds: 1));
    _checkInitialStatus();
  }
}
