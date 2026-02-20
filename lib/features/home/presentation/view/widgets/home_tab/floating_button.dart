import 'package:flutter/material.dart';

import '../../../../../../../core/colors/app_color.dart';
import '../../../../../../../core/routes/app_route.dart';


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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(360),
        ),
        mini: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.AddExpenseScreen.name);
        },

        child: Icon(Icons.add),
      ),
    );
  }
}
