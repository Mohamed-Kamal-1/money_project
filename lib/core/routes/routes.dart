import 'package:flutter/cupertino.dart';
import 'package:money/core/routes/app_route.dart';
import 'package:money/features/expense/presentation/view/add_expense_screen.dart';

import '../../features/home/presentation/view/home_tab.dart';
import '../../features/login_screen/login_screen.dart';

Map<String, Widget Function(BuildContext)> routs = {
  AppRoute.AddExpenseScreen.name: (context) => AddExpenseScreen(),
  AppRoute.HomeTab.name: (context) => HomeTab(),
  AppRoute.LoginScreen.name: (context) => LoginScreen(),
};
