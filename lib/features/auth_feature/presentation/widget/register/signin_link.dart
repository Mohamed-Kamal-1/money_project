import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/core/colors/app_color.dart';

class SigninLink extends StatelessWidget {
  const SigninLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: GoogleFonts.cairo(color: AppColor.gray, fontSize: 14),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // العودة إلى شاشة تسجيل الدخول
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 30),
          ),
          child: Text(
            'Sign in',
            style: GoogleFonts.cairo(
              color: AppColor.blueStart,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
