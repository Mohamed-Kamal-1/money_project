import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/core/colors/app_color.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Forgot password feature coming soon'),
              backgroundColor: AppColor.amberOrange,
            ),
          );
        },
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.cairo(
            color: AppColor.blueStart,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
