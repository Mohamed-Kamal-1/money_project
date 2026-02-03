import 'package:flutter/material.dart';
import 'package:money/features/categories/presentation/view/widgets/category_list_item.dart';

import '../../../../core/colors/app_color.dart';
import '../../../../core/dimensions/Dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/routes/app_route.dart';
import '../../../../core/widgets_for_all_app/gradient_button.dart';
import 'widgets/category_insights.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: Dimension.padding16,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimension.spacing16,
            children: [
              // Header
              Text('Categories', style: context.fonts.headlineSmall),
              Text(
                'Manage your expense categories',
                style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
              ),


              GradientButton(
                text: 'Add Custom Category',
                icon: Icons.add,
                onTap: () {
                  Navigator.pushNamed(context, AppRoute.AddExpenseScreen.name);
                },
              ),


              CategoryListItem(
                icon: Icons.restaurant,
                iconBackgroundColor: AppColor.orangeCategory,
                categoryName: ' Food & Dining',
                spent: 842,
                budget: 900,
              ),

              CategoryListItem(
                icon: Icons.directions_car,
                iconBackgroundColor: AppColor.pinkCategory,
                categoryName: 'Transport',
                spent: 456,
                budget: 600,
              ),

              CategoryListItem(
                icon: Icons.shopping_bag,
                iconBackgroundColor: AppColor.purpleCategory,
                categoryName: 'Shopping',
                spent: 623,
                budget: 800,
              ),

              CategoryListItem(
                icon: Icons.movie,
                iconBackgroundColor: AppColor.cyanCategory,
                categoryName: 'Entertainment',
                spent: 312,
                budget: 400,
              ),

              CategoryListItem(
                icon: Icons.favorite,
                iconBackgroundColor: AppColor.redCategory,
                categoryName: 'Health',
                spent: 234,
                budget: 500,
              ),

              CategoryListItem(
                icon: Icons.bolt,
                iconBackgroundColor: AppColor.blueCategoryDark,
                categoryName: 'Utilities',
                spent: 380,
                budget: 450,
              ),


              Container(height: 1, color: AppColor.borderGray),


              const CategoryInsights(
                totalCategories: 6,
                totalBudget: 3650,
                totalSpent: 2847,
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

}

class CategoryData {
  final IconData icon;
  final Color color;
  final String name;
  final double spent;
  final double budget;

  const CategoryData({
    required this.icon,
    required this.color,
    required this.name,
    required this.spent,
    required this.budget,
  });
}
