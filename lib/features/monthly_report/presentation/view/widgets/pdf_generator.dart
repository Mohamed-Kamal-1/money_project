import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_export_options.dart';

class PdfGenerator {
  static Future<void> generateAndShowPDF(
    BuildContext context,
    AnalyticsLoaded analytics,
    DateTime selectedMonth,
  ) async {
    try {
      final pdf = await _buildPDF(analytics, selectedMonth);
      await _showPDFOptions(context, pdf, selectedMonth);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<pw.Document> _buildPDF(
    AnalyticsLoaded analytics,
    DateTime selectedMonth,
  ) async {
    final pdf = pw.Document();
    final monthLabel = DateFormat('MMMM yyyy').format(selectedMonth);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final sortedEntries = analytics.categorySpending.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          final topEntries = sortedEntries.take(5);

          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Text(
                  'Monthly Report',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  monthLabel,
                  style: pw.TextStyle(fontSize: 18, color: PdfColors.grey700),
                ),
                pw.Divider(thickness: 2, color: PdfColors.blue300),
                pw.SizedBox(height: 20),

                // Summary
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Total Expenses',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '\$${NumberFormat('#,##0.00').format(analytics.monthTotal)}',
                          style: pw.TextStyle(
                            fontSize: 32,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.red700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Total Income',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '\$${NumberFormat('#,##0.00').format(analytics.monthIncome)}',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Comparison & Daily Average
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildComparisonCard(analytics),
                    _buildDailyAverageCard(analytics, selectedMonth),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Top Categories
                pw.Text(
                  'Top Spending Categories',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 12),
                ...topEntries.map((entry) {
                  final percentage = analytics.monthTotal == 0
                      ? 0.0
                      : (entry.value / analytics.monthTotal) * 100;
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(entry.key, style: pw.TextStyle(fontSize: 14)),
                          pw.Text(
                            '\$${entry.value.toStringAsFixed(2)}',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        height: 8,
                        decoration: pw.BoxDecoration(
                          color: PdfColors.grey200,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Container(
                          width: (percentage / 100) * 100,
                          height: 8,
                          decoration: pw.BoxDecoration(
                            color: PdfColors.blue700,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey500,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                    ],
                  );
                }).toList(),
                pw.SizedBox(height: 20),

                // Spending Behavior
                pw.Text(
                  'Spending Behavior',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    analytics.spendingBehavior.isEmpty
                        ? 'Add transactions to see insights'
                        : analytics.spendingBehavior,
                    style: pw.TextStyle(fontSize: 14),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Transactions Summary
                pw.Text(
                  'Transactions Summary',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Total Transactions',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '${analytics.transactionCount}',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Days in Month',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.grey600,
                          ),
                        ),
                        pw.Text(
                          '${DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day}',
                          style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),

                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Generated on ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey500),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  static pw.Widget _buildComparisonCard(AnalyticsLoaded analytics) {
    final isIncrease = analytics.percentageChange > 0;
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'VS LAST MONTH',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey500,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${analytics.percentageChange > 0 ? '+' : ''}${analytics.percentageChange.toStringAsFixed(1)}%',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: isIncrease ? PdfColors.red700 : PdfColors.green700,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            isIncrease
                ? 'Increased by \$${((analytics.percentageChange / 100) * analytics.monthTotal).toStringAsFixed(2)}'
                : 'Saved \$${((-analytics.percentageChange / 100) * analytics.monthTotal).toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDailyAverageCard(
    AnalyticsLoaded analytics,
    DateTime selectedMonth,
  ) {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'DAILY AVERAGE',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey500,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '\$${analytics.dailyAverage.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            '${DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day} days tracked',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  static Future<void> _showPDFOptions(
    BuildContext context,
    pw.Document pdf,
    DateTime selectedMonth,
  ) async {
    final bytes = await pdf.save();
    final tempDir = await getTemporaryDirectory();
    final monthLabel = DateFormat('MMMM yyyy').format(selectedMonth);
    final file = File(
      '${tempDir.path}/Monthly_Report_${monthLabel.replaceAll(' ', '_')}.pdf',
    );
    await file.writeAsBytes(bytes);

    await PdfExportOptions.show(
      context,
      pdf: pdf,
      file: file,
      monthLabel: monthLabel,
    );
  }
}
