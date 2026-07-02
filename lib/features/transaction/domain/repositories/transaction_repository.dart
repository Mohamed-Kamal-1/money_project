import 'dart:async';

import '../entities/transaction.dart';

class TransactionResult {
  final String transactionId;
  final double actualAmount;
  final bool wasAdjusted;

  TransactionResult({
    required this.transactionId,
    required this.actualAmount,
    this.wasAdjusted = false,
  });
}

abstract class TransactionRepository {
  Future<String> addTransaction(AppTransaction transaction);
  Future<TransactionResult> addTransactionWithBalanceUpdate(
    AppTransaction transaction,
  );
  Future<void> updateTransaction(AppTransaction transaction);
  Future<void> deleteTransaction(String transactionId);
  Stream<List<AppTransaction>> getUserTransactionsStream(String userId);
  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  );
}
