import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:money/core/extensions/theme_extension.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;

  const AmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: context.fonts.bodySmall),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: context.fonts.headlineSmall,
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: context.fonts.headlineSmall,
            hintText: '0.00',
            hintStyle: context.fonts.headlineSmall?.copyWith(
              color: AppColor.gray,
            ),
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
