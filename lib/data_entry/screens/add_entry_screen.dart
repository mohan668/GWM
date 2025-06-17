import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/entry_form.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add Entry", style: GoogleFonts.poppins(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const EntryForm(),
    );
  }
}
