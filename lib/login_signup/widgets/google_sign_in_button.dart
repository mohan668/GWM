import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleSignInBtn extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInBtn({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: SignInButton(
        Buttons.google,
        text: "Sign in with Google",
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
