import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money/core/colors/app_color.dart';

import '../extensions/navigation_bar_extension.dart';
import '../widgets_for_all_app/gradient_shape.dart';

class AppTheme {
  static final appTheme = ThemeData(

    pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }
    ),
    useMaterial3: true,
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

    textTheme: TextTheme(
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),

      titleLarge: GoogleFonts.inter(
        fontSize: 20,
        color: AppColor.gray,
        fontWeight: FontWeight.w400,
      ),

      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: AppColor.slateGray,
        fontWeight: FontWeight.w400,
      ),

      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        color: AppColor.lightGreen,
        fontWeight: FontWeight.w400,
      ),

      displayMedium: GoogleFonts.inter(
        fontSize: 40,
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),

      titleMedium: GoogleFonts.inter(
        fontSize: 18,
        color: AppColor.darkTeal,
        fontWeight: FontWeight.w400,
      ),

      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        color: AppColor.softLavender,
        fontWeight: FontWeight.w400,
      ),

      displayLarge: GoogleFonts.inter(
        fontSize: 56,
        color: AppColor.white,
        fontWeight: FontWeight.w400,
      ),

    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  );
}


