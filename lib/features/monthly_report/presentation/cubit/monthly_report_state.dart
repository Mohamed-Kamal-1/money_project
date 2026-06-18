import 'package:equatable/equatable.dart';

import '../../domain/entities/monthly_report.dart';

abstract class MonthlyReportState extends Equatable {
  const MonthlyReportState();
  @override
  List<Object?> get props => [];
}

class MonthlyReportInitial extends MonthlyReportState {}

class MonthlyReportLoading extends MonthlyReportState {}

class MonthlyReportLoaded extends MonthlyReportState {
  final List<MonthlyReport> reports;
  const MonthlyReportLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class MonthlyReportError extends MonthlyReportState {
  final String message;
  const MonthlyReportError(this.message);
  @override
  List<Object?> get props => [message];
}
