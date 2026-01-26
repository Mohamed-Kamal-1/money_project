
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/home/presentation/view/home_tab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: const HomeTab(),
    );
  }
}

