import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/analytics_repository.dart';
import 'analytics_state.dart';

@injectable
class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsCubit(this._repository) : super(AnalyticsInitial());

  /// Load all analytics for a specific month/year
  Future<void> loadAnalytics(String userId, int month, int year) async {
    emit(AnalyticsLoading());
    try {
      // استخدام await منفصل بدلاً من Future.wait مع as unsafe
      final monthTotal = await _repository.calculateMonthTotal(
        userId,
        month,
        year,
      );
      final monthIncome = await _repository.calculateMonthIncome(
        userId,
        month,
        year,
      );
      final dailyAverage = await _repository.calculateDailyAverage(
        userId,
        month,
        year,
      );
      final percentageChange = await _repository.getPercentageChange(
        userId,
        month,
        year,
      );
      final spendingBehavior = await _repository.analyzSpendingBehavior(
        userId,
        month,
        year,
      );
      final topCategory = await _repository.getTopSpendingCategory(
        userId,
        month,
        year,
      );
      final categorySpending = await _repository.getCategorySpending(
        userId,
        month,
        year,
      );
      final transactionCount = await _repository.getTransactionCount(
        userId,
        month,
        year,
      );

      emit(
        AnalyticsLoaded(
          monthTotal: monthTotal,
          monthIncome: monthIncome,
          dailyAverage: dailyAverage,
          percentageChange: percentageChange,
          spendingBehavior: spendingBehavior,
          topCategory: topCategory,
          categorySpending: categorySpending,
          transactionCount: transactionCount,
        ),
      );
    } catch (e) {
      emit(AnalyticsError(e.toString()));
    }
  }

  /// Refresh only total expenses (lightweight update)
  Future<void> refreshMonthTotal(String userId, int month, int year) async {
    if (state is AnalyticsLoaded) {
      final currentState = state as AnalyticsLoaded;
      try {
        final newTotal = await _repository.calculateMonthTotal(
          userId,
          month,
          year,
        );
        // إعادة emit بنفس البيانات القديمة + monthTotal الجديد
        emit(currentState.copyWith(monthTotal: newTotal));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    }
  }
}
