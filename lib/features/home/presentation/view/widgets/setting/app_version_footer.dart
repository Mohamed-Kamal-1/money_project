import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';

class AppVersionFooter extends StatelessWidget {
  const AppVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Expense Tracker v1.0.0',
        style: context.fonts.bodySmall?.copyWith(
          color: AppColor.gray,
          fontSize: 11,
        ),
      ),
    );
  }
}
