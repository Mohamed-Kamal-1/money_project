import 'package:money/features/home/domain/models/category_model.dart';
import 'package:money/features/home/domain/models/transaction_model.dart';
import 'package:money/features/home/domain/models/user_settings_model.dart';
import 'package:money/features/home/domain/models/monthly_report_model.dart';

abstract interface class HomeRepository {
  // ==================== TRANSACTIONS ====================
  Future<String> addTransaction(AppTransaction transaction);
  Future<String> addTransactionWithBalanceUpdate(AppTransaction transaction);
  Future<void> updateTransaction(AppTransaction transaction);
  Future<void> deleteTransaction(String transactionId);
  Future<AppTransaction?> getTransaction(String transactionId);
  Stream<List<AppTransaction>> getUserTransactionsStream(String userId);
  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  );
  Stream<List<AppTransaction>> getCategoryTransactionsStream(
    String userId,
    String categoryId,
  );

  // ==================== CATEGORIES ====================
  Future<String> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<Category?> getCategory(String categoryId);
  Stream<List<Category>> getUserCategoriesStream(String userId);

  // ==================== USER SETTINGS ====================
  Future<void> saveUserSettings(UserSettings settings);
  Future<UserSettings?> getUserSettings(String userId);
  Stream<UserSettings?> getUserSettingsStream(String userId);

  // ==================== MONTHLY REPORTS ====================
  Future<String> addMonthlyReport(MonthlyReport report);
  Future<void> updateMonthlyReport(MonthlyReport report);
  Future<MonthlyReport?> getMonthlyReport(String userId, int month, int year);
  Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId);
  Stream<List<MonthlyReport>> getYearMonthlyReportsStream(
    String userId,
    int year,
  );

  // ==================== BALANCE ====================
  Future<void> updateUserBalance(String userId, double newBalance);
  Stream<double> getUserBalanceStream(String userId);

  // ==================== ANALYTICS ====================
  Future<double> calculateMonthTotal(String userId, int month, int year);
  Future<double> calculateMonthIncome(String userId, int month, int year);
  Future<int> getTransactionCount(String userId, int month, int year);
  Future<Map<String, double>> getCategorySpending(
    String userId,
    int month,
    int year,
  );
  Future<double> calculateDailyAverage(String userId, int month, int year);
  Future<double> getPercentageChange(String userId, int month, int year);
  Future<String> analyzSpendingBehavior(String userId, int month, int year);
  Future<String> getTopSpendingCategory(String userId, int month, int year);
}
