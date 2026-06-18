import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/analytics_repository.dart';

@Injectable(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final FirebaseFirestore _firestore;

  AnalyticsRepositoryImpl(this._firestore);

  @override
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

  @override
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

  @override
  Future<double> calculateDailyAverage(
    String userId,
    int month,
    int year,
  ) async {
    final total = await calculateMonthTotal(userId, month, year);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return daysInMonth == 0 ? 0 : total / daysInMonth;
  }

  @override
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

  @override
  Future<String> analyzSpendingBehavior(
    String userId,
    int month,
    int year,
  ) async {
    final total = await calculateMonthTotal(userId, month, year);
    if (total < 100) return 'Low spender';
    if (total < 500) return 'Moderate spender';
    if (total < 1000) return 'High spender';
    return 'Very high spender';
  }

  @override
  Future<String> getTopSpendingCategory(
    String userId,
    int month,
    int year,
  ) async {
    final spending = await getCategorySpending(userId, month, year);
    if (spending.isEmpty) return 'None';
    return spending.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  @override
  Future<Map<String, double>> getCategorySpending(
    String userId,
    int month,
    int year,
  ) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .get();
    final Map<String, double> result = {};
    for (final doc in snapshot.docs) {
      final category = doc['categoryName'] as String? ?? 'Other';
      final amount = (doc['amount'] as num).toDouble();
      result[category] = (result[category] ?? 0) + amount;
    }
    return result;
  }

  @override
  Future<int> getTransactionCount(String userId, int month, int year) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    final snapshot = await _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .count()
        .get();
    return snapshot.count ?? 0;
  }
}
