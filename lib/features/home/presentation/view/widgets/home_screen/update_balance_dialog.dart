// import 'package:flutter/material.dart';
// import 'package:money/core/colors/app_color.dart';
// import 'package:money/core/extensions/theme_extension.dart';
// import 'package:money/core/widgets_for_all_app/gradient_button.dart';
//
// class UpdateBalanceDialog extends StatefulWidget {
//   final String userId;
//   final double currentBalance;
//
//   const UpdateBalanceDialog({
//     super.key,
//     required this.userId,
//     required this.currentBalance,
//   });
//
//   @override
//   State<UpdateBalanceDialog> createState() => _UpdateBalanceDialogState();
// }
//
// class _UpdateBalanceDialogState extends State<UpdateBalanceDialog> {
//   late TextEditingController _controller;
//   final ExpenseRepository _repository = ExpenseRepositoryImpl();
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = TextEditingController(text: widget.currentBalance.toString());
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateBalance() async {
//     final amount = double.tryParse(_controller.text);
//     if (amount == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       await _repository.updateBalance(widget.userId, amount);
//       if (mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Balance updated successfully')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: $e')));
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: AppColor.primaryColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Update Balance',
//               style: context.fonts.headlineSmall?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _controller,
//               keyboardType: const TextInputType.numberWithOptions(
//                 decimal: true,
//               ),
//               style: context.fonts.titleMedium?.copyWith(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: 'Balance',
//                 labelStyle: TextStyle(color: AppColor.gray),
//                 prefixText: '\$ ',
//                 prefixStyle: TextStyle(color: Colors.white),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColor.inputFieldBorder),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: AppColor.blueStart),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (_isLoading)
//               const Center(child: CircularProgressIndicator())
//             else
//               GradientButton(text: 'Save', onTap: _updateBalance),
//           ],
//         ),
//       ),
//     );
//   }
// }
