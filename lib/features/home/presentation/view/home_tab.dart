import 'package:flutter/material.dart';
import 'package:money/features/home/presentation/view/analysis_screen.dart';
import 'package:money/features/home/presentation/view/widgets/home_tab/bottom_nav_bar.dart';

import '../../../categories/presentation/view/categories_screen.dart';
import 'home_screen.dart';
import 'monthly_report_screen_new.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final List<Widget> tabs;

  @override
  void initState() {
    super.initState();

    tabs = const [
      HomeScreen(),
      AnalysisScreen(),
      SizedBox(), // Placeholder for center FAB
      CategoriesScreen(),
      MonthlyReportScreen(),
    ];
  }

  int indexSelect = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: indexSelect,
        onClick: (index) {
          if (index == 2) return; // Center FAB, handled separately
          if (indexSelect == index) return;
          setState(() {
            indexSelect = index;
          });
        },
      ),
      body: IndexedStack(index: indexSelect, children: tabs),
    );
  }
}
