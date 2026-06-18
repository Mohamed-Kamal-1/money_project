import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/balance_repository.dart';

@Injectable(as: BalanceRepository)
class BalanceRepositoryImpl implements BalanceRepository {
  final FirebaseFirestore _firestore;
  BalanceRepositoryImpl(this._firestore);

  @override
  Stream<double> getUserBalanceStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => (doc.data()?['balance'] as num?)?.toDouble() ?? 0.0);
  }

  @override
  Future<void> updateUserBalance(String userId, double newBalance) async {
    await _firestore.collection('users').doc(userId).update({
      'balance': newBalance,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
}
