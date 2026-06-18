import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  );

  Stream<List<AppTransaction>> getUserTransactionsStream(String userId);

  Future<String> addTransaction(AppTransaction transaction);

  Future<String> addTransactionWithBalanceUpdate(AppTransaction transaction);

  Future<void> updateTransaction(AppTransaction transaction);

  Future<void> deleteTransaction(String transactionId);
}
