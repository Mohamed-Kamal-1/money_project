import 'package:flutter/material.dart';
import 'package:money/features/home/presentation/view/widgets/home_screen/quick_actions_button.dart';

import '../../../../../../core/colors/app_color.dart';
import '../../../../../../core/dimensions/dimension_app.dart';
import '../../../../../../core/extensions/theme_extension.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimension.spacing12,
      children: [
        Text(
          'QUICK ACTIONS',
          style: context.fonts.bodySmall?.copyWith(
            color: AppColor.gray,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          spacing: Dimension.spacing12,
          children: [
            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  Feedback.forTap(context);
                },
                iconAndTextColor: AppColor.softLavender,
                icon: Icons.add,
                backgroundColor: AppColor.darkMidnightBlue,
                text: 'Add',
              ),
            ),
            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  Feedback.forTap(context);
                },
                iconAndTextColor: AppColor.emeraldGreen,
                icon: Icons.receipt,
                backgroundColor: AppColor.darkGreen,
                text: 'History',
              ),
            ),

            Expanded(
              child: QuickActionsButton(
                onTap: () {
                  Feedback.forTap(context);
                },
                iconAndTextColor: AppColor.amberOrange,
                icon: Icons.account_balance,
                backgroundColor: AppColor.darkOliveDrab,
                text: 'Budget',
              ),
            ),
            // Expanded(
            //   child: FinancialCard(
            //     verticalPadding: Dimension.padding19,
            //     horizontalPadding: Dimension.padding27,
            //     alignment: .spaceEvenly,
            //     crossAlignment: CrossAxisAlignment.center,
            //     height: Dimension.heightCard103,
            //     color: AppColor.darkMidnightBlue,
            //     children: [
            //       Icon(Icons.add, color: AppColor.softLavender),
            //       Text('Add'),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: FinancialCard(
            //     verticalPadding: Dimension.padding19,
            //     horizontalPadding: Dimension.padding27,
            //     alignment: .spaceEvenly,
            //     crossAlignment: CrossAxisAlignment.center,
            //     height: Dimension.heightCard103,
            //     color: AppColor.darkGreen,
            //     children: [
            //       Icon(Icons.receipt, color: AppColor.emeraldGreen, size: 30),
            //       Text(
            //         'History',
            //         style: context.fonts.bodyMedium?.copyWith(
            //           color: AppColor.emeraldGreen,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: FinancialCard(
            //     verticalPadding: Dimension.padding19,
            //     horizontalPadding: Dimension.padding27,
            //     alignment: .spaceEvenly,
            //     crossAlignment: CrossAxisAlignment.center,
            //     height: Dimension.heightCard103,
            //     color: AppColor.darkOliveDrab,
            //     children: [
            //       Icon(Icons.account_balance, color: AppColor.amberOrange),
            //       Text(
            //         'Budget',
            //         style: context.fonts.bodyMedium?.copyWith(
            //           color: AppColor.amberOrange,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
