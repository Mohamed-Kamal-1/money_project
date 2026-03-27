// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:money/features/categories/presentation/view/widgets/add_category_dialog.dart';
// import 'package:money/features/categories/presentation/view/widgets/category_list_item.dart';
// import 'package:money/features/home/presentation/providers/home_providers.dart';
// import 'package:money/main.dart';
//
// import '../../../../core/colors/app_color.dart';
// import '../../../../core/dimensions/Dimension_app.dart';
// import '../../../../core/extensions/theme_extension.dart';
// import '../../../../core/widgets_for_all_app/gradient_button.dart';
// import 'widgets/category_insights.dart';
//
// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: Dimension.padding16,
//         vertical: Dimension.padding16,
//       ),
//       child: SafeArea(
//         child: Consumer2<CategoryNotifier, AnalyticsNotifier>(
//           builder: (context, categoryNotifier, analyticsNotifier, _) {
//             final categories = categoryNotifier.categories;
//             final categorySpending = analyticsNotifier.categorySpending;
//
//             double totalBudget = 0;
//             double totalSpent = 0;
//             for (final cat in categories) {
//               totalBudget += cat.budget ?? 0;
//               totalSpent += categorySpending[cat.name] ?? 0;
//             }
//
//             if (categoryNotifier.isLoading && categories.isEmpty) {
//               return const Center(
//                 child: CircularProgressIndicator(color: AppColor.blueStart),
//               );
//             }
//
//             return CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     spacing: Dimension.spacing16,
//                     children: [
//                       // Header
//                       Text('Categories', style: context.fonts.headlineSmall),
//                       Text(
//                         'Manage your expense categories',
//                         style: context.fonts.bodyMedium?.copyWith(
//                           color: AppColor.gray,
//                         ),
//                       ),
//
//                       // Add Category Button
//                       GradientButton(
//                         text: 'Add Custom Category',
//                         icon: Icons.add,
//                         onTap: () {
//                           AddCategoryDialog.show(
//                             context,
//                             userId: kUserId,
//                             onCategoryAdded: (category) async {
//                               try {
//                                 await context
//                                     .read<CategoryNotifier>()
//                                     .addCategory(category);
//                               } catch (e) {
//                                 if (context.mounted) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('Error: ${e.toString()}'),
//                                       backgroundColor: AppColor.lightRed,
//                                     ),
//                                   );
//                                 }
//                               }
//                             },
//                           );
//                         },
//                       ),
//
//                       // Category List
//                       if (categories.isEmpty)
//                         Container(
//                           padding: const EdgeInsets.all(24),
//                           decoration: BoxDecoration(
//                             color: AppColor.bottomNavBarBackGround,
//                             borderRadius: BorderRadius.circular(
//                               Dimension.circular16,
//                             ),
//                           ),
//                           child: Center(
//                             child: Text(
//                               'No categories yet. Add your first one!',
//                               style: context.fonts.bodyMedium?.copyWith(
//                                 color: AppColor.gray,
//                               ),
//                             ),
//                           ),
//                         )
//                       else
//                         ...categories.map((cat) {
//                           final spent = categorySpending[cat.name] ?? 0;
//                           final icon = IconData(
//                             int.tryParse(cat.iconName) ??
//                                 Icons.category.codePoint,
//                             fontFamily: 'MaterialIcons',
//                           );
//                           return CategoryListItem(
//                             icon: icon,
//                             iconBackgroundColor: cat.color,
//                             categoryName: cat.name,
//                             spent: spent,
//                             budget: cat.budget ?? 0,
//                             onDelete: () async {
//                               if (cat.id != null) {
//                                 try {
//                                   await context
//                                       .read<CategoryNotifier>()
//                                       .deleteCategory(cat.id!);
//                                   if (context.mounted) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('"${cat.name}" deleted'),
//                                         backgroundColor: AppColor.emeraldGreen,
//                                       ),
//                                     );
//                                   }
//                                 } catch (e) {
//                                   if (context.mounted) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text('Error: ${e.toString()}'),
//                                         backgroundColor: AppColor.lightRed,
//                                       ),
//                                     );
//                                   }
//                                 }
//                               }
//                             },
//                           );
//                         }),
//
//                       // Divider
//                       Container(height: 1, color: AppColor.borderGray),
//
//                       // Insights Section
//                       CategoryInsights(
//                         totalCategories: categories.length,
//                         totalBudget: totalBudget,
//                         totalSpent: totalSpent,
//                       ),
//
//                       // Bottom spacing for navigation bar
//                       const SizedBox(height: 80),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
