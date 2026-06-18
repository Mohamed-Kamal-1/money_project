import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../auth_feature/presentation/view_model/cubit/auth_cubit.dart';
import '../../../../../auth_feature/presentation/view_model/cubit/auth_state.dart';
import '../../../../../categories/domain/entities/category.dart';
import '../../../../../categories/presentation/cubit/category_cubit.dart';
import '../../../../../categories/presentation/cubit/category_state.dart';
import '../../../../../transaction/presentation/cubit/transaction/transaction_cubit.dart';
import '../home_screen/add_transaction_dialog.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if (authState is! Authenticated) return const SizedBox.shrink();
    final userId = authState.user.uid;
    // إذا لم يكن هناك مستخدم، لا تعرض الزر أو تعطله
    if (userId.isEmpty) return const SizedBox.shrink();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColor.navGradient,
        borderRadius: BorderRadius.circular(360),
        boxShadow: const [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        mini: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        onPressed: () {
          final state = context.read<CategoryCubit>().state;
          List<Category> categories = [];
          if (state is CategoryLoaded) {
            categories = state.categories;
          }
          AddTransactionDialog.show(
            context,
            userId: userId,
            categories: categories,
            onTransactionAdded: (transaction) async {
              try {
                await context
                    .read<TransactionCubit>()
                    .addTransactionWithBalanceUpdate(transaction);
                // يمكن إعادة تحميل التحليلات أو الرصيد هنا إذا لزم الأمر
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully'),
                      backgroundColor: AppColor.emeraldGreen,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: AppColor.lightRed,
                    ),
                  );
                }
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
