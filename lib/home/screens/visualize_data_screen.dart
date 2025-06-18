import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uicomponentsforgwm/models/water_entry.dart';
import 'package:uicomponentsforgwm/services/firebase_service.dart';
import 'package:intl/intl.dart';

class VisualizeDataScreen extends StatefulWidget {
  const VisualizeDataScreen({super.key});
  @override
  State<VisualizeDataScreen> createState() => _VisualizeDataScreenState();
}

class _VisualizeDataScreenState extends State<VisualizeDataScreen> {
  List<WaterEntry> _allEntries = [];
  String? selectedState, selectedVillage, selectedTimeSpan;
  final timeSpans = ['Last 7 Days', 'Last 30 Days', 'This Year'];
  List<FlSpot> chartData = [];
  List<String> xLabels = [];
  final _gradient = const LinearGradient(
    colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    try {
      final entries = await FirebaseService.fetchEntryData();
      setState(() => _allEntries = entries);
    } catch (e) {
      // Handle fetch error if needed
    }
  }

  List<String> get states =>
      _allEntries.map((e) => e.state).toSet().toList()..sort();

  List<String> get villages {
    final vs = _allEntries
        .where((e) => e.state == selectedState)
        .map((e) => e.village)
        .toSet()
        .toList();
    vs.sort();
    return vs;
  }

  void _onVisualize() {
    // Determine cutoff based on time span
    DateTime cutoff = DateTime(2000);
    final now = DateTime.now();
    if (selectedTimeSpan == 'Last 7 Days') {
      cutoff = now.subtract(const Duration(days: 7));
    } else if (selectedTimeSpan == 'Last 30 Days')
      cutoff = now.subtract(const Duration(days: 30));
    else if (selectedTimeSpan == 'This Year')
      cutoff = DateTime(now.year);

    final filtered = _allEntries.where((e) {
      final entryDate = DateTime.parse(e.date);
      return e.state == selectedState &&
          (selectedVillage == null || e.village == selectedVillage) &&
          entryDate.isAfter(cutoff);
    }).toList();

    filtered.sort((a, b) => a.date.compareTo(b.date));

    chartData = [];
    xLabels = [];

    for (int i = 0; i < filtered.length; i++) {
      chartData.add(FlSpot(i.toDouble(), filtered[i].waterLevel));
      // Label with day/month or timegap
      xLabels.add(DateFormat('dd MMM').format(DateTime.parse(filtered[i].date)));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text("Visualize Data", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          // State + Village + TimeSpan dropdowns
          DropdownButtonFormField<String>(
            value: selectedState,
            hint: const Text("Select State"),
            items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() {
              selectedState = v;
              selectedVillage = null;
            }),
            decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedVillage,
            hint: const Text("Select Village"),
            items: villages.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
            onChanged: (v) => setState(() => selectedVillage = v),
            decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedTimeSpan,
            hint: const Text("Select Time Span"),
            items: timeSpans.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (v) => setState(() => selectedTimeSpan = v),
            decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          // Visualize button
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(gradient: _gradient, borderRadius: BorderRadius.circular(12)),
            child: ElevatedButton(
              onPressed: selectedState == null || selectedTimeSpan == null ? null : _onVisualize,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text("Visualize", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 24),
          // Chart area
          Expanded(
            child: chartData.isEmpty
                ? Center(child: Text("No data to display", style: GoogleFonts.poppins(color: Colors.grey)))
                : LineChart(LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(
                  showTitles: true,
                  interval: chartData.length > 5 ? (chartData.length / 5).floorToDouble() : 1,
                  getTitlesWidget: (v, _) {
                    final idx = v.toInt();
                    return idx >= 0 && idx < xLabels.length
                        ? Text(xLabels[idx], style: const TextStyle(fontSize: 10))
                        : const Text('');
                  },
                )),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 5)),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [LineChartBarData(
                spots: chartData,
                isCurved: true,
                gradient: _gradient,
                barWidth: 3,
                belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [Color(0xFFEEAECA).withOpacity(0.3), Color(0xFF94BBE9).withOpacity(0.3)])),
                dotData: FlDotData(show: true),
              )],
            )),
          ),
        ]),
      ),
    );
  }
}
