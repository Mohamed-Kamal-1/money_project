import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../auth_feature/presentation/view_model/cubit/auth_cubit.dart';
import '../../../../../auth_feature/presentation/view_model/cubit/auth_state.dart';
import '../../../../../categories/domain/entities/category.dart';
import '../../../../../categories/presentation/cubit/category_cubit.dart';
import '../../../../../categories/presentation/cubit/category_state.dart';
import '../home_screen/transation_dialog/add_transaction_dialog.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    if (authState is! Authenticated) return const SizedBox.shrink();
    final userId = authState.user.uid;
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
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
