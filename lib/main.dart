import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

// Navigation and screens
import 'main_navigation.dart';
import '/errors/no_internet.dart';
import '/errors/server_error.dart';
import 'login_signup/login_screen.dart'; // <-- New import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasInternet = true;
  bool _serverOnline = true;
  late StreamSubscription _connectivitySubscription;
  Timer? _serverCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkInitialStatus();
    });

    _serverCheckTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkServerStatus();
    });
  }

  Future<void> _checkInitialStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      final isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      setState(() => _hasInternet = isConnected);
    } catch (_) {
      setState(() => _hasInternet = false);
    }
  }

  Future<void> _checkServerStatus() async {
    if (!_hasInternet) {
      setState(() => _serverOnline = true); // Skip checking if no internet
      return;
    }

    try {
      final response = await http
          .get(Uri.parse('http://192.168.43.44:8000/get_water_data'))
          .timeout(const Duration(seconds: 3));
      setState(() => _serverOnline = response.statusCode == 200);
    } catch (_) {
      setState(() => _serverOnline = false);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _serverCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ground Water Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: !_hasInternet
          ? NoInternetPage(onRetry: _checkInitialStatus)
          : !_serverOnline
          ? ServerErrorPage(onRetry: _checkServerStatus)
          : const LoginScreen(), // <- Start from Login
    );
  }
}
