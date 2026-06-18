abstract interface class AnalyticsRepository {
  Future<double> calculateMonthTotal(String userId, int month, int year);

  Future<double> calculateMonthIncome(String userId, int month, int year);

  Future<double> calculateDailyAverage(String userId, int month, int year);

  Future<double> getPercentageChange(String userId, int month, int year);

  Future<String> analyzSpendingBehavior(String userId, int month, int year);

  Future<String> getTopSpendingCategory(String userId, int month, int year);

  Future<Map<String, double>> getCategorySpending(
    String userId,
    int month,
    int year,
  );

  Future<int> getTransactionCount(String userId, int month, int year);
}
