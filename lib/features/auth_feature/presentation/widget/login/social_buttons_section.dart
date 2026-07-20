import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/features/auth_feature/presentation/widget/login/social_button.dart';

class SocialButtonsSection extends StatelessWidget {
  const SocialButtonsSection({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Social Sign In coming soon'),
        backgroundColor: AppColor.amberOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialButton(
            label: 'Google',
            icon: Icons.g_mobiledata,
            color: Colors.redAccent,
            onTap: () => _showComingSoon(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialButton(
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
