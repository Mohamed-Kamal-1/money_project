import 'package:flutter/material.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/Dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/widgets_for_all_app/financial_card.dart';

// 1. The "This Month" Expense Card
class MonthlyExpenseCard extends StatelessWidget {
  const MonthlyExpenseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      height: Dimension.heightCard145, // Approximate height based on design
      width: double.infinity,
      color: AppColor.darkOxfordBlue, // Assuming same bg as Health card
      // alignment: MainAxisAlignment.spaceEvenly,
      // spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('This Month', style: context.fonts.bodyMedium),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.darkGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '8.9%',
                style: context.fonts.labelSmall?.copyWith(
                  color: AppColor.lightGreen,
                ),
              ),
            ),
          ],
        ),
        Text('\$2,847.50', style: context.fonts.displayMedium),
        Text(
          'vs \$3,124.80 last month',
          style: context.fonts.bodySmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}

// 2. The Split Row (Top Category & Transactions)
class FinancialStatsGrid extends StatelessWidget {
  const FinancialStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // spacing: Dimension.spacing12, // Using spacing property (Flutter 3.24+)
      children: [
        // Left Card: Top Category
        Expanded(
          child: FinancialCard(

            // width: double.infinity,
            height: Dimension.heightCard145,
            color: AppColor.deepCharcoal, // Dark variant
            // alignment: MainAxisAlignment.start,
            children: [
              Text('\$842', style: context.fonts.headlineSmall),
              Text(
                'TOP CATEGORY',
                style: context.fonts.labelSmall?.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'Food & Dining',
                style: context.fonts.bodyMedium?.copyWith(
                  color: const Color(0xFF7B61FF),
                ),
              ),
            ],
          ),
        ),
        // Right Card: Transactions
        Expanded(
          child: FinancialCard(
            // width: double.infinity,
            height: Dimension.heightCard145,
            color: const Color(0xFF1E1E2C),
            // Dark variant
            alignment: MainAxisAlignment.start,
            children: [
              Text('47', style: context.fonts.headlineSmall),
              Text(
                'TRANSACTIONS',
                style: context.fonts.labelSmall?.copyWith(
                  fontSize: 10,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'This Month',
                style: context.fonts.bodyMedium?.copyWith(
                  color: AppColor.lightGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 3. Quick Actions Section
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: context.fonts.labelSmall?.copyWith(letterSpacing: 1.2),
        ),
        const SizedBox(height: Dimension.spacing12),
        Row(
          spacing: Dimension.spacing12,
          children: [
            _buildActionBtn(
              context,
              icon: Icons.add,
              label: 'Add',
              color: const Color(0xFF1A1A2E),
            ),
            _buildActionBtn(
              context,
              icon: Icons.receipt_long,
              label: 'History',
              color: const Color(0xFF0F3D36),
            ),
            _buildActionBtn(
              context,
              icon: Icons.account_balance,
              label: 'Budget',
              color: const Color(0xFF3D2C1F),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBtn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(label, style: context.fonts.labelSmall),
          ],
        ),
      ),
    );
  }
}
