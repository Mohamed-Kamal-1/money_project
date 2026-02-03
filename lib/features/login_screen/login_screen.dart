import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/dimensions/Dimension_app.dart';

import '../../core/AppFromField.dart';
import '../../core/colors/app_color.dart';
import '../../core/dimensions/radius_app.dart';
import '../../core/routes/app_route.dart';
import '../../core/validators.dart';
import 'login_bottom_section.dart';
import 'login_button.dart';
import 'login_state.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _loginFocus = FocusNode();
  final LoginViewModel _viewModel = LoginViewModel();
  Timer? _debounce;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _debounce?.cancel();
    _loginFocus.dispose();
  }

  //
  // void _handleLogin() {
  //   if (formKey.currentState?.validate() ?? false) {
  //     _viewModel.login(
  //       _emailController.text.trim(),
  //       _passwordController.text,
  //     );
  //   }
  // }

  void changeFocusInput(String? text, FocusNode focusInput) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (text != null && text.trim().isNotEmpty) {
        FocusScope.of(context).requestFocus(focusInput);
      }
    });
  }

  void _handleGoogleLogin() {
    // _viewModel.loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _viewModel,
      child: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            Navigator.pushReplacementNamed(context, AppRoute.HomeTab.name);
          } else if (state is LoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('no'),
                // content: Text(context.getErrorMessage(state.errorMessage)),
                backgroundColor: AppColor.whiteGlass,
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        minHeight: 600,
                      ),
                      child: IntrinsicHeight(
                        child: Form(
                          key: formKey,
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                horizontal: Dimension.padding24,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimension.padding24,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  RadiusApp.circular24,
                                ),
                                color: AppColor.whiteGlass,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                            
                                spacing: Dimension.spacing16,
                                children: [
                                  Text('Email Address'),
                                  AppFormField(
                                    focusNode: _emailFocus,
                                    onChange: (email) {
                                      if (isValidEmail(email)) {
                                        changeFocusInput(email, _passwordFocus);
                                      }
                                    },
                                    label: 'Email',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    icon: Icon(Icons.email_outlined),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!isValidEmail(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                            
                                  Text('Email Address'),
                                  AppFormField(
                                    textInputAction: TextInputAction.done,
                                    focusNode: _passwordFocus,
                                    onChange: (password) {
                                      if (password != null &&
                                          password.length >= 6) {
                                        changeFocusInput(password, _loginFocus);
                                      }
                                    },
                                    label: 'Password',
                                    controller: _passwordController,
                                    isPassword: true,
                                    icon: Icon(Icons.lock_outline),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  LoginButton(
                                    // handleLogin: _handleLogin,
                                    loginFocus: _loginFocus,
                                  ),
                                  LoginBottomSection(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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
