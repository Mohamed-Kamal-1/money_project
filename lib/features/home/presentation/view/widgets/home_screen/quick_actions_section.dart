// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../../../core/colors/app_color.dart';
// import '../../../../../../core/dimensions/Dimension_app.dart';
// import '../../../../../../core/extensions/theme_extension.dart';
// import '../../../view_model/cubit/home_cubit.dart';
// import '../../cubits/home_cubit.dart';
// import 'add_transaction_dialog.dart';
// import 'quick_actions_button.dart';
//
// class QuickActionsSection extends StatelessWidget {
//   const QuickActionsSection({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'QUICK ACTIONS',
//           style: context.fonts.bodySmall?.copyWith(
//             color: AppColor.gray,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//         const SizedBox(height: Dimension.spacing12),
//         Row(
//           children: [
//             Expanded(
//               child: QuickActionsButton(
//                 onTap: () => _openAddTransaction(context),
//                 iconAndTextColor: AppColor.softLavender,
//                 icon: Icons.add,
//                 backgroundColor: AppColor.darkMidnightBlue,
//                 text: 'Add',
//               ),
//             ),
//             const SizedBox(width: Dimension.spacing12),
//             Expanded(
//               child: QuickActionsButton(
//                 onTap: () { /* Navigate to History */ },
//                 iconAndTextColor: AppColor.emeraldGreen,
//                 icon: Icons.receipt,
//                 backgroundColor: AppColor.darkGreen,
//                 text: 'History',
//               ),
//             ),
//             const SizedBox(width: Dimension.spacing12),
//             Expanded(
//               child: QuickActionsButton(
//                 onTap: () { /* Navigate to Budget */ },
//                 iconAndTextColor: AppColor.amberOrange,
//                 icon: Icons.account_balance,
//                 backgroundColor: AppColor.darkOliveDrab,
//                 text: 'Budget',
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   void _openAddTransaction(BuildContext context) {
//     // بنفتح الدايلوج وبنديله الـ Cubit الحالي عشان يقدر ينفذ الأكشن
//     final homeCubit = context.read<HomeCubit>();
//     AddTransactionDialog.show(
//       context,
//       onSave: (transaction) {
//         homeCubit.addTransactionAndUpdate('user_123', transaction);
//       },
//     );
//   }
// }