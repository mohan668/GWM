import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/errors/no_internet.dart'; // Your no internet screen
import 'package:uicomponentsforgwm/main_navigation.dart';

class ConnectivityWrapper extends StatefulWidget {
  const ConnectivityWrapper({super.key});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final bool isConnected =
          results.isNotEmpty && results.first != ConnectivityResult.none;

      if (isConnected != _hasInternet) {
        setState(() {
          _hasInternet = isConnected;
        });
      }
    });
  }

  Future<void> _checkInitialConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    final isConnected = results != ConnectivityResult.none;
    setState(() {
      _hasInternet = isConnected;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hasInternet
        ? const MainNavigation()
        : NoInternetPage(onRetry: _checkInitialConnectivity);

  }
}
