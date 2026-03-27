abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {
  final double balance;
  final double monthlyExpenses;
  final double lastMonthExpenses;
  final double monthlyIncome;
  // أضفت دول عشان الـ UI يكون ديناميكي بالكامل
  final double healthScore;
  final String topCategory;
  final double topCategoryAmount;
  final int transactionCount;

  HomeSuccess({
    required this.balance,
    required this.monthlyExpenses,
    required this.lastMonthExpenses,
    required this.monthlyIncome,
    this.healthScore = 78,
    this.topCategory = 'Food & Dining',
    this.topCategoryAmount = 842.0,
    this.transactionCount = 47,
  });
}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}