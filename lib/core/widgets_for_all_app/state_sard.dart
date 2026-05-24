import 'package:flutter/cupertino.dart';

import '../dimensions/dimension_app.dart';
import '../extensions/theme_extension.dart';
import 'financial_card.dart';

class StateCard extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final Color titleColor;
  final Color bgColor;
  final Color? midTextColor;
  final Color? lastTextColor;

  const StateCard({
    super.key,
    required this.text1,
    required this.text2,
    required this.text3,

    required this.titleColor,
    required this.bgColor,
    this.midTextColor,
    this.lastTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return FinancialCard(
      spacing: Dimension.spacing8,
      horizontalPadding: Dimension.padding24,
      alignment: MainAxisAlignment.center,
      borderRadius: Dimension.circular16,
      height: Dimension.heightCard116,
      color: bgColor,
      children: [
        Text(
          text1,
          style: context.fonts.headlineSmall?.copyWith(color: titleColor),
        ),
        Text(
          text2,
          style: context.fonts.labelSmall?.copyWith(color: midTextColor),
        ),

        Text(
          text3,
          style: context.fonts.bodyMedium?.copyWith(color: lastTextColor),
        ),
      ],
    );
  }
}
