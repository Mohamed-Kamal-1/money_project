import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'features/home/data/firestore_service.dart';
import 'features/home/data/home_repository_impl.dart';
import 'features/home/presentation/providers/home_providers.dart';
import 'features/home/presentation/view/home_tab.dart';
import 'firebase_options.dart';

const String kUserId =
    'test_user_123';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ProxyProvider<FirestoreService, HomeRepositoryImpl>(
          update: (_, firestoreService, __) =>
              HomeRepositoryImpl(firestoreService),
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, BalanceNotifier>(
          create: (context) {
            final notifier = BalanceNotifier(
              Provider.of<HomeRepositoryImpl>(context, listen: false),
            );
            notifier.listenToBalance(kUserId);
            return notifier;
          },
          update: (_, repository, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, TransactionNotifier>(
          create: (context) => TransactionNotifier(
            Provider.of<HomeRepositoryImpl>(context, listen: false),
          ),
          update: (_, repository, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, CategoryNotifier>(
          create: (context) {
            final notifier = CategoryNotifier(
              Provider.of<HomeRepositoryImpl>(context, listen: false),
            );
            notifier.listenToCategories(kUserId);
            return notifier;
          },
          update: (_, repository, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, MonthlyReportNotifier>(
          create: (context) {
            final notifier = MonthlyReportNotifier(
              Provider.of<HomeRepositoryImpl>(context, listen: false),
            );
            notifier.listenToReports(kUserId);
            return notifier;
          },
          update: (_, repository, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, AnalyticsNotifier>(
          create: (context) {
            final notifier = AnalyticsNotifier(
              Provider.of<HomeRepositoryImpl>(context, listen: false),
            );
            final now = DateTime.now();
            notifier.loadAnalytics(kUserId, now.month, now.year);
            return notifier;
          },
          update: (_, repository, previous) => previous!,
        ),
        ChangeNotifierProxyProvider<HomeRepositoryImpl, UserSettingsNotifier>(
          create: (context) {
            final notifier = UserSettingsNotifier(
              Provider.of<HomeRepositoryImpl>(context, listen: false),
            );
            notifier.listenToSettings(kUserId);
            return notifier;
          },
          update: (_, repository, previous) => previous!,
        ),
      ],
      child: Consumer<UserSettingsNotifier>(
        builder: (context, settingsNotifier, _) {
          final isDarkMode = settingsNotifier.settings?.darkMode ?? true;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: isDarkMode ? AppTheme.appTheme : AppTheme.appTheme,
            home: const HomeTab(),
          );
        },
      ),
    );
  }
}
