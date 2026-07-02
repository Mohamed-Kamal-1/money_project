import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/balance_repository.dart';
import 'balance_state.dart';

@injectable
class BalanceCubit extends Cubit<BalanceState> {
  final BalanceRepository _repository;
  StreamSubscription<double>? _balanceSubscription;

  BalanceCubit(this._repository) : super(BalanceInitial());

  void listenToBalance(String userId) {
    emit(BalanceLoading());
    _balanceSubscription?.cancel();
    _balanceSubscription = _repository
        .getUserBalanceStream(userId)
        .listen(
          (balance) => emit(BalanceLoaded(balance)),
          onError: (error) => emit(BalanceError(error.toString())),
        );
  }

  Future<void> updateBalance(String userId, double newBalance) async {
    emit(BalanceLoading());
    try {
      final result = await _repository.updateUserBalance(userId, newBalance);
    } catch (e) {
      emit(BalanceError(e.toString()));
    }
  }

  void optimisticAdjustBalance(double newBalance) {
    emit(BalanceLoaded(newBalance));
  }

  @override
  Future<void> close() {
    _balanceSubscription?.cancel();
    return super.close();
  }
}
