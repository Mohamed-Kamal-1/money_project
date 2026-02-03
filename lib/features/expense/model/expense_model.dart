import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final double amount;
  final String merchant;
  final String category;
  final bool isRecurring;
  final DateTime date;

  ExpenseModel({
    required this.id,
    required this.amount,
    required this.merchant,
    required this.category,
    required this.isRecurring,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'merchant': merchant,
      'category': category,
      'isRecurring': isRecurring,
      'date': Timestamp.fromDate(date),
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      merchant: map['merchant'] as String,
      category: map['category'] as String,
      isRecurring: map['isRecurring'] as bool,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
