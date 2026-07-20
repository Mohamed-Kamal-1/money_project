import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';

import 'signup_social_button.dart';

class SignupSocialButtonsSection extends StatelessWidget {
  const SignupSocialButtonsSection({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Social Sign Up coming soon'),
        backgroundColor: AppColor.amberOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SignupSocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata,
            color: Colors.redAccent,
            onTap: () => _showComingSoon(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SignupSocialButton(
            label: 'GitHub',
            icon: Icons.code,
            color: AppColor.softLavender,
            onTap: () => _showComingSoon(context),
          ),
        ),
      ],
    );
  }
}
