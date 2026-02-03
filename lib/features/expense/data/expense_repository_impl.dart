import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/expense_model.dart';
import 'expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _expensesCollection;

  ExpenseRepositoryImpl() {
    _expensesCollection = _firestore.collection('expenses');
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      await _expensesCollection.add(expense.toMap());
    } catch (e) {
      // In a real-world app, we would use a proper logger and custom exceptions
      throw Exception('Failed to add expense: $e');
    }
  }

  @override
  Stream<List<ExpenseModel>> getExpensesStream() {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ExpenseModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
}
