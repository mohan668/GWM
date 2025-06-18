import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/water_entry.dart';
import '../../../services/firebase_service.dart';

class EditEntryDialog extends StatefulWidget {
  final WaterEntry entry;
  final VoidCallback onUpdate;

  const EditEntryDialog({super.key, required this.entry, required this.onUpdate});

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  late TextEditingController stateController;
  late TextEditingController villageController;
  late TextEditingController waterLevelController;

  @override
  void initState() {
    super.initState();
    stateController = TextEditingController(text: widget.entry.state);
    villageController = TextEditingController(text: widget.entry.village);
    waterLevelController = TextEditingController(text: widget.entry.waterLevel.toString());
  }

  @override
  void dispose() {
    stateController.dispose();
    villageController.dispose();
    waterLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Entry",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stateController,
                decoration: InputDecoration(
                  labelText: "State",
                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: villageController,
                decoration: InputDecoration(
                  labelText: "Village",
                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: waterLevelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Water Level (m)",
                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final updatedEntry = WaterEntry(
                      wellId: widget.entry.wellId,
                      state: stateController.text,
                      village: villageController.text,
                      waterLevel: double.tryParse(waterLevelController.text) ?? 0.0,
                      date: widget.entry.date,
                    );

                    try {
                      await FirebaseService.updateEntry(updatedEntry);
                      widget.onUpdate();
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Update failed: $e")),
                      );
                    }
                  },
                  child: Text(
                    "Update",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
