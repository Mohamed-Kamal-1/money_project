import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/home/presentation/view/home_tab.dart';

import '../view_model/cubit/auth_cubit.dart';
import '../view_model/cubit/auth_state.dart';
import '../widget/login/email_field.dart';
import '../widget/login/forgot_password_button.dart';
import '../widget/login/or_divider.dart';
import '../widget/login/password_field.dart';
import '../widget/login/sign_in_button.dart';
import '../widget/login/sign_up_link.dart';
import '../widget/login/social_buttons_section.dart';
import '../widget/login/welcome_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeTab(userId: state.user.uid),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColor.lightRed,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimension.padding24,
                vertical: Dimension.padding32,
              ),
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 1. Welcome Section
                        const WelcomeSection(),
                        const SizedBox(height: 32),

                        // 2. Email Field
                        EmailField(controller: _emailController),
                        const SizedBox(height: 16),

                        // 3. Password Field
                        PasswordField(
                          controller: _passwordController,
                          obscurePassword: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 8),

                        // 4. Forgot Password
                        const ForgotPasswordButton(),
                        const SizedBox(height: 24),

                        // 5. Sign In Button
                        SignInButton(isLoading: isLoading, onPressed: _submit),
                        const SizedBox(height: 24),

                        // 6. OR Divider
                        const OrDivider(),
                        const SizedBox(height: 24),

                        // 7. Social Buttons
                        const SocialButtonsSection(),
                        const SizedBox(height: 32),

                        // 8. Sign Up Link
                        const SignUpLink(),
                        const SizedBox(height: 16),

                        // 9. Demo Note
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
