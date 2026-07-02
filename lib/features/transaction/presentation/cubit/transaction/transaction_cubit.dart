import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/repositories/transaction_repository.dart';
import 'transaction_state.dart';

@injectable
class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(TransactionInitial());

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
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
