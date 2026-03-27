import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/transaction_model.dart';
import '../../../domain/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> fetchHomeData(String userId) async {
    emit(HomeLoading());
    try {
      final now = DateTime.now();

      // توسيع الـ Future.wait لطلب كل البيانات اللي الـ HomeScreen محتاجاها
      final results = await Future.wait([
        _repository.getUserBalance(userId),               // [0]
        _repository.calculateMonthTotal(userId, now.month, now.year), // [1]
        _repository.calculateMonthTotal(userId, now.month - 1, now.year), // [2]
        _repository.calculateMonthIncome(userId, now.month, now.year), // [3]
        _repository.getTopSpendingCategory(userId, now.month, now.year), // [4]
        _repository.getTransactionCount(userId, now.month, now.year), // [5]
      ]);

      final expenses = (results[1] as num).toDouble();
      final income = (results[3] as num).toDouble();

      // حساب الـ Health Score (معادلة بسيطة: الدخل مقابل المصاريف)
      double healthScore = income > 0 ? ((income - expenses) / income).clamp(0, 1) : 0.0;

      emit(HomeSuccess(
        balance: (results[0] as num).toDouble(),
        monthlyExpenses: expenses,
        lastMonthExpenses: (results[2] as num).toDouble(),
        monthlyIncome: income,
        healthScore: healthScore, // الربط مع FinancialHealthCard
        topCategory: results[4] as String, // الربط مع FinancialStatsGrid
        topCategoryAmount: 0.0, // ممكن تضيف Method في الـ Repo لو حبيت تجيب الرقم بالظبط
        transactionCount: results[5] as int, // الربط مع الـ Grid
      ));
    } catch (e) {
      emit(HomeError("فشل تحميل البيانات: ${e.toString()}"));
    }
  }

  // الميثود الموحدة للزار (Floating Button)
  Future<void> addTransactionAndRefresh(String userId, AppTransaction transaction) async {
    try {
      await _repository.addTransactionAndAdjustBalance(userId, transaction);
      await fetchHomeData(userId);
    } catch (e) {
      emit(HomeError("فشل إضافة المعاملة"));
    }
  }

  // الميثود الموحدة لدايلوج التحديث
  Future<void> updateBalance(String userId, double amount) async {
    try {
      await _repository.updateBalance(userId, amount);
      await fetchHomeData(userId);
    } catch (e) {
      emit(HomeError("فشل تحديث الرصيد"));
    }
  }
}