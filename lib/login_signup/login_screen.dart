import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/gradient_button.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/bottom_richtext_link.dart';
import '../main_navigation.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          emailError = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          passwordError = 'Incorrect password';
        } else {
          emailError = 'Login failed: ${e.message}';
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        'Hi Welcome Back',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to your account',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        hintText: 'Enter your email',
                        obscureText: false,
                        controller: emailController,
                        errorText: emailError,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Enter your password',
                        obscureText: true,
                        controller: passwordController,
                        errorText: passwordError,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: isLoading ? 'Signing In...' : 'Sign In',
                        onPressed: isLoading ? null : () => loginUser(),
                      ),

                      const SizedBox(height: 30),
                      GoogleSignInBtn(
                        onPressed: () {
                          // Placeholder for Google login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainNavigation()),
                          );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),
                      Center(
                        child: BottomRichTextLink(
                          text: 'New to GWM? ',
                          clickableText: 'Create an account',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUpScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'By using our services you agree to our Terms and Privacy Policy.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
