import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extensions/theme_extension.dart';

class TransactionHistoryEmpty extends StatelessWidget {
  final bool hasSearchQuery;
  final VoidCallback onClearSearch;

  const TransactionHistoryEmpty({
    super.key,
    required this.hasSearchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColor.gray.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            hasSearchQuery
                ? 'No transactions match your search'
                : 'No transactions yet',
            style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
          ),
          if (hasSearchQuery) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onClearSearch,
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}
