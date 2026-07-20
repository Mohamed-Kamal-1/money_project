import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/dimensions/dimension_app.dart';

class HistoryFilterBar extends StatelessWidget {
  final String searchQuery;
  final String filterType;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onFilterChanged;
  final VoidCallback onClearSearch;

  const HistoryFilterBar({
    super.key,
    required this.searchQuery,
    required this.filterType,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: 8,
      ),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: TextField(
              style: const TextStyle(color: AppColor.white),
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: const TextStyle(color: AppColor.gray),
                filled: true,
                fillColor: AppColor.bottomNavBarBackGround,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColor.gray),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColor.gray),
                        onPressed: onClearSearch,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Filter Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColor.bottomNavBarBackGround,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: filterType,
                dropdownColor: AppColor.bottomNavBarBackGround,
                style: const TextStyle(color: AppColor.white),
                icon: const Icon(Icons.filter_list, color: AppColor.gray),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: onFilterChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
