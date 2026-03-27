import '../models/transaction_model.dart';

abstract interface class HomeRepository {
  // --- Balance & Transactions ---
  Future<double> getUserBalance(String userId);
  Future<void> updateBalance(String userId, double amount);
  Future<void> addTransactionAndAdjustBalance(String userId, dynamic transaction);

  // --- Analytics Methods (اللي كانت ناقصة للـ Cubit) ---

  // 1. حساب إجمالي المصاريف لشهر معين
  Future<double> calculateMonthTotal(String userId, int month, int year);

  // 2. حساب إجمالي الدخل لشهر معين
  Future<double> calculateMonthIncome(String userId, int month, int year);

  // 3. حساب المتوسط اليومي للمصاريف
  Future<double> calculateDailyAverage(String userId, int month, int year);

  // 4. جلب توزيع المصاريف حسب الفئات (Map<CategoryName, Amount>)
  Future<Map<String, double>> getCategorySpending(String userId, int month, int year);

  // 5. جلب عدد المعاملات في الشهر
  Future<int> getTransactionCount(String userId, int month, int year);

  // 6. جلب الفئة الأكثر استهلاكاً (Top Category)
  Future<String> getTopSpendingCategory(String userId, int month, int year);

  
}