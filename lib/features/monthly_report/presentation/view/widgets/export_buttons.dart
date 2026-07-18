import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';

class ExportButtons extends StatelessWidget {
  final VoidCallback onExportPDF;

  const ExportButtons({super.key, required this.onExportPDF});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onExportPDF,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColor.navGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    color: AppColor.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Export PDF',
                    style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onExportPDF, // يمكن تغيير لاحقاً لمشاركة مباشرة
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColor.bottomNavBarBackGround,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderGray),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, color: AppColor.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Share',
                    style: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
