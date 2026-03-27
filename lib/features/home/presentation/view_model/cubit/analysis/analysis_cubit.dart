import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../domain/repository/home_repository.dart';
import '../../../view/widgets/analysis/donut_chart_painter.dart';
import 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final HomeRepository _repository;

  AnalysisCubit(this._repository) : super(AnalysisInitial());

  // داخل class AnalysisCubit
  Future<void> loadAnalytics({
    required String userId, // الـ ID بييجي من بره دلوقتي
    int? month,
    int? year,
  }) async {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    emit(AnalysisLoading());

    try {
      final results = await Future.wait([
        _repository.calculateMonthTotal(userId, targetMonth, targetYear),
        _repository.calculateMonthIncome(userId, targetMonth, targetYear),
        _repository.calculateDailyAverage(userId, targetMonth, targetYear),
        _repository.getCategorySpending(userId, targetMonth, targetYear),
        _repository.getTransactionCount(userId, targetMonth, targetYear),
        _repository.getTopSpendingCategory(userId, targetMonth, targetYear),
      ]);

      // ... باقي الكود كما هو ...
    } catch (e) {
      emit(AnalysisError("Failed to load analytics: ${e.toString()}"));
    }
  }

  // دالة تحويل البيانات لرسوم بيانية (Logic الطبقة دي)
  List<DonutSegment> _generateDonutSegments(
    Map<String, double> data,
    double total,
  ) {
    if (total <= 0) return [];

    // استخدم ألوانك النيون من الـ AppColor لضمان الهوية البصرية
    final List<Color> chartColors = [
      AppColor.blueStart, // الأزرق النيون
      AppColor.emeraldGreen, // الأخضر
      AppColor.lightRed, // الأحمر الهادي
      AppColor.amberOrange, // البرتقالي
      Colors.purpleAccent, // البنفسجي
    ];

    int i = 0;
    return data.entries.map((entry) {
      final percentage = (entry.value / total) * 100;

      return DonutSegment(
        label: entry.key, // ربط الاسم بـ label
        amount: entry.value, // ربط القيمة بـ amount
        percentage: percentage,
        color: chartColors[i++ % chartColors.length], // توزيع الألوان بالتوالي
      );
    }).toList();
  }
}
