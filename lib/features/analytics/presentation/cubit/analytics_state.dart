import 'package:equatable/equatable.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final double monthTotal;
  final double monthIncome;
  final double dailyAverage;
  final double percentageChange;
  final String spendingBehavior;
  final String topCategory;
  final Map<String, double> categorySpending;
  final int transactionCount;

  const AnalyticsLoaded({
    required this.monthTotal,
    required this.monthIncome,
    required this.dailyAverage,
    required this.percentageChange,
    required this.spendingBehavior,
    required this.topCategory,
    required this.categorySpending,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [
    monthTotal,
    monthIncome,
    dailyAverage,
    percentageChange,
    spendingBehavior,
    topCategory,
    categorySpending,
    transactionCount,
  ];

  /// نسخة معدلة من الكائن (تسهل التحديثات الجزئية)
  AnalyticsLoaded copyWith({
    double? monthTotal,
    double? monthIncome,
    double? dailyAverage,
    double? percentageChange,
    String? spendingBehavior,
    String? topCategory,
    Map<String, double>? categorySpending,
    int? transactionCount,
  }) {
    return AnalyticsLoaded(
      monthTotal: monthTotal ?? this.monthTotal,
      monthIncome: monthIncome ?? this.monthIncome,
      dailyAverage: dailyAverage ?? this.dailyAverage,
      percentageChange: percentageChange ?? this.percentageChange,
      spendingBehavior: spendingBehavior ?? this.spendingBehavior,
      topCategory: topCategory ?? this.topCategory,
      categorySpending: categorySpending ?? this.categorySpending,
      transactionCount: transactionCount ?? this.transactionCount,
    );
  }
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
