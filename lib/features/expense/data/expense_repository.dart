import '../model/expense_model.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(ExpenseModel expense);
  Stream<List<ExpenseModel>> getExpensesStream();
}
