import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'login_signup/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color highlightColor = Color(0xFFC8B2D6); // Your gradient end color

    return MaterialApp(
      title: 'Ground Water Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(),

        // Remove ripple/tint color effects
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,

        // Color scheme to remove default Material colors
        colorScheme: ColorScheme.fromSeed(
          seedColor: highlightColor,
          surface: backgroundColor,
        ),

        // Progress indicator color
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: highlightColor,
        ),

        // Text selection theme
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: highlightColor,
          selectionColor: highlightColor,
          selectionHandleColor: highlightColor,
        ),

        // Copy/paste toolbar background styling
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
