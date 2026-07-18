import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PdfExportOptions {
  static Future<void> show(
    BuildContext context, {
    required pw.Document pdf,
    required File file,
    required String monthLabel,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.bottomNavBarBackGround,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.gray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Export Options',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            _exportOption(
              context,
              icon: Icons.picture_as_pdf,
              title: 'Preview & Print PDF',
              subtitle: 'Open PDF preview to print',
              onTap: () async {
                Navigator.pop(context);
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => pdf.save(),
                );
              },
            ),
            _exportOption(
              context,
              icon: Icons.share,
              title: 'Share PDF',
              subtitle: 'Share report via email, WhatsApp, etc.',
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles([
                  XFile(file.path),
                ], text: 'Monthly Report - $monthLabel');
              },
            ),
            _exportOption(
              context,
              icon: Icons.save_alt,
              title: 'Save PDF',
              subtitle: 'Save to device storage',
              onTap: () {
                Navigator.pop(context);
                Share.shareXFiles([
                  XFile(file.path),
                ], text: 'Monthly Report - $monthLabel');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Widget _exportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(Dimension.circular12),
          border: Border.all(color: AppColor.borderGray),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColor.blueStart.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColor.blueStart, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColor.gray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColor.gray),
          ],
        ),
      ),
    );
  }
}
