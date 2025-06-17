import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uicomponentsforgwm/utils/constants.dart';

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
              foreground: Paint()
                ..shader = kGradient.createShader(
                  const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                ),
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
