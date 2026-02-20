import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/colors/app_color.dart';
import '../../core/extensions/theme_extension.dart';
import 'login_state.dart';
import 'login_view_model.dart';

typedef HandleLogin = void Function();

class LoginButton extends StatelessWidget {
  // final HandleLogin handleLogin;
  final FocusNode loginFocus;

  const LoginButton({
    super.key,
    // required this.handleLogin,
    required this.loginFocus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder<LoginViewModel, LoginState>(
          builder: (context, state) {
            final isLoading = state is LoginLoadingState;
            return Container(
              decoration: BoxDecoration(gradient: AppColor.buttonLoginGradient),
              child: isLoading
                  ? Row(
                      children: [
                        ElevatedButton(
                          focusNode: loginFocus,
                          onPressed: isLoading ? null : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: context.fonts.titleMedium?.copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        CircularProgressIndicator(
                          color: AppColor.brightMagenta,
                        ),
                      ],
                    )
                  : ElevatedButton(
                      focusNode: loginFocus,
                      onPressed: isLoading ? null : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: context.fonts.titleMedium?.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }
}
