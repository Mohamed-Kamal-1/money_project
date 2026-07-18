import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/analytics_repository.dart';

@Injectable(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepositoryImpl(this._firestore);

  // ==================== حساب النسبة المئوية للتغير ====================
  Future<double> getPercentageChange(String userId, int month, int year) async {
    final current = await calculateMonthTotal(userId, month, year);
    int prevMonth = month - 1;
    int prevYear = year;
    if (prevMonth == 0) {
      prevMonth = 12;
      prevYear--;
    }
    final previous = await calculateMonthTotal(userId, prevMonth, prevYear);
    if (previous == 0) return 0;
    return ((current - previous) / previous) * 100;
  }

  // ==================== دوال الحساب الأساسية ====================
  Future<double> calculateMonthTotal(String userId, int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();
    return snapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );
  }

  Future<double> calculateMonthIncome(
    String userId,
    int month,
    int year,
  ) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'income')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();
    return snapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['amount'] as num).toDouble(),
    );
  }

  Future<double> calculateDailyAverage(
    String userId,
    int month,
    int year,
  ) async {
    final total = await calculateMonthTotal(userId, month, year);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return daysInMonth == 0 ? 0 : total / daysInMonth;
  }

  String _getSpendingBehavior(double total) {
    if (total < 100) return 'Low spender';
    if (total < 500) return 'Moderate spender';
    if (total < 1000) return 'High spender';
    return 'Very high spender';
  }

  // ==================== watchAnalytics – بث مباشر مع حساب النسبة ====================
  @override
  Stream<AnalyticsData> watchAnalytics(String userId, int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .asyncMap((snapshot) async {
          // ✅ asyncMap لحساب النسبة
          final transactions = snapshot.docs;

          double totalExpenses = 0;
          double totalIncome = 0;
          Map<String, double> categorySpending = {};
          int transactionCount = transactions.length;

          for (var doc in transactions) {
            final data = doc.data();
            final amount = (data['amount'] as num).toDouble();
            final type = data['type'] as String;
            final category = data['categoryName'] as String? ?? 'Other';

            if (type == 'expense') {
              totalExpenses += amount;
              categorySpending[category] =
                  (categorySpending[category] ?? 0) + amount;
            } else {
              totalIncome += amount;
            }
          }

          // حساب القيم الإضافية
          final daysInMonth = DateTime(year, month + 1, 0).day;
          final dailyAverage = daysInMonth == 0
              ? 0
              : totalExpenses / daysInMonth;
          final topCategory = categorySpending.entries.isEmpty
              ? 'None'
              : categorySpending.entries
                    .reduce((a, b) => a.value > b.value ? a : b)
                    .key;

          // ✅ حساب نسبة التغير عن الشهر السابق
          final percentageChange = await getPercentageChange(
            userId,
            month,
            year,
          );

          return AnalyticsData(
            monthTotal: totalExpenses,
            monthIncome: totalIncome,
            dailyAverage: dailyAverage.toDouble(),
            percentageChange: percentageChange,
            spendingBehavior: _getSpendingBehavior(totalExpenses),
            topCategory: topCategory,
            categorySpending: categorySpending,
            transactionCount: transactionCount,
          );
        });
  }
}
