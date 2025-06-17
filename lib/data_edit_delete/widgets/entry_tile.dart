import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uicomponentsforgwm/models/water_entry.dart';
import 'package:uicomponentsforgwm/services/wifi_service.dart';
import 'package:uicomponentsforgwm/data_edit_delete/widgets/edit_entry_dialog.dart';
import 'delete_confirmation_dialog.dart';

class EntryTile extends StatelessWidget {
  final WaterEntry entry;
  final VoidCallback onRefresh;

  const EntryTile({
    super.key,
    required this.entry,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(entry.date));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 6)],
      ),
      child: ListTile(
        title: Text(entry.wellId, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text('${entry.state}, ${entry.village}\n$formattedDate — ${entry.waterLevel}m',
            style: GoogleFonts.poppins(color: Colors.white70)),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => EditEntryDialog(
                    entry: entry,
                    onUpdate: onRefresh,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => DeleteConfirmationDialog(),
                );

                if (confirm == true) {
                  await WaterService.deleteEntry(entry.wellId, entry.date);
                  onRefresh();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
