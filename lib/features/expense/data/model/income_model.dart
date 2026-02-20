import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeModel {
  final String id;
  final double amount;
  final String source;
  final String description;
  final DateTime date;

  IncomeModel({
    required this.id,
    required this.amount,
    required this.source,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'source': source,
      'description': description,
      'date': Timestamp.fromDate(date),
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map, String id) {
    return IncomeModel(
      id: id,
      amount: (map['amount'] as num).toDouble(),
      source: map['source'] as String,
      description: map['description'] as String,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
