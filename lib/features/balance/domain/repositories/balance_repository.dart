abstract interface class BalanceRepository {
  Stream<double> getUserBalanceStream(String userId);
  Future<void> updateUserBalance(String userId, double newBalance);
}
