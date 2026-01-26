import 'package:flutter/material.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  int currentIndex = 0;

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

          onDestinationSelected: (value) {
            currentIndex = value;
            setState(() {});
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.home_filled), label: "Home"),
            NavigationDestination(
              icon: Icon(Icons.pie_chart_outline),
              label: "Analytics",
           ),
            const SizedBox(width: 0,),
            NavigationDestination(
             icon: Icon(Icons.history_sharp),
              label: "Search",
            ),

            NavigationDestination(
              icon: Icon(Icons.description_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
