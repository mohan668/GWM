import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'entry_submit_button.dart';

class EntryForm extends StatefulWidget {
  const EntryForm({super.key});

  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  final TextEditingController _wellIdController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _waterLevelController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF94BBE9),
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      _dateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  InputDecoration _buildInputDecoration(String hint, {Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 10,
      ),
      child: Column(
        children: [
          TextField(
            controller: _wellIdController,
            decoration: _buildInputDecoration("Well ID"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _stateController,
            decoration: _buildInputDecoration("State"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _villageController,
            decoration: _buildInputDecoration("Village"),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _dateController,
            keyboardType: TextInputType.datetime,
            decoration: _buildInputDecoration(
              "Date (DD-MM-YYYY)",
              suffix: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _waterLevelController,
            decoration: _buildInputDecoration("Water Level (in meters)"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 30),
          EntrySubmitButton(
            wellIdController: _wellIdController,
            stateController: _stateController,
            villageController: _villageController,
            dateController: _dateController,
            waterLevelController: _waterLevelController,
          ),
        ],
      ),
    );
  }
}
