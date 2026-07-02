import 'package:equatable/equatable.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionAdded extends TransactionState {
  final String transactionId;
  final double actualAmount;
  final bool wasAdjusted;

  const TransactionAdded({
    required this.transactionId,
    required this.actualAmount,
    this.wasAdjusted = false,
  });
  @override
  List<Object?> get props => [transactionId, actualAmount, wasAdjusted];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}
