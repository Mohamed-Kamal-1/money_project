import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../core/colors/app_color.dart';
import '../../core/extensions/theme_extension.dart';
import 'login_state.dart';
import 'login_view_model.dart';

class LoginBottomSection extends StatelessWidget {
  const LoginBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\'t Have Account ? ',
              style: context.fonts.bodyMedium?.copyWith(color: AppColor.white),
            ),

            Text(
              'Create One',
              style: context.fonts.bodyMedium?.copyWith(color: AppColor.brightMagenta),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Row(
            children: [
              Expanded(child: Divider(color: AppColor.brightMagenta)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.whiteGlass,
                  ),
                ),
              ),
              Expanded(child: Divider(color: AppColor.whiteGlass)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        BlocBuilder<LoginViewModel, LoginState>(
          builder: (context, state) {
            final isLoading = state is LoginLoadingState;
            return ElevatedButton.icon(
              onPressed: () {},
              // onPressed: isLoading ? null : _handleGoogleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.whiteGlass,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: Icon(AntDesign.google_circle_fill),
              label: Text(
                'Login With Google',
                style: context.fonts.titleMedium?.copyWith(
                  color: AppColor.white,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
