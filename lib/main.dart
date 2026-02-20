import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money/core/routes/app_route.dart';
import 'package:money/core/routes/routes.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      // initialRoute: AppRoute.HomeTab.name,
      initialRoute: AppRoute.HomeTab.name,
      routes: routs,
    );
  }
}

