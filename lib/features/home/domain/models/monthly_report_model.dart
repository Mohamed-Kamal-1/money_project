import 'package:cloud_firestore/cloud_firestore.dart';

class MonthlyReport {
  final String? id;
  final String userId;
  final int month;
  final int year;
  final double totalExpenses;
  final double dailyAverage;
  final double percentageChange; // vs previous month
  final Map<String, double> categoryBreakdown;
  final String spendingBehavior; // e.g., "Higher on weekends"
  final DateTime createdAt;

  MonthlyReport({
    this.id,
    required this.userId,
    required this.month,
    required this.year,
    required this.totalExpenses,
    required this.dailyAverage,
    required this.percentageChange,
    required this.categoryBreakdown,
    required this.spendingBehavior,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'month': month,
      'year': year,
      'totalExpenses': totalExpenses,
      'dailyAverage': dailyAverage,
      'percentageChange': percentageChange,
      'categoryBreakdown': categoryBreakdown,
      'spendingBehavior': spendingBehavior,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory MonthlyReport.fromJson(Map<String, dynamic> json, String id) {
    return MonthlyReport(
      id: id,
      userId: json['userId'] as String? ?? '',
      month: json['month'] as int? ?? 1,
      year: json['year'] as int? ?? 2024,
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      dailyAverage: (json['dailyAverage'] as num?)?.toDouble() ?? 0.0,
      percentageChange: (json['percentageChange'] as num?)?.toDouble() ?? 0.0,
      categoryBreakdown:
          Map<String, double>.from(json['categoryBreakdown'] as Map? ?? {}),
      spendingBehavior: json['spendingBehavior'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Create from DocumentSnapshot
  factory MonthlyReport.fromFirestore(DocumentSnapshot doc) {
    return MonthlyReport.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

  // Copy with method
  MonthlyReport copyWith({
    String? id,
    String? userId,
    int? month,
    int? year,
    double? totalExpenses,
    double? dailyAverage,
    double? percentageChange,
    Map<String, double>? categoryBreakdown,
    String? spendingBehavior,
    DateTime? createdAt,
  }) {
    return MonthlyReport(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      month: month ?? this.month,
      year: year ?? this.year,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      dailyAverage: dailyAverage ?? this.dailyAverage,
      percentageChange: percentageChange ?? this.percentageChange,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      spendingBehavior: spendingBehavior ?? this.spendingBehavior,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
