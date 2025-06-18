import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/gradient_button.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/bottom_richtext_link.dart';
import 'login_screen.dart';
import 'package:uicomponentsforgwm/main_navigation.dart';
import 'package:uicomponentsforgwm/services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;

  bool isLoading = false;
  bool obscurePassword = true;

  Future<void> _handleSignUp() async {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      isLoading = true;
    });

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        nameError = name.isEmpty ? 'Name is required' : null;
        emailError = email.isEmpty ? 'Email is required' : null;
        passwordError = password.isEmpty ? 'Password is required' : null;
        isLoading = false;
      });
      return;
    }

    try {
      final user = await AuthService.signUp(name, email, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
        );
      }
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      setState(() {
        if (errorMsg.contains('email')) {
          emailError = 'Invalid or already registered email';
        } else if (errorMsg.contains('password')) {
          passwordError = 'Weak or invalid password';
        } else {
          nameError = 'Something went wrong';
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
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Let’s get started by filling out the form below.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        hintText: 'Enter your name',
                        obscureText: false,
                        controller: nameController,
                        errorText: nameError,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Enter your email',
                        obscureText: false,
                        controller: emailController,
                        errorText: emailError,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Create a password',
                        obscureText: obscurePassword,
                        controller: passwordController,
                        errorText: passwordError,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: isLoading ? 'Creating...' : 'Sign Up',
                        onPressed: isLoading ? null : _handleSignUp,
                      ),
                      const SizedBox(height: 30),
                      GoogleSignInBtn(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MainNavigation()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: BottomRichTextLink(
                          text: 'Already have an account? ',
                          clickableText: 'Sign In',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),
                      Text(
                        'By creating an account you agree to our Terms and Privacy Policy.',
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
