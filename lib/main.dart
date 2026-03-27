import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/home/data/home_repository_impl.dart';
import 'features/home/presentation/view/home_tab.dart';

// اليوزر الثابت اللي كريتناه في الفايربيز كونسول
const String kStaticUserId = 'my_static_user_001';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // نداء واحد فقط لـ Firebase Options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MoneyApp());
}

class MoneyApp extends StatelessWidget {
  const MoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<HomeRepositoryImpl>(
      create: (context) => HomeRepositoryImpl(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        home: const HomeTab(),
      ),
    );
  }
}