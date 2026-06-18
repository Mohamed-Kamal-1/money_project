import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:money/features/transaction/domain/repositories/transaction_repository.dart';

import '../../domain/entities/transaction.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepositoryImpl(this._firestore);

  @override
  Stream<List<AppTransaction>> getUserTransactionsStream(String userId) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppTransaction.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<List<AppTransaction>> getMonthTransactionsStream(
    String userId,
    int month,
    int year,
  ) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AppTransaction.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<String> addTransaction(AppTransaction transaction) async {
    final docRef = _firestore.collection('transactions').doc();
    await docRef.set(transaction.toJson());
    return docRef.id;
  }

  @override
  Future<String> addTransactionWithBalanceUpdate(
    AppTransaction transaction,
  ) async {
    final batch = _firestore.batch();
    final transactionRef = _firestore.collection('transactions').doc();
    batch.set(transactionRef, transaction.toJson());

    final userRef = _firestore.collection('users').doc(transaction.userId);
    final userDoc = await userRef.get();
    final currentBalance =
        (userDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
    final newBalance = transaction.type == 'income'
        ? currentBalance + transaction.amount
        : currentBalance - transaction.amount;
    batch.update(userRef, {
      'balance': newBalance,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
    return transactionRef.id;
  }

  @override
  Future<void> updateTransaction(AppTransaction transaction) async {
    await _firestore
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toJson());
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final doc = await _firestore
        .collection('transactions')
        .doc(transactionId)
        .get();
    if (!doc.exists) return;
    final data = doc.data()!;
    final userId = data['userId'] as String;
    final amount = (data['amount'] as num).toDouble();
    final type = data['type'] as String;

    final batch = _firestore.batch();
    batch.delete(_firestore.collection('transactions').doc(transactionId));

    final userRef = _firestore.collection('users').doc(userId);
    final userDoc = await userRef.get();
    final currentBalance =
        (userDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;
    final newBalance = type == 'income'
        ? currentBalance - amount
        : currentBalance + amount;
    batch.update(userRef, {
      'balance': newBalance,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }
}
