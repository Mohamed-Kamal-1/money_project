import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;
  StreamSubscription<List<AppTransaction>>? _transactionsSubscription;

  TransactionCubit(this._repository) : super(TransactionInitial());

  // ==================== إضافة معاملة مع تحديث الرصيد ====================
  Future<void> addTransactionWithBalanceUpdate(
    AppTransaction transaction,
  ) async {
    emit(TransactionLoading());
    try {
      final result = await _repository.addTransactionWithBalanceUpdate(
        transaction,
      );
      emit(
        TransactionAdded(
          transactionId: result.transactionId,
          actualAmount: result.actualAmount,
          wasAdjusted: result.wasAdjusted,
        ),
      );
      // بعد الإضافة، نعيد تحميل القائمة تلقائياً (إذا كان هناك مستمع نشط)
      // سيتم التحديث عبر الـ stream إذا كان المستمع موجوداً
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // ==================== الاستماع إلى جميع المعاملات (لشاشة History) ====================
  void listenToTransactions(String userId) {
    emit(TransactionLoading());
    _transactionsSubscription?.cancel();
    _transactionsSubscription = _repository
        .getUserTransactionsStream(userId)
        .listen(
          (transactions) => emit(TransactionLoaded(transactions)),
          onError: (error) => emit(TransactionError(error.toString())),
        );
  }

  // ==================== تنظيف الموارد ====================
  @override
  Future<void> close() {
    _transactionsSubscription?.cancel();
    return super.close();
  }
}
