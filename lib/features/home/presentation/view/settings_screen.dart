// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:money/features/home/presentation/providers/home_providers.dart';
// import 'package:money/main.dart';
//
// import '../../../../core/colors/app_color.dart';
// import '../../../../core/dimensions/Dimension_app.dart';
// import '../../../../core/extensions/theme_extension.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});
//
//   /// Show settings as a full-screen modal
//   static Future<void> show(BuildContext context) {
//     return Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
//   }
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   bool _darkMode = true;
//   bool _notifications = false;
//   bool _isSigningOut = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }
//
//   Future<void> _loadPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _darkMode = prefs.getBool('darkMode') ?? true;
//       _notifications = prefs.getBool('notifications') ?? false;
//     });
//   }
//
//   Future<void> _toggleDarkMode(bool value) async {
//     setState(() => _darkMode = value);
//
//     // Save locally
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('darkMode', value);
//
//     // Save to Firestore
//     if (mounted) {
//       context.read<UserSettingsNotifier>().toggleDarkMode(kUserId, value);
//     }
//   }
//
//   Future<void> _toggleNotifications(bool value) async {
//     setState(() => _notifications = value);
//
//     // Save locally
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('notifications', value);
//
//     // Save to Firestore
//     if (mounted) {
//       context.read<UserSettingsNotifier>().toggleNotifications(kUserId, value);
//     }
//   }
//
//   Future<void> _signOut() async {
//     setState(() => _isSigningOut = true);
//     try {
//       await FirebaseAuth.instance.signOut();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Signed out successfully'),
//             backgroundColor: AppColor.emeraldGreen,
//           ),
//         );
//         Navigator.of(context).pop();
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error signing out: ${e.toString()}'),
//             backgroundColor: AppColor.lightRed,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isSigningOut = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.primaryColor,
//       appBar: AppBar(
//         backgroundColor: AppColor.primaryColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColor.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Settings',
//           style: context.fonts.headlineSmall?.copyWith(
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(Dimension.padding16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Appearance Section
//             _SectionHeader(title: 'APPEARANCE'),
//             _SettingTile(
//               icon: Icons.dark_mode,
//               iconColor: AppColor.softLavender,
//               title: 'Dark Mode',
//               subtitle: 'Use dark theme',
//               trailing: Switch(
//                 value: _darkMode,
//                 onChanged: _toggleDarkMode,
//                 activeColor: AppColor.blueStart,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // Notifications Section
//             _SectionHeader(title: 'NOTIFICATIONS'),
//             _SettingTile(
//               icon: Icons.notifications,
//               iconColor: AppColor.amberOrange,
//               title: 'Push Notifications',
//               subtitle: 'Get notified about spending',
//               trailing: Switch(
//                 value: _notifications,
//                 onChanged: _toggleNotifications,
//                 activeColor: AppColor.blueStart,
//               ),
//             ),
//             const SizedBox(height: 8),
//
//             // Account Section
//             _SectionHeader(title: 'ACCOUNT'),
//             _SettingTile(
//               icon: Icons.person,
//               iconColor: AppColor.emeraldGreen,
//               title: 'User ID',
//               subtitle: kUserId,
//             ),
//             const SizedBox(height: 8),
//
//             _SettingTile(
//               icon: Icons.logout,
//               iconColor: AppColor.lightRed,
//               title: 'Sign Out',
//               subtitle: 'Log out of your account',
//               trailing: _isSigningOut
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColor.lightRed,
//                       ),
//                     )
//                   : null,
//               onTap: _isSigningOut ? null : _signOut,
//             ),
//
//             const Spacer(),
//
//             // App version
//             Center(
//               child: Text(
//                 'Expense Tracker v1.0.0',
//                 style: context.fonts.bodySmall?.copyWith(
//                   color: AppColor.gray,
//                   fontSize: 11,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SectionHeader extends StatelessWidget {
//   final String title;
//   const _SectionHeader({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16, bottom: 8),
//       child: Text(
//         title,
//         style: Theme.of(context).textTheme.bodySmall?.copyWith(
//           color: AppColor.gray,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.8,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }
// }
//
// class _SettingTile extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String subtitle;
//   final Widget? trailing;
//   final VoidCallback? onTap;
//
//   const _SettingTile({
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.subtitle,
//     this.trailing,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: AppColor.bottomNavBarBackGround,
//           borderRadius: BorderRadius.circular(Dimension.circular12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: iconColor.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: iconColor, size: 18),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: AppColor.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     subtitle,
//                     style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: AppColor.gray,
//                       fontSize: 11,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (trailing != null) trailing!,
//           ],
//         ),
//       ),
//     );
//   }
// }
