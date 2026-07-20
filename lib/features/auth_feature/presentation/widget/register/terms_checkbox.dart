import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/core/colors/app_color.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColor.blueStart,
          checkColor: Colors.white,
          side: const BorderSide(color: AppColor.borderGray),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.cairo(fontSize: 14, color: AppColor.gray),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service and Privacy Policy',
                  style: const TextStyle(
                    color: AppColor.blueStart,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
