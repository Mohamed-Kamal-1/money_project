  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  import '../../../../../../core/colors/app_color.dart';
  import '../../../../../../main.dart'; // عشان الـ kUserId
  import '../../../view_model/cubit/home_cubit.dart';
  import '../home_screen/add_transaction_dialog.dart';

  class FloatingButton extends StatelessWidget {
    const FloatingButton({super.key});

    @override
    Widget build(BuildContext context) {
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
          onPressed: () => _onFabPressed(context),
          // فصلنا اللوجيك في دالة خاصة
          child: const Icon(Icons.add),
        ),
      );
    }

    void _onFabPressed(BuildContext context) {
      // 1. بناخد الـ Cubits قبل ما نفتح الـ Dialog عشان نضمن إن الـ Reference معانا
      final homeCubit = context.read<HomeCubit>();
      // فرضاً إن الفئات بتيجي من كابت تاني أو من الـ HomeState
      // final categories = context.read<CategoryCubit>().state.categories;

      AddTransactionDialog.show(
        context,
        userId: 'my_static_user_001',
        categories: const [], // باصي الفئات من الـ State الحالية
        onTransactionAdded: (transaction) {
          // 2. التنفيذ بيتم من خلال الـ Cubit اللي شايل الـ Repository
          // والـ Repository جواه الـ ensureUserExists اللي ظبطناه
          homeCubit.addTransactionAndRefresh('my_static_user_001', transaction);
        },
      );
    }
  }