import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomRichTextLink extends StatelessWidget {
  final String text;
  final String clickableText;
  final VoidCallback onTap;

  const BottomRichTextLink({
    super.key,
    required this.text,
    required this.clickableText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.grey,
        ),
        children: [
          TextSpan(text: text),
          TextSpan(
            text: clickableText,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFC8B2D6),
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
