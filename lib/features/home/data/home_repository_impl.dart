import 'package:money/features/home/data/firestore_service.dart';
import 'package:money/features/home/data/home_repository.dart';
import 'package:money/features/home/domain/models/category_model.dart';
import 'package:money/features/home/domain/models/monthly_report_model.dart';
import 'package:money/features/home/domain/models/transaction_model.dart';
import 'package:money/features/home/domain/models/user_settings_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirestoreService _firestoreService;

  HomeRepositoryImpl(this._firestoreService);

  // ==================== TRANSACTIONS ====================

  @override
  Future<String> addTransaction(AppTransaction transaction) {
    return _firestoreService.addTransaction(transaction);
  }

  @override
  Future<String> addTransactionWithBalanceUpdate(AppTransaction transaction) {
    return _firestoreService.addTransactionWithBalanceUpdate(transaction);
  }

  @override
  Future<void> updateTransaction(AppTransaction transaction) {
    return _firestoreService.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String transactionId) {
    return _firestoreService.deleteTransaction(transactionId);
  }

  @override
  Future<AppTransaction?> getTransaction(String transactionId) {
    return _firestoreService.getTransaction(transactionId);
  }

  @override
  Stream<List<AppTransaction>> getUserTransactionsStream(String userId) {
    return _firestoreService.getUserTransactionsStream(userId);
  }

  @override
  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  ) {
    return _firestoreService.getMonthTransactionsStream(userId, month, year);
  }

  @override
  Stream<List<AppTransaction>> getCategoryTransactionsStream(
    String userId,
    String categoryId,
  ) {
    return _firestoreService.getCategoryTransactionsStream(userId, categoryId);
  }

  // ==================== CATEGORIES ====================

  @override
  Future<String> addCategory(Category category) {
    return _firestoreService.addCategory(category);
  }

  @override
  Future<void> updateCategory(Category category) {
    return _firestoreService.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    return _firestoreService.deleteCategory(categoryId);
  }

  @override
  Future<Category?> getCategory(String categoryId) {
    return _firestoreService.getCategory(categoryId);
  }

  @override
  Stream<List<Category>> getUserCategoriesStream(String userId) {
    return _firestoreService.getUserCategoriesStream(userId);
  }

  // ==================== USER SETTINGS ====================

  @override
  Future<void> saveUserSettings(UserSettings settings) {
    return _firestoreService.saveUserSettings(settings);
  }

  @override
  Stream<UserSettings?> getUserSettingsStream(String userId) {
    return _firestoreService.getUserSettingsStream(userId);
  }

  @override
  Future<UserSettings?> getUserSettings(String userId) {
    return _firestoreService.getUserSettings(userId);
  }

  // ==================== MONTHLY REPORTS ====================

  @override
  Future<String> addMonthlyReport(MonthlyReport report) {
    return _firestoreService.addMonthlyReport(report);
  }

  @override
  Future<void> updateMonthlyReport(MonthlyReport report) {
    return _firestoreService.updateMonthlyReport(report);
  }

  @override
  Future<MonthlyReport?> getMonthlyReport(String userId, int month, int year) {
    return _firestoreService.getMonthlyReport(userId, month, year);
  }

  @override
  Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId) {
    return _firestoreService.getUserMonthlyReportsStream(userId);
  }

  @override
  Stream<List<MonthlyReport>> getYearMonthlyReportsStream(
    String userId,
    int year,
  ) {
    return _firestoreService.getYearMonthlyReportsStream(userId, year);
  }

  // ==================== BALANCE ====================

  @override
  Future<void> updateUserBalance(String userId, double newBalance) {
    return _firestoreService.updateUserBalance(userId, newBalance);
  }

  @override
  Stream<double> getUserBalanceStream(String userId) {
    return _firestoreService.getUserBalanceStream(userId);
  }

  // ==================== ANALYTICS ====================

  @override
  Future<double> calculateMonthTotal(String userId, int month, int year) {
    return _firestoreService.calculateMonthTotal(userId, month, year);
  }

  @override
  Future<double> calculateMonthIncome(String userId, int month, int year) {
    return _firestoreService.calculateMonthIncome(userId, month, year);
  }

  @override
  Future<int> getTransactionCount(String userId, int month, int year) {
    return _firestoreService.getTransactionCount(userId, month, year);
  }

  @override
  Future<Map<String, double>> getCategorySpending(
    String userId,
    int month,
    int year,
  ) {
    return _firestoreService.getCategorySpending(userId, month, year);
  }

  @override
  Future<double> calculateDailyAverage(String userId, int month, int year) {
    return _firestoreService.calculateDailyAverage(userId, month, year);
  }

  @override
  Future<double> getPercentageChange(String userId, int month, int year) {
    return _firestoreService.getPercentageChange(userId, month, year);
  }

  @override
  Future<String> analyzSpendingBehavior(String userId, int month, int year) {
    return _firestoreService.analyzSpendingBehavior(userId, month, year);
  }

  @override
  Future<String> getTopSpendingCategory(String userId, int month, int year) {
    return _firestoreService.getTopSpendingCategory(userId, month, year);
  }
}
