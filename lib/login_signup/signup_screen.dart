import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/gradient_button.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/bottom_richtext_link.dart';
import 'login_screen.dart';
import 'package:uicomponentsforgwm/main_navigation.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Enter your email',
                        obscureText: false,
                        controller: emailController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'Create a password',
                        obscureText: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: 'Sign Up',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainNavigation()),
                          );
                          // TODO: Sign up logic
                        },
                      ),
                      const SizedBox(height: 30),
                      GoogleSignInBtn(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MainNavigation()),
                          );
                          // TODO: Google signup logic
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
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
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
