import 'package:flutter/material.dart';
import 'package:money/core/widgets_for_all_app/gradient_button.dart';

class SubmitButton extends StatelessWidget {
  final bool isLoading;
  final String transactionType;
  final VoidCallback onPressed;

  const SubmitButton({
    super.key,
    required this.isLoading,
    required this.transactionType,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GradientButton(
      text: isLoading
          ? 'Adding...'
          : 'Add ${transactionType == 'income' ? 'Income' : 'Expense'}',
      onTap: isLoading ? null : onPressed,
    );
  }
}
