import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_state.dart';
import '../../../../../core/colors/app_color.dart';
import '../../../../../core/dimensions/dimension_app.dart';
import '../../../../../core/extensions/theme_extension.dart';
import '../../../domain/entities/transaction.dart';
import '../widgets/history_filter_bar.dart';
import '../widgets/history_summary_bar.dart';
import '../widgets/transaction_history_empty.dart';
import '../widgets/transaction_history_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String userId;

  const TransactionHistoryScreen({super.key, required this.userId});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _filterType = 'all'; // 'all', 'income', 'expense'
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().listenToTransactions(widget.userId);
  }

  // ==================== منطق الفلترة والبحث ====================
  List<AppTransaction> _getFilteredTransactions(
    List<AppTransaction> transactions,
  ) {
    var filtered = transactions;

    if (_filterType != 'all') {
      filtered = filtered.where((t) => t.type == _filterType).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) {
        return t.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            t.categoryName.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    filtered.sort((a, b) => b.date.compareTo(a.date));
    return filtered;
  }

  // ==================== حساب الإجماليات ====================
  Map<String, double> _calculateTotals(List<AppTransaction> transactions) {
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpenses = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount );
    return {
      'income': totalIncome,
      'expenses': totalExpenses,
      'total': totalIncome - totalExpenses,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transaction History',
          style: context.fonts.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: HistoryFilterBar(
            searchQuery: _searchQuery,
            filterType: _filterType,
            onSearchChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onFilterChanged: (value) {
              if (value != null) {
                setState(() {
                  _filterType = value;
                });
              }
            },
            onClearSearch: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
        ),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.blueStart),
            );
          }

          if (state is TransactionError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: AppColor.lightRed),
              ),
            );
          }

          if (state is TransactionLoaded) {
            final transactions = _getFilteredTransactions(state.transactions);
            final totals = _calculateTotals(transactions);

            if (transactions.isEmpty) {
              return TransactionHistoryEmpty(
                hasSearchQuery: _searchQuery.isNotEmpty,
                onClearSearch: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              );
            }

            return Column(
              children: [
                // Summary Bar
                HistorySummaryBar(
                  totalIncome: totals['income'] ?? 0,
                  totalExpenses: totals['expenses'] ?? 0,
                  total: totals['total'] ?? 0,
                ),
                // Transactions List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimension.padding16,
                    ),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionHistoryItem(transaction: transaction);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
