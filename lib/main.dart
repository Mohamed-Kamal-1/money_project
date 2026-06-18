import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/di/injection.dart';
import 'package:money/core/theme/app_theme.dart';
import 'package:money/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:money/features/auth_feature/presentation/view/login_screen.dart';
import 'package:money/features/auth_feature/presentation/view_model/cubit/auth_cubit.dart';
import 'package:money/features/auth_feature/presentation/view_model/cubit/auth_state.dart';
import 'package:money/features/balance/presentation/cubit/balance_cubit.dart';
import 'package:money/features/categories/presentation/cubit/category_cubit.dart';
import 'package:money/features/home/presentation/view/home_tab.dart';
import 'package:money/features/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'package:money/features/transaction/presentation/cubit/transaction/transaction_cubit.dart';
import 'package:money/user_setting/presentation/cubit/user_settings/user_settings_cubit.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()),
        BlocProvider(create: (_) => getIt<BalanceCubit>()),
        BlocProvider(create: (_) => getIt<AnalyticsCubit>()),
        BlocProvider(create: (_) => getIt<MonthlyReportCubit>()),
        BlocProvider(create: (_) => getIt<TransactionCubit>()),
        BlocProvider(create: (_) => getIt<CategoryCubit>()),
        BlocProvider(create: (_) => getIt<UserSettingsCubit>()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appTheme,
            home: _getInitialScreen(authState),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AuthState authState) {
    if (authState is Authenticated) {
      return HomeTab(userId: authState.user.uid);
    } else if (authState is Unauthenticated) {
      return const LoginScreen();
    } else if (authState is AuthLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (authState is AuthError) {
      return Scaffold(body: Center(child: Text('Error: ${authState.message}')));
    }
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
