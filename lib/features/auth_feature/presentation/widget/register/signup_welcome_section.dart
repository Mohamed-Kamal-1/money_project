import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/core/colors/app_color.dart';

class SignupWelcomeSection extends StatelessWidget {
  const SignupWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start your journey to financial wellness',
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(fontSize: 16, color: AppColor.gray),
        ),
      ],
    );
  }
}
