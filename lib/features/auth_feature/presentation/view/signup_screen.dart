import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/features/home/presentation/view/home_tab.dart';

import '../view_model/cubit/auth_cubit.dart';
import '../view_model/cubit/auth_state.dart';
import '../widget/login/or_divider.dart';
import '../widget/register/confirm_password_field.dart';
import '../widget/register/create_account_button.dart';
import '../widget/register/full_name_field.dart';
import '../widget/register/signin_link.dart';
import '../widget/register/signup_email_field.dart';
import '../widget/register/signup_password_field.dart';
import '../widget/register/signup_social_buttons_section.dart';
import '../widget/register/signup_welcome_section.dart';
import '../widget/register/terms_checkbox.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      context.read<AuthCubit>().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _fullNameController.text.trim(),
      );
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms of Service'),
          backgroundColor: AppColor.amberOrange,
        ),
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
                        const SignupWelcomeSection(),
                        const SizedBox(height: 32),

                        // 2. Full Name Field
                        FullNameField(controller: _fullNameController),
                        const SizedBox(height: 16),

                        // 3. Email Field
                        SignupEmailField(controller: _emailController),
                        const SizedBox(height: 16),

                        // 4. Password Field
                        SignupPasswordField(
                          controller: _passwordController,
                          obscurePassword: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // 5. Confirm Password Field
                        ConfirmPasswordField(
                          controller: _confirmPasswordController,
                          obscurePassword: _obscureConfirmPassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                          passwordController: _passwordController,
                        ),
                        const SizedBox(height: 16),

                        // 6. Terms Checkbox
                        TermsCheckbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),

                        // 7. Create Account Button
                        CreateAccountButton(
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: 24),

                        // 8. OR Divider
                        const OrDivider(),
                        const SizedBox(height: 24),

                        // 9. Social Buttons
                        const SignupSocialButtonsSection(),
                        const SizedBox(height: 32),

                        // 10. Sign In Link
                        const SigninLink(),
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
