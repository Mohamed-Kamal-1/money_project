import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';

class PeriodSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _periods = ['Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _periods.map((period) {
        final isSelected = period == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColor.navGradient : null,
                color: isSelected ? null : AppColor.bottomNavBarBackGround,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: AppColor.borderGray, width: 1),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected ? AppColor.white : AppColor.gray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
