import 'package:equatable/equatable.dart';

class MonthlyReport extends Equatable {
  final String? id;
  final String userId;
  final int month;
  final int year;
  final double totalIncome;
  final double totalExpenses;
  final Map<String, double> categoriesSpending;
  final DateTime createdAt;

  const MonthlyReport({
    this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.totalIncome,
    required this.totalExpenses,
    required this.categoriesSpending,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    month,
    year,
    totalIncome,
    totalExpenses,
    categoriesSpending,
    createdAt,
  ];

  MonthlyReport copyWith({
    String? id,
    String? userId,
    int? month,
    int? year,
    double? totalIncome,
    double? totalExpenses,
    Map<String, double>? categoriesSpending,
    DateTime? createdAt,
  }) {
    return MonthlyReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      year: year ?? this.year,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      categoriesSpending: categoriesSpending ?? this.categoriesSpending,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
