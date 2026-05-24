import 'package:flutter/material.dart';
import 'package:money/features/home/presentation/view/analysis_screen.dart';
import 'package:money/features/home/presentation/view/widgets/home_tab/bottom_nav_bar.dart';

import '../../../categories/presentation/view/categories_screen.dart';
import 'home_screen.dart';

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
      CategoriesScreen(),
      AnalysisScreen(),
      AnalysisScreen(),
      CategoriesScreen(),
    ];
  }

  int indexSelect = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      // floatingActionButton: const RepaintBoundary(child: FloatingButton()),

      bottomNavigationBar:
      AppBottomNavBar(
        currentIndex: indexSelect,
        onClick: (index) {
          if (indexSelect == index) return;
          setState(() {
            indexSelect = index;
          });
        },
      )
      ,
      body: IndexedStack(
        index: indexSelect,
        children: tabs,
      ),
    );
  }


}
