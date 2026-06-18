import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/monthly_report.dart';
import '../../domain/repositories/monthly_report_repository.dart';

@Injectable(as: MonthlyReportRepository)
class MonthlyReportRepositoryImpl implements MonthlyReportRepository {
  final FirebaseFirestore _firestore;

  MonthlyReportRepositoryImpl(this._firestore);

  @override
  Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId) {
    return _firestore
        .collection('monthly_reports')
        .where('userId', isEqualTo: userId)
        .orderBy('year', descending: true)
        .orderBy('month', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return MonthlyReport(
              id: doc.id,
              userId: data['userId'] as String? ?? '',
              month: data['month'] as int? ?? 1,
              year: data['year'] as int? ?? 2024,
              totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
              totalExpenses: (data['totalExpenses'] as num?)?.toDouble() ?? 0.0,
              categoriesSpending: Map<String, double>.from(
                data['categoriesSpending'] ?? {},
              ),
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          }).toList(),
        );
  }

  @override
  Future<MonthlyReport?> getMonthlyReport(
    String userId,
    int month,
    int year,
  ) async {
    final query = await _firestore
        .collection('monthly_reports')
        .where('userId', isEqualTo: userId)
        .where('month', isEqualTo: month)
        .where('year', isEqualTo: year)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    final doc = query.docs.first;
    final data = doc.data();
    return MonthlyReport(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      month: data['month'] as int? ?? month,
      year: data['year'] as int? ?? year,
      totalIncome: (data['totalIncome'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (data['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      categoriesSpending: Map<String, double>.from(
        data['categoriesSpending'] ?? {},
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  @override
  Future<String> addMonthlyReport(MonthlyReport report) async {
    final docRef = _firestore.collection('monthly_reports').doc();
    await docRef.set({
      'userId': report.userId,
      'month': report.month,
      'year': report.year,
      'totalIncome': report.totalIncome,
      'totalExpenses': report.totalExpenses,

      'categoriesSpending': report.categoriesSpending,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }
}
