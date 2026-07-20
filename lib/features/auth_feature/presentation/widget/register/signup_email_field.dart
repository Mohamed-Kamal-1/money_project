import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';

class SignupEmailField extends StatelessWidget {
  final TextEditingController controller;

  const SignupEmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: const TextStyle(color: AppColor.gray),
        hintText: 'you@example.com',
        hintStyle: const TextStyle(color: AppColor.darkGray),
        filled: true,
        fillColor: AppColor.bottomNavBarBackGround,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.blueStart),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.lightRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.lightRed),
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: AppColor.gray),
      ),
    );
  }
}
