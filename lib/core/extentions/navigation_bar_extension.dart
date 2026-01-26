import 'package:flutter/material.dart';

extension ChangeIcon on NavigationBarThemeData {
  static WidgetStateProperty<IconThemeData> changeNavigationBarColor() {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(color: Colors.white, size: 27);
      } else {
        return IconThemeData(color: Color(0xFF64748B));
      }
    });
  }

  static  WidgetStateTextStyle changeNavigationBarText() {
    return WidgetStateTextStyle.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TextStyle(color: Color(0xFF3B82F6));
      } else {
        return TextStyle(color: Color(0xFF64748B));
      }
    });
  }
}


