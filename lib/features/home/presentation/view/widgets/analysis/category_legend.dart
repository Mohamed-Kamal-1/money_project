import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import 'donut_chart_painter.dart';

class CategoryLegend extends StatelessWidget {
  final List<DonutSegment> segments;

  const CategoryLegend({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: segments.map((segment) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: segment.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  segment.label,
                  style: context.fonts.bodyMedium?.copyWith(
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${segment.percentage.toStringAsFixed(1)}%',
                style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${segment.amount.toStringAsFixed(0)}',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
