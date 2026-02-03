import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money/core/routes/app_route.dart';
import 'package:money/core/routes/routes.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      // initialRoute: AppRoute.HomeTab.name,
      initialRoute: AppRoute.LoginScreen.name,
      routes: routs,
    );
  }
}


// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AnimationPage(),
//     );
//   }
// }
//
// class AnimationPage extends StatefulWidget {
//   @override
//   _AnimationPageState createState() => _AnimationPageState();
// }
//
// class _AnimationPageState extends State<AnimationPage> {
//
//   double dimation = 100;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Container(
//                 width: dimation,
//                 height: dimation,
//                 decoration: BoxDecoration(
//                   color: Colors.blueAccent,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 40.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   dimation = 200;
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 50, vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Start Animation',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }