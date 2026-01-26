import 'package:flutter/material.dart';

import '../../../../../core/colors/app_color.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppColor.navGradient,
        borderRadius: BorderRadius.circular(360),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        onPressed: () {},

        child: Icon(Icons.add),
      ),
    );
  }
}
