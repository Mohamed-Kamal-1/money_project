import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/core/colors/app_color.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  String get _monthLabel {
    return DateFormat('MMMM yyyy').format(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.bottomNavBarBackGround,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onPrevious,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.chevron_left, color: AppColor.gray, size: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppColor.navGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: AppColor.white,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _monthLabel,
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onNext,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.chevron_right,
                  color: AppColor.gray,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
