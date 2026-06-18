import '../entities/monthly_report.dart';

abstract interface class MonthlyReportRepository {
  Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId);

  Future<MonthlyReport?> getMonthlyReport(String userId, int month, int year);

  Future<String> addMonthlyReport(MonthlyReport report);
}
