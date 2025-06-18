import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicomponentsforgwm/services/firebase_service.dart';
import 'package:uicomponentsforgwm/models/water_entry.dart';
import 'package:uicomponentsforgwm/data_edit_delete/widgets/entry_tile.dart';

class EditDeleteScreen extends StatefulWidget {
  final VoidCallback onDataUpdated;

  const EditDeleteScreen({super.key, required this.onDataUpdated});

  @override
  State<EditDeleteScreen> createState() => _EditDeleteScreenState();
}

class _EditDeleteScreenState extends State<EditDeleteScreen> {
  late Future<List<WaterEntry>> _futureEntries;

  @override
  void initState() {
    super.initState();
    _refreshEntries();
  }

  void _refreshEntries() {
    setState(() {
      _futureEntries = FirebaseService.fetchEntryData();
    });

    // Trigger refresh on AutoSliderCard as well
    widget.onDataUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit or Delete Data",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<WaterEntry>>(
        future: _futureEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(),
              ),
            );
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Text(
                'No data available.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: entries.reversed
                .map((entry) => EntryTile(
              entry: entry,
              onRefresh: _refreshEntries,
            ))
                .toList(),
          );
        },
      ),
    );
  }
}
