import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/monthly_report.dart';
import '../../domain/repositories/monthly_report_repository.dart';
import 'monthly_report_state.dart';

@injectable
class MonthlyReportCubit extends Cubit<MonthlyReportState> {
  final MonthlyReportRepository _repository;
  StreamSubscription<List<MonthlyReport>>? _reportsSubscription;

  MonthlyReportCubit(this._repository) : super(MonthlyReportInitial());

  void listenToReports(String userId) {
    emit(MonthlyReportLoading());
    _reportsSubscription?.cancel();
    _reportsSubscription = _repository
        .getUserMonthlyReportsStream(userId)
        .listen(
          (reports) => emit(MonthlyReportLoaded(reports)),
          onError: (error) => emit(MonthlyReportError(error.toString())),
        );
  }

  @override
  Future<void> close() {
    _reportsSubscription?.cancel();
    return super.close();
  }
}
