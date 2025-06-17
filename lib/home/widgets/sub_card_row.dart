import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicomponentsforgwm/data_edit_delete/screens/edit_delete_screen.dart';
import '../screens/visualize_data_screen.dart'; // Update with correct path

class SubCardsGrid extends StatelessWidget {
  const SubCardsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final List<String> cardTitles = [
      "Edit or Delete Data",
      "Search Data",
      "Visualize Data",
      "Compare Data",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: [
          // First row (0, 1)
          Row(
            children: List.generate(2, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EditDeleteScreen()),
                      );
                    } else if (index == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VisualizeDataScreen()),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    height: 120,
                    decoration: BoxDecoration(
                      color: index == 0 ? null : Colors.white,
                      gradient: index == 0 ? gradient : null,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        cardTitles[index],
                        style: GoogleFonts.poppins(
                          color: index == 0 ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          // Second row (2, 3)
          Row(
            children: List.generate(2, (index) {
              int cardIndex = index + 2;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (cardIndex == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const VisualizeDataScreen()),
                      );
                    } else if (cardIndex == 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Compare Data not implemented")),
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        cardTitles[cardIndex],
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
