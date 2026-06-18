abstract interface class AnalyticsRepository {
  // ... الدوال الموجودة ...

  // ✅ دالة جديدة ترجع Stream من التحليلات
  Stream<AnalyticsData> watchAnalytics(String userId, int month, int year);
}

// ✅ كائن يحمل كل بيانات التحليلات
class AnalyticsData {
  final double monthTotal;
  final double monthIncome;
  final double dailyAverage;
  final double percentageChange;
  final String spendingBehavior;
  final String topCategory;
  final Map<String, double> categorySpending;
  final int transactionCount;

  AnalyticsData({
    required this.monthTotal,
    required this.monthIncome,
    required this.dailyAverage,
    required this.percentageChange,
    required this.spendingBehavior,
    required this.topCategory,
    required this.categorySpending,
    required this.transactionCount,
  });
}
