import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xFF0B0F19);
  static const Color hoverIcons = Colors.lightBlue;
  static const Color bottomNavBarBackGround = Color(0xFF121826);
  static const Color dividerColor = Color(0xFF1B1E2B);
  static const Color gray = Color(0xFF64748B);
  static const Color green = Color(0xFF062C26);

  static const Color blueStart = Color(0xFF3B82F6);
  static const Color purpleEnd = Color(0xFFA855F7);

  static const LinearGradient navGradient = LinearGradient(
    colors: [blueStart, purpleEnd],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
