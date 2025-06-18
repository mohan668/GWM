import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uicomponentsforgwm/models/water_entry.dart';
import 'package:uicomponentsforgwm/services/firebase_service.dart';
import 'main_card.dart';

class AutoSliderCard extends StatefulWidget {
  const AutoSliderCard({super.key});

  @override
  State<AutoSliderCard> createState() => AutoSliderCardState();
}

class AutoSliderCardState extends State<AutoSliderCard> {
  final PageController _pageController = PageController(initialPage: 1000);
  int _currentPage = 1000;
  late Timer _timer;
  List<WaterEntry> _entries = [];
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && _entries.isNotEmpty) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  /// Public method to trigger refresh externally
  void refresh() {
    _loadEntries();
  }

  void _loadEntries() async {
    try {
      final entries = await FirebaseService.fetchEntryData();
      if (mounted) {
        setState(() {
          _entries = entries.reversed.toList();
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _entries = [];
        });
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty && !_hasError) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_entries.isEmpty && _hasError) {
      return const Center(child: Text("Failed to load data"));
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          final data = _entries[index % _entries.length];
          return MainCard(
            wellId: data.wellId,
            state: data.state,
            village: data.village,
            waterLevel: data.waterLevel,
            date: DateFormat('dd MMM').format(DateTime.parse(data.date)),
          );
        },
      ),
    );
  }
}
