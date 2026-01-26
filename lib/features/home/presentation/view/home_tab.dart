import 'package:flutter/material.dart';
import 'package:money/features/home/presentation/view/widgets/bottom_nav_bar.dart';
import 'package:money/features/home/presentation/view/widgets/floating_button.dart';



class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text('sd')]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingButton(),
      
      bottomNavigationBar: AppBottomNavBar(),
    );
  }
}
