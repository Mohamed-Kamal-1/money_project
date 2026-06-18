import 'package:flutter/material.dart';

import '../../../analytics/presentation/view/screens/analysis_screen.dart';
import '../../../categories/presentation/view/categories_screen.dart';
import '../../../monthly_report/presentation/view/screens/monthly_report_screen_new.dart';
import 'home_screen.dart';
import 'widgets/home_tab/bottom_nav_bar.dart';

class HomeTab extends StatefulWidget {
  final String userId;
  const HomeTab({super.key, required this.userId});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();
    // هنا نمرر userId لكل شاشة وكل Cubit سيستخدم userId الخاص به
    tabs = [
      HomeScreen(userId: widget.userId),
      AnalysisScreen(userId: widget.userId),
      const SizedBox(),
      CategoriesScreen(userId: widget.userId),
      MonthlyReportScreen(userId: widget.userId),
    ];
  }

  int indexSelect = 0;

  @override
  Widget build(BuildContext context) {
    // نقدم الـ Cubits التي تحتاج userId في هذا السياق
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: indexSelect,
        onClick: (index) {
          if (index == 2) return;
          if (indexSelect == index) return;
          setState(() => indexSelect = index);
        },
      ),
      body: IndexedStack(index: indexSelect, children: tabs),
    );
  }
}
