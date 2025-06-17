import 'package:flutter/material.dart';
import '../widgets/app_bar_section.dart';
import '../widgets/auto_slider_card.dart';
import '../widgets/sub_card_row.dart';
import 'package:uicomponentsforgwm/utils/network_checker.dart';
import '/errors/no_internet.dart';
import '/errors/server_error.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  bool _hasInternet = true;
  bool _serverError = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    bool isConnected = await NetworkChecker.isConnected();
    if (!isConnected) {
      setState(() {
        _hasInternet = false;
        _loading = false;
      });
      return;
    }

    try {
      // Simulate API ping or fetch
      // If this fails, it's a server error
      await Future.delayed(const Duration(milliseconds: 500)); // or make a real request
      setState(() {
        _hasInternet = true;
        _serverError = false;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _serverError = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasInternet) {
      return NoInternetPage(onRetry: _checkStatus);
    }

    if (_serverError) {
      return ServerErrorPage(onRetry: _checkStatus);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              CustomAppBar(),
              AutoSliderCard(),
              SubCardsGrid(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
