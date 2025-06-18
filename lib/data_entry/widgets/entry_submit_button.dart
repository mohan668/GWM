import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../services/firebase_service.dart';

class EntrySubmitButton extends StatelessWidget {
  final TextEditingController wellIdController;
  final TextEditingController stateController;
  final TextEditingController villageController;
  final TextEditingController dateController;
  final TextEditingController waterLevelController;

  const EntrySubmitButton({
    super.key,
    required this.wellIdController,
    required this.stateController,
    required this.villageController,
    required this.dateController,
    required this.waterLevelController,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: ElevatedButton(
        onPressed: () async {
          final wellId = wellIdController.text.trim();
          final state = stateController.text.trim();
          final village = villageController.text.trim();
          final dateText = dateController.text.trim();
          final waterLevelText = waterLevelController.text.trim();

          if (wellId.isEmpty || state.isEmpty || village.isEmpty || dateText.isEmpty || waterLevelText.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please fill all fields")),
            );
            return;
          }

          try {
            final inputFormat = DateFormat('dd-MM-yyyy');
            final outputFormat = DateFormat('yyyy-MM-dd');
            final formattedDate = outputFormat.format(inputFormat.parse(dateText));

            final data = {
              "well_id": wellId,
              "state": state,
              "village": village,
              "date": formattedDate,
              "water_level": double.tryParse(waterLevelText),
            };

            await FirebaseService.uploadEntryData(data, context);

            // Clear fields
            wellIdController.clear();
            stateController.clear();
            villageController.clear();
            dateController.clear();
            waterLevelController.clear();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid date format")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          "Submit",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
