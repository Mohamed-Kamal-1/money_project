import 'package:flutter/material.dart';
import '../../../../../../core/colors/app_color.dart';

class UpdateBalanceDialog extends StatelessWidget {
  final Function(double) onUpdate;

  const UpdateBalanceDialog({super.key, required this.onUpdate});

  static void show(BuildContext context, Function(double) onUpdate) {
    showDialog(
      context: context,
      builder: (context) => UpdateBalanceDialog(onUpdate: onUpdate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return AlertDialog(
      backgroundColor: AppColor.bottomNavBarBackGround,
      title: const Text('Update Balance', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixText: '\$ ',
          filled: true,
          fillColor: AppColor.primaryColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            final val = double.tryParse(controller.text);
            if (val != null) {
              onUpdate(val);
              Navigator.pop(context);
            }
          },
          child: const Text('Update', style: TextStyle(color: AppColor.blueStart)),
        ),
      ],
    );
  }
}