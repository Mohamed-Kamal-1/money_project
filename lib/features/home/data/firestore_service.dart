// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:money/features/home/domain/models/category_model.dart';
// import 'package:money/features/home/domain/models/monthly_report_model.dart';
// import 'package:money/features/home/domain/models/transaction_model.dart';
// import 'package:money/features/home/domain/models/user_settings_model.dart';
//
// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Collections
//   static const String usersCollection = 'users';
//   static const String transactionsCollection = 'transactions';
//   static const String categoriesCollection = 'categories';
//   static const String reportsCollection = 'reports';
//   static const String settingsCollection = 'settings';
//
//   // ==================== TRANSACTION OPERATIONS ====================
//
//   /// Create a new User
//
//   Future<void> ensureUserExists(String userId) async {
//     final userRef = _firestore.collection('users').doc(userId);
//
//     // بنحاول نجيب الداتا
//     final doc = await userRef.get();
//
//     if (!doc.exists) {
//       // لو المستخدم مش موجود، بنكاريته ببيانات مبدئية
//       await userRef.set({
//         'userId': userId,
//         'balance': 0.0,
//         'createdAt': FieldValue.serverTimestamp(),
//         'settings': {
//           'darkMode': true,
//           'notificationsEnabled': true,
//         },
//       });
//     }
//   }
//
//   /// Create a new transaction
//   Future<String> addTransaction(AppTransaction transaction) async {
//     try {
//       final docRef = await _firestore
//           .collection(transactionsCollection)
//           .add(transaction.toJson());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('Failed to add transaction: $e');
//     }
//   }
//
//   /// Update an existing transaction
//   Future<void> updateTransaction(AppTransaction transaction) async {
//     try {
//       if (transaction.id == null) throw Exception('Transaction ID is required');
//       await _firestore
//           .collection(transactionsCollection)
//           .doc(transaction.id)
//           .update(transaction.toJson());
//     } catch (e) {
//       throw Exception('Failed to update transaction: $e');
//     }
//   }
//
//   /// Delete a transaction
//   Future<void> deleteTransaction(String transactionId) async {
//     try {
//       await _firestore
//           .collection(transactionsCollection)
//           .doc(transactionId)
//           .delete();
//     } catch (e) {
//       throw Exception('Failed to delete transaction: $e');
//     }
//   }
//
//   /// Get a single transaction
//   Future<AppTransaction?> getTransaction(String transactionId) async {
//     try {
//       final doc = await _firestore
//           .collection(transactionsCollection)
//           .doc(transactionId)
//           .get();
//       if (doc.exists) {
//         return AppTransaction.fromFirestore(doc);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get transaction: $e');
//     }
//   }
//
//   /// Get all transactions for a user (Stream)
//   Stream<List<AppTransaction>> getUserTransactionsStream(String userId) {
//     return _firestore
//         .collection(transactionsCollection)
//         .where('userId', isEqualTo: userId)
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => AppTransaction.fromFirestore(doc))
//               .toList(),
//         );
//   }
//
//   /// Get transactions for a specific month
//   Stream<List<AppTransaction>> getMonthTransactionsStream(
//     String userId,
//     int month,
//     int year,
//   ) {
//     final startDate = DateTime(year, month, 1);
//     final endDate = DateTime(year, month + 1, 1);
//
//     return _firestore
//         .collection(transactionsCollection)
//         .where('userId', isEqualTo: userId)
//         .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//         .where('date', isLessThan: Timestamp.fromDate(endDate))
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => AppTransaction.fromFirestore(doc))
//               .toList(),
//         );
//   }
//
//   /// Get transactions for a specific category
//   Stream<List<AppTransaction>> getCategoryTransactionsStream(
//     String userId,
//     String categoryId,
//   ) {
//     return _firestore
//         .collection(transactionsCollection)
//         .where('userId', isEqualTo: userId)
//         .where('categoryId', isEqualTo: categoryId)
//         .orderBy('date', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => AppTransaction.fromFirestore(doc))
//               .toList(),
//         );
//   }
//
//   // ==================== CATEGORY OPERATIONS ====================
//
//   /// Create a new category
//   Future<String> addCategory(Category category) async {
//     try {
//       final docRef = await _firestore
//           .collection(categoriesCollection)
//           .add(category.toJson());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('Failed to add category: $e');
//     }
//   }
//
//   /// Update an existing category
//   Future<void> updateCategory(Category category) async {
//     try {
//       if (category.id == null) throw Exception('Category ID is required');
//       await _firestore
//           .collection(categoriesCollection)
//           .doc(category.id)
//           .update(category.toJson());
//     } catch (e) {
//       throw Exception('Failed to update category: $e');
//     }
//   }
//
//   /// Delete a category
//   Future<void> deleteCategory(String categoryId) async {
//     try {
//       await _firestore
//           .collection(categoriesCollection)
//           .doc(categoryId)
//           .delete();
//     } catch (e) {
//       throw Exception('Failed to delete category: $e');
//     }
//   }
//
//   /// Get all categories for a user (Stream)
//   Stream<List<Category>> getUserCategoriesStream(String userId) {
//     return _firestore
//         .collection(categoriesCollection)
//         .where('userId', isEqualTo: userId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) =>
//               snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList(),
//         );
//   }
//
//   /// Get a single category
//   Future<Category?> getCategory(String categoryId) async {
//     try {
//       final doc = await _firestore
//           .collection(categoriesCollection)
//           .doc(categoryId)
//           .get();
//       if (doc.exists) {
//         return Category.fromFirestore(doc);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get category: $e');
//     }
//   }
//
//   // ==================== USER SETTINGS OPERATIONS ====================
//
//   /// Save user settings
//   Future<void> saveUserSettings(UserSettings settings) async {
//     try {
//       await _firestore
//           .collection(settingsCollection)
//           .doc(settings.userId)
//           .set(settings.toJson());
//     } catch (e) {
//       throw Exception('Failed to save user settings: $e');
//     }
//   }
//
//   /// Get user settings (Stream)
//   Stream<UserSettings?> getUserSettingsStream(String userId) {
//     return _firestore
//         .collection(settingsCollection)
//         .doc(userId)
//         .snapshots()
//         .map((doc) {
//           if (doc.exists) {
//             return UserSettings.fromFirestore(doc, userId);
//           }
//           return UserSettings(userId: userId);
//         });
//   }
//
//   /// Get user settings once
//   Future<UserSettings?> getUserSettings(String userId) async {
//     try {
//       final doc = await _firestore
//           .collection(settingsCollection)
//           .doc(userId)
//           .get();
//       if (doc.exists) {
//         return UserSettings.fromFirestore(doc, userId);
//       }
//       return UserSettings(userId: userId);
//     } catch (e) {
//       throw Exception('Failed to get user settings: $e');
//     }
//   }
//
//   /// Update user balance
//   Future<void> updateUserBalance(String userId, double newBalance) async {
//     try {
//       await _firestore.collection(settingsCollection).doc(userId).set({
//         'balance': newBalance,
//         'updatedAt': Timestamp.fromDate(DateTime.now()),
//       }, SetOptions(merge: true));
//     } catch (e) {
//       throw Exception('Failed to update user balance: $e');
//     }
//   }
//
//   /// Get user balance stream
//   Stream<double> getUserBalanceStream(String userId) {
//     return _firestore
//         .collection(settingsCollection)
//         .doc(userId)
//         .snapshots()
//         .map((doc) {
//           if (doc.exists) {
//             return (doc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
//           }
//           return 0.0;
//         });
//   }
//
//   // ==================== MONTHLY REPORT OPERATIONS ====================
//
//   /// Create a monthly report
//   Future<String> addMonthlyReport(MonthlyReport report) async {
//     try {
//       final docRef = await _firestore
//           .collection(reportsCollection)
//           .add(report.toJson());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('Failed to add monthly report: $e');
//     }
//   }
//
//   /// Update a monthly report
//   Future<void> updateMonthlyReport(MonthlyReport report) async {
//     try {
//       if (report.id == null) throw Exception('Report ID is required');
//       await _firestore
//           .collection(reportsCollection)
//           .doc(report.id)
//           .update(report.toJson());
//     } catch (e) {
//       throw Exception('Failed to update monthly report: $e');
//     }
//   }
//
//   /// Get monthly report for a specific month
//   Future<MonthlyReport?> getMonthlyReport(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final query = await _firestore
//           .collection(reportsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('month', isEqualTo: month)
//           .where('year', isEqualTo: year)
//           .limit(1)
//           .get();
//
//       if (query.docs.isNotEmpty) {
//         return MonthlyReport.fromFirestore(query.docs.first);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Failed to get monthly report: $e');
//     }
//   }
//
//   /// Get all monthly reports for a user (Stream)
//   Stream<List<MonthlyReport>> getUserMonthlyReportsStream(String userId) {
//     return _firestore
//         .collection(reportsCollection)
//         .where('userId', isEqualTo: userId)
//         .orderBy('createdAt', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => MonthlyReport.fromFirestore(doc))
//               .toList(),
//         );
//   }
//
//   /// Get monthly reports for a year
//   Stream<List<MonthlyReport>> getYearMonthlyReportsStream(
//     String userId,
//     int year,
//   ) {
//     return _firestore
//         .collection(reportsCollection)
//         .where('userId', isEqualTo: userId)
//         .where('year', isEqualTo: year)
//         .orderBy('month', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => MonthlyReport.fromFirestore(doc))
//               .toList(),
//         );
//   }
//
//   // ==================== ANALYTICS OPERATIONS ====================
//
//   /// Calculate total expenses for a month (only expense type)
//   Future<double> calculateMonthTotal(String userId, int month, int year) async {
//     try {
//       final startDate = DateTime(year, month, 1);
//       final endDate = DateTime(year, month + 1, 1);
//
//       final snapshot = await _firestore
//           .collection(transactionsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//           .where('date', isLessThan: Timestamp.fromDate(endDate))
//           .get();
//
//       double total = 0;
//       for (var doc in snapshot.docs) {
//         final type = doc['type'] as String? ?? 'expense';
//         if (type == 'expense') {
//           total += (doc['amount'] as num?)?.toDouble() ?? 0.0;
//         }
//       }
//       return total;
//     } catch (e) {
//       throw Exception('Failed to calculate month total: $e');
//     }
//   }
//
//   /// Calculate total income for a month
//   Future<double> calculateMonthIncome(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final startDate = DateTime(year, month, 1);
//       final endDate = DateTime(year, month + 1, 1);
//
//       final snapshot = await _firestore
//           .collection(transactionsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//           .where('date', isLessThan: Timestamp.fromDate(endDate))
//           .get();
//
//       double total = 0;
//       for (var doc in snapshot.docs) {
//         final type = doc['type'] as String? ?? 'expense';
//         if (type == 'income') {
//           total += (doc['amount'] as num?)?.toDouble() ?? 0.0;
//         }
//       }
//       return total;
//     } catch (e) {
//       throw Exception('Failed to calculate month income: $e');
//     }
//   }
//
//   /// Get transaction count for a month
//   Future<int> getTransactionCount(String userId, int month, int year) async {
//     try {
//       final startDate = DateTime(year, month, 1);
//       final endDate = DateTime(year, month + 1, 1);
//
//       final snapshot = await _firestore
//           .collection(transactionsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//           .where('date', isLessThan: Timestamp.fromDate(endDate))
//           .get();
//
//       return snapshot.docs.length;
//     } catch (e) {
//       throw Exception('Failed to get transaction count: $e');
//     }
//   }
//
//   /// Get spending by category for a month
//   Future<Map<String, double>> getCategorySpending(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final startDate = DateTime(year, month, 1);
//       final endDate = DateTime(year, month + 1, 1);
//
//       final snapshot = await _firestore
//           .collection(transactionsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//           .where('date', isLessThan: Timestamp.fromDate(endDate))
//           .get();
//
//       final Map<String, double> categorySpending = {};
//       for (var doc in snapshot.docs) {
//         final categoryName = doc['categoryName'] as String? ?? 'Other';
//         final amount = (doc['amount'] as num?)?.toDouble() ?? 0.0;
//         categorySpending[categoryName] =
//             (categorySpending[categoryName] ?? 0) + amount;
//       }
//       return categorySpending;
//     } catch (e) {
//       throw Exception('Failed to get category spending: $e');
//     }
//   }
//
//   /// Get average spending per day for a month
//   Future<double> calculateDailyAverage(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final total = await calculateMonthTotal(userId, month, year);
//       final daysInMonth = DateTime(
//         year,
//         month + 1,
//       ).difference(DateTime(year, month)).inDays;
//       return total / daysInMonth;
//     } catch (e) {
//       throw Exception('Failed to calculate daily average: $e');
//     }
//   }
//
//   /// Get percentage change from previous month
//   Future<double> getPercentageChange(String userId, int month, int year) async {
//     try {
//       final currentTotal = await calculateMonthTotal(userId, month, year);
//
//       // Get previous month
//       int prevMonth = month - 1;
//       int prevYear = year;
//       if (prevMonth == 0) {
//         prevMonth = 12;
//         prevYear = year - 1;
//       }
//
//       final previousTotal = await calculateMonthTotal(
//         userId,
//         prevMonth,
//         prevYear,
//       );
//
//       if (previousTotal == 0) return 0;
//       return ((currentTotal - previousTotal) / previousTotal) * 100;
//     } catch (e) {
//       throw Exception('Failed to calculate percentage change: $e');
//     }
//   }
//
//   /// Analyze spending behavior (e.g., weekends vs weekdays)
//   Future<String> analyzSpendingBehavior(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final startDate = DateTime(year, month, 1);
//       final endDate = DateTime(year, month + 1, 1);
//
//       final snapshot = await _firestore
//           .collection(transactionsCollection)
//           .where('userId', isEqualTo: userId)
//           .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
//           .where('date', isLessThan: Timestamp.fromDate(endDate))
//           .get();
//
//       double weekendSpending = 0;
//       double weekdaySpending = 0;
//       int weekendCount = 0;
//       int weekdayCount = 0;
//
//       for (var doc in snapshot.docs) {
//         final date = (doc['date'] as Timestamp).toDate();
//         final amount = (doc['amount'] as num?)?.toDouble() ?? 0.0;
//         final dayOfWeek =
//             date.weekday; // 1-7, where 1 is Monday and 7 is Sunday
//
//         if (dayOfWeek >= 6) {
//           // Saturday or Sunday
//           weekendSpending += amount;
//           weekendCount++;
//         } else {
//           weekdaySpending += amount;
//           weekdayCount++;
//         }
//       }
//
//       if (weekendCount == 0 || weekdayCount == 0) {
//         return 'Balanced spending throughout the week';
//       }
//
//       final weekendAvg = weekendSpending / weekendCount;
//       final weekdayAvg = weekdaySpending / weekdayCount;
//
//       if (weekendAvg > weekdayAvg * 1.2) {
//         return 'Higher spending on weekends';
//       } else if (weekdayAvg > weekendAvg * 1.2) {
//         return 'Higher spending on weekdays';
//       } else {
//         return 'Balanced spending throughout the week';
//       }
//     } catch (e) {
//       throw Exception('Failed to analyze spending behavior: $e');
//     }
//   }
//
//   /// Get top spending category
//   Future<String> getTopSpendingCategory(
//     String userId,
//     int month,
//     int year,
//   ) async {
//     try {
//       final categorySpending = await getCategorySpending(userId, month, year);
//       if (categorySpending.isEmpty) return 'No data';
//
//       String topCategory = '';
//       double maxAmount = 0;
//       categorySpending.forEach((category, amount) {
//         if (amount > maxAmount) {
//           maxAmount = amount;
//           topCategory = category;
//         }
//       });
//       return topCategory;
//     } catch (e) {
//       throw Exception('Failed to get top spending category: $e');
//     }
//   }
// }
