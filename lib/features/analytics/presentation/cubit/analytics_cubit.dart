import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/analytics_repository.dart';
import 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;
  StreamSubscription<AnalyticsData>? _analyticsSubscription;

  AnalyticsCubit(this._repository) : super(AnalyticsInitial());

  /// بدء الاستماع إلى التحليلات في الوقت الفعلي
  void watchAnalytics(String userId, int month, int year) {
    emit(AnalyticsLoading());
    _analyticsSubscription?.cancel();
    _analyticsSubscription = _repository
        .watchAnalytics(userId, month, year)
        .listen(
          (data) => emit(
            AnalyticsLoaded(
              monthTotal: data.monthTotal,
              monthIncome: data.monthIncome,
              dailyAverage: data.dailyAverage,
              percentageChange: data.percentageChange,
              spendingBehavior: data.spendingBehavior,
              topCategory: data.topCategory,
              categorySpending: data.categorySpending,
              transactionCount: data.transactionCount,
            ),
          ),
          onError: (error) => emit(AnalyticsError(error.toString())),
        );
  }

  @override
  Future<void> close() {
    _analyticsSubscription?.cancel();
    return super.close();
  }
}
