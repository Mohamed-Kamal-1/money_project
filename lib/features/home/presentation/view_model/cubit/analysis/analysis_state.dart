import '../../../view/widgets/analysis/donut_chart_painter.dart'; // الموديل اللي فيه DonutSegment

abstract class AnalysisState {
  const AnalysisState();
}

// الحالة الابتدائية
class AnalysisInitial extends AnalysisState {}

// حالة التحميل (الـ Skeleton/Loading)
class AnalysisLoading extends AnalysisState {}

// الحالة الناجحة وشايلة كل "الزتونة"
class AnalysisSuccess extends AnalysisState {
  final double monthTotal;
  final double monthIncome;
  final double dailyAverage;
  final int transactionCount;
  final String topCategory;
  final Map<String, double> categorySpending;

  // بنجهز الداتا هنا عشان الـ Painter يستلمها جاهزة
  final List<DonutSegment> segments;

  const AnalysisSuccess({
    required this.monthTotal,
    required this.monthIncome,
    required this.dailyAverage,
    required this.transactionCount,
    required this.topCategory,
    required this.categorySpending,
    required this.segments,
  });

  // بنضيف الـ == operator عشان الـ Bloc يعرف لو الداتا اتغيرت فعلاً (Optimization)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AnalysisSuccess &&
              runtimeType == other.runtimeType &&
              monthTotal == other.monthTotal &&
              categorySpending == other.categorySpending;

  @override
  int get hashCode => monthTotal.hashCode ^ categorySpending.hashCode;
}

// حالة الخطأ
class AnalysisError extends AnalysisState {
  final String message;
  const AnalysisError(this.message);
}