import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: context.fonts.bodySmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: context.fonts.bodyMedium?.copyWith(color: AppColor.white),
          decoration: InputDecoration(
            hintText: 'Enter description',
            hintStyle: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
            filled: true,
            fillColor: AppColor.primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimension.circular12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimension.circular12),
              borderSide: const BorderSide(color: AppColor.borderGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimension.circular12),
              borderSide: const BorderSide(color: AppColor.blueStart),
            ),
          ),
        ),
      ],
    );
  }
}
