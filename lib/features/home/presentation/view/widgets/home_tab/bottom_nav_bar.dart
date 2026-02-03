import 'package:flutter/material.dart';

import 'floating_button.dart';

typedef OnClick = Function(int index);

class AppBottomNavBar extends StatelessWidget {
  final OnClick onClick;
  final int currentIndex;

  const AppBottomNavBar(
      {super.key, required this.onClick, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white10, width: 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: NavigationBar(
          animationDuration: const Duration(seconds: 1, milliseconds: 100),
          selectedIndex: currentIndex,

          onDestinationSelected: onClick,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_filled), label: "Home"),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              label: "Analytics",
            ),
            // const SizedBox(width: 0,),

            RepaintBoundary(child: FloatingButton()),

            NavigationDestination(
              icon: Icon(Icons.history_sharp),
              label: "History",
            ),


            NavigationDestination(
              icon: Icon(Icons.description_rounded),
              label: "Profile",
            ),
          ],
        ),)
      ,
    );
  }
}
