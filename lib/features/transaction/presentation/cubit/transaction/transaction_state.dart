import 'package:equatable/equatable.dart';

import '../../../domain/entities/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

// ✅ حالة تحميل قائمة المعاملات
class TransactionLoaded extends TransactionState {
  final List<AppTransaction> transactions;
  const TransactionLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

// ✅ حالة إضافة معاملة
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

// ✅ حالة الخطأ
class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}
