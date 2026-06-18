import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/analytics_repository.dart';

@Injectable(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepositoryImpl(this._firestore);

  @override
  Stream<AnalyticsData> watchAnalytics(String userId, int month, int year) {
    // نستمع إلى التغييرات في معاملات المستخدم للشهر المحدد
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map((snapshot) {
          final transactions = snapshot.docs;

          // حساب كل القيم من المعاملات
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

          // حساب نسبة التغير (يحتاج شهر سابق)
          final percentageChange =
              0.0; // يمكن حسابه باستدعاء getPercentageChange

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

  String _getSpendingBehavior(double total) {
    if (total < 100) return 'Low spender';
    if (total < 500) return 'Moderate spender';
    if (total < 1000) return 'High spender';
    return 'Very high spender';
  }

  // باقي الدوال كما هي...
}
