import 'package:flutter/material.dart';
import 'package:money/core/colors/app_color.dart';
import 'package:money/core/extentions/navigation_bar_extension.dart';

import '../widgets_for_all_app/gradient_shape.dart';

class AppTheme {
  static final appTheme = ThemeData(
    scaffoldBackgroundColor: AppColor.primaryColor,
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: ChangeIcon.changeNavigationBarColor(),
      indicatorShape: GradientShapeBorder(
        gradient: AppColor.navGradient,
        borderRadius: BorderRadius.circular(16),
      ),

      backgroundColor: AppColor.primaryColor,
      labelTextStyle: ChangeIcon.changeNavigationBarText(),
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}


