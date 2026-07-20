import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';

class MonthlyReportHeader extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onSettingsTap; // ✅ إضافة هذا المعامل

  const MonthlyReportHeader({
    super.key,
    required this.selectedMonth,
    required this.onSettingsTap, // ✅ جعله مطلوباً
  });

  String get _monthLabel {
    return DateFormat('MMMM yyyy').format(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Report',
              style: context.fonts.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$_monthLabel Summary',
              style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
            ),
          ],
        ),
        GestureDetector(
          onTap: onSettingsTap, // ✅ استخدام المعامل
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.bottomNavBarBackGround,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.settings, color: AppColor.white, size: 22),
          ),
        ),
      ],
    );
  }
}
