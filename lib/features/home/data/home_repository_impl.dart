import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../domain/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. جلب رصيد المستخدم الحالي
  @override
  Future<double> getUserBalance(String userId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final doc = await userDoc.get();

    if (!doc.exists) {
      // لو اليوزر مش موجود (زي الحالة بتاعتك دلوقتي)، بنكريته ببيانات صفرية
      await userDoc.set({
        'balance': 0.0,
        'lastUpdate': FieldValue.serverTimestamp(),
      });
      return 0.0;
    }

    return (doc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
  }

  // 2. إضافة معاملة وتحديث الرصيد (Atomic Operation using Batch)


  // 3. حساب إجمالي المصاريف لشهر معين (Query Optimization)
  @override
  Future<double> calculateMonthTotal(String userId, int month, int year) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('type', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    double total = 0;
    for (var doc in snapshot.docs) {
      total += (doc.data()['amount'] as num).toDouble();
    }
    return total;
  }

  // 4. جلب توزيع المصاريف حسب الفئات (للـ Donut Chart)
  @override
  Future<Map<String, double>> getCategorySpending(String userId, int month,
      int year) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('type', isEqualTo: 'expense')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    Map<String, double> categoryMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      String category = data['categoryName'] ?? 'General';
      double amount = (data['amount'] as num).toDouble();

      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
    }
    return categoryMap;
  }

  // 5. جلب الفئة الأكثر استهلاكاً (Top Category)
  @override
  Future<String> getTopSpendingCategory(String userId, int month,
      int year) async {
    final spending = await getCategorySpending(userId, month, year);
    if (spending.isEmpty) return "No Data";

    // بنجيب أكبر قيمة في الـ Map
    return spending.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  // 6. حساب المتوسط اليومي (Daily Average)
  @override
  Future<double> calculateDailyAverage(String userId, int month,
      int year) async {
    final total = await calculateMonthTotal(userId, month, year);
    final now = DateTime.now();

    // لو الشهر هو الحالي، بنقسم على عدد الأيام اللي مرت، لو شهر فات بنقسم على 30
    int days = (now.month == month && now.year == year) ? now.day : 30;
    return total / (days == 0 ? 1 : days);
  }

  // باقي الـ Methods (calculateMonthIncome, getTransactionCount) بنفس المنطق...
  @override
  Future<double> calculateMonthIncome(String userId, int month,
      int year) async {
    return 0.0;
  }
  @override
  Future<int> getTransactionCount(String userId, int month, int year) async {
    return 0;
  }
  @override
  Future<void> updateBalance(String userId, double amount) async {
    return;
  }

  @override
  Future<void> addTransactionAndAdjustBalance(String userId,
      transaction) async {
    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(userId);
    final transRef = userRef.collection('transactions').doc();

    // إضافة المعاملة
    batch.set(transRef, transaction.toJson());

    // تحديث الرصيد (الزيادة أو النقصان تلقائياً)
    double adjustment = transaction.type == 'income'
        ? transaction.amount
        : -transaction.amount;
    batch.set(userRef, {
      'balance': FieldValue.increment(adjustment),
      'lastUpdate': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}