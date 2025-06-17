import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainCard extends StatelessWidget {
  final String? wellId;
  final String? state;
  final String? village;
  final double waterLevel;
  final String? date;

  const MainCard({
    super.key,
    this.wellId,
    this.state,
    this.village,
    required this.waterLevel,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFFEEAECA), Color(0xFF94BBE9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // If water level is less than 0, treat as missing
    final String waterLevelDisplay = waterLevel >= 0
        ? '${waterLevel.toStringAsFixed(1)}m'
        : '---';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      height: 220,
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // LEFT
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Well ID",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[900])),
                        const SizedBox(height: 4),
                        Text(wellId ?? "---",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[800])),
                        const SizedBox(height: 16),
                        Text("State",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[900])),
                        const SizedBox(height: 4),
                        Text(state ?? "---",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800])),
                      ],
                    ),

                    // RIGHT
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              waterLevelDisplay,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Village: ${village ?? "---"}",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey[900])),
                  Text(date ?? "---",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
