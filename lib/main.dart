// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'core/theme/app_theme.dart';
// import 'features/home/data/firestore_service.dart';
// import 'features/home/data/user_setting_repository_impl.dart';
// import 'features/home/presentation/providers/home_providers.dart';
// import 'features/home/presentation/view/home_tab.dart';
// import 'firebase_options.dart';
//
// const String kUserId = 'njjgYe3zMmYLcwzyodfFUB2G6eG3';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         Provider<FirestoreService>(create: (_) => FirestoreService()),
//         ProxyProvider<FirestoreService, HomeRepositoryImpl>(
//           update: (_, firestoreService, previous) =>
//               HomeRepositoryImpl(firestoreService),
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, BalanceNotifier>(
//           create: (context) {
//             final notifier = BalanceNotifier(
//               Provider.of<HomeRepositoryImpl>(context, listen: false),
//             );
//             notifier.listenToBalance(kUserId);
//             return notifier;
//           },
//           update: (_, repository, previous) => previous!,
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, TransactionNotifier>(
//           create: (context) => TransactionNotifier(
//             Provider.of<HomeRepositoryImpl>(context, listen: false),
//           ),
//           update: (_, repository, previous) => previous!,
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, CategoryNotifier>(
//           create: (context) {
//             final notifier = CategoryNotifier(
//               Provider.of<HomeRepositoryImpl>(context, listen: false),
//             );
//             notifier.listenToCategories(kUserId);
//             return notifier;
//           },
//           update: (_, repository, previous) => previous!,
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, MonthlyReportNotifier>(
//           create: (context) {
//             final notifier = MonthlyReportNotifier(
//               Provider.of<HomeRepositoryImpl>(context, listen: false),
//             );
//             notifier.listenToReports(kUserId);
//             return notifier;
//           },
//           update: (_, repository, previous) => previous!,
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, AnalyticsNotifier>(
//           create: (context) {
//             final notifier = AnalyticsNotifier(
//               Provider.of<HomeRepositoryImpl>(context, listen: false),
//             );
//             final now = DateTime.now();
//             notifier.loadAnalytics(kUserId, now.month, now.year);
//             return notifier;
//           },
//           update: (_, repository, previous) => previous!,
//         ),
//         ChangeNotifierProxyProvider<HomeRepositoryImpl, UserSettingsNotifier>(
//           create: (context) {
//             final notifier = UserSettingsNotifier(
//               Provider.of<HomeRepositoryImpl>(context, listen: false),
//             );
//             notifier.listenToSettings(kUserId);
//             return notifier;
//           },
//           update: (_, repository, previous) => previous!,
//         ),
//       ],
//       child: Consumer<UserSettingsNotifier>(
//         builder: (context, settingsNotifier, _) {
//           final isDarkMode = settingsNotifier.settings?.darkMode ?? true;
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: isDarkMode ? AppTheme.appTheme : AppTheme.appTheme,
//             home: const HomeTab(),
//           );
//         },
//       ),
//     );
//   }
// }

// مؤقتاً، سيتم استبداله بـ AuthCubit
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/core/di/injection.dart';
import 'package:money/core/theme/app_theme.dart';
import 'package:money/features/home/presentation/view/home_tab.dart';
import 'package:money/user_setting/presentation/cubit/user_settings/user_settings_cubit.dart';

import 'features/analytics/presentation/cubit/analytics_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/auth_state.dart';
import 'features/auth/presentation/view/login_screen.dart';
import 'features/balance/presentation/cubit/balance_cubit.dart';
import 'features/categories/presentation/cubit/category_cubit.dart';
import 'features/monthly_report/presentation/cubit/monthly_report_cubit.dart';
import 'features/transaction/presentation/cubit/transaction/transaction_cubit.dart';
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
        BlocProvider(create: (_) => getIt.get<AuthCubit>()),
        BlocProvider(create: (_) => getIt.get<BalanceCubit>()),
        BlocProvider(create: (_) => getIt.get<AnalyticsCubit>()),
        BlocProvider(create: (_) => getIt.get<MonthlyReportCubit>()),
        BlocProvider(create: (_) => getIt.get<TransactionCubit>()),
        BlocProvider(create: (_) => getIt.get<CategoryCubit>()),
        BlocProvider(create: (_) => getIt.get<UserSettingsCubit>()),
        // لا نضيف Cubits أخرى هنا لأنها تحتاج userId الذي يعرف بعد المصادقة
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appTheme,
            home: _getInitialScreen(authState, context),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(AuthState authState, BuildContext context) {
    if (authState is Authenticated) {
      // ✅ userId الحقيقي للمستخدم المسجل
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
