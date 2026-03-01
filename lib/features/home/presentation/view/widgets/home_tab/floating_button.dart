import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money/features/home/presentation/providers/home_providers.dart';

import '../../../../../../core/colors/app_color.dart';
import '../home_screen/add_transaction_dialog.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColor.navGradient,
        borderRadius: BorderRadius.circular(360),
        // borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(360),
        //   bottomRight: Radius.circular(360),
        //   topLeft: Radius.circular(360),
        //   topRight: Radius.circular(360),
        boxShadow: [
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
          final categories = context.read<CategoryNotifier>().categories;
          AddTransactionDialog.show(
            context,
            userId: 'test_user_123', // TODO: Get from FirebaseAuth
            categories: categories,
            onTransactionAdded: (transaction) {
              context.read<TransactionNotifier>().addTransaction(transaction);
              Navigator.of(context).pop();
            },
          );
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
