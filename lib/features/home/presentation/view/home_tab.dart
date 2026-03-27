import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money/features/home/presentation/view/widgets/home_tab/bottom_nav_bar.dart';
import '../../../../main.dart';
import '../../data/home_repository_impl.dart';
import '../view_model/cubit/home_cubit.dart';
import '../view_model/cubit/analysis/analysis_cubit.dart';
import 'home_screen.dart';
import 'analysis_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // شاشة الهوم مع الـ Cubit بتاعها فقط
          BlocProvider(
            create: (context) => HomeCubit(context.read<HomeRepositoryImpl>())
              ..fetchHomeData(kStaticUserId),
            child: const HomeScreen(),
          ),
          // شاشة التحليل مع الـ Cubit بتاعها فقط
          BlocProvider(
            create: (context) => AnalysisCubit(context.read<HomeRepositoryImpl>())
              ..loadAnalytics(userId: kStaticUserId),
            child: const AnalysisScreen(),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onClick: (index) => setState(() => _currentIndex = index),
      ),

    );
  }
}