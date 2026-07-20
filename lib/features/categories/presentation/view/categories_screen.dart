import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/colors/app_color.dart';
import '../../../../core/dimensions/dimension_app.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/widgets_for_all_app/gradient_button.dart';
import '../../../analytics/presentation/cubit/analytics_cubit.dart';
import '../../../analytics/presentation/cubit/analytics_state.dart';
import '../../../categories/presentation/view/widgets/add_category_dialog.dart';
import '../../../categories/presentation/view/widgets/category_insights.dart';
import '../../../categories/presentation/view/widgets/category_list_item.dart';
import '../cubit/category_cubit.dart';
import '../cubit/category_state.dart';

class CategoriesScreen extends StatefulWidget {
  final String userId;

  const CategoriesScreen({super.key, required this.userId});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().listenToCategories(widget.userId);
    final now = DateTime.now();
    context.read<AnalyticsCubit>().watchAnalytics(
      widget.userId,
      now.month,
      now.year,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimension.padding16,
        vertical: Dimension.padding16,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories', style: context.fonts.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Manage your expense categories',
              style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
            ),
            const SizedBox(height: 16),
            GradientButton(
              text: 'Add Custom Category',
              icon: Icons.add,
              onTap: () {
                AddCategoryDialog.show(context, userId: widget.userId);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  // Categories list
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategoryLoading) {
                        return const SliverFillRemaining(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.blueStart,
                            ),
                          ),
                        );
                      }
                      if (categoryState is CategoryError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Error: ${categoryState.message}',
                              style: const TextStyle(color: AppColor.lightRed),
                            ),
                          ),
                        );
                      }
                      if (categoryState is CategoryLoaded) {
                        final categories = categoryState.categories;
                        if (categories.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'No categories yet. Add your first one!',
                              ),
                            ),
                          );
                        }
                        return BlocBuilder<AnalyticsCubit, AnalyticsState>(
                          builder: (context, analyticsState) {
                            Map<String, double> spending = {};
                            if (analyticsState is AnalyticsLoaded) {
                              spending = analyticsState.categorySpending;
                            }
                            return SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final cat = categories[index];
                                final spent = spending[cat.name] ?? 0.0;

                                // ✅ التعامل مع الأيقونة كـ Emoji نصي، ووضع إيموجي افتراضي 💰 لو القيمة فارغة
                                final String emojiIcon = cat.icon ?? '💰';

                                return CategoryListItem(
                                  // نمرر الـ Text كـ widget يحتوي على الإيموجي بالحجم المناسب
                                  iconWidget: Text(
                                    emojiIcon,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  iconBackgroundColor: Color(
                                    int.tryParse(cat.color ?? '0xFF9E9E9E') ??
                                        0xFF9E9E9E,
                                  ),
                                  categoryName: cat.name ?? 'unKnown',
                                  spent: spent,
                                  budget: cat.budget ?? 0,
                                  onDelete: () async {
                                    if (cat.id != null) {
                                      await context
                                          .read<CategoryCubit>()
                                          .deleteCategory(cat.id!);
                                    }
                                  },
                                );
                              }, childCount: categories.length),
                            );
                          },
                        );
                      }
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                  // Insights Section
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, categoryState) {
                      if (categoryState is CategoryLoaded) {
                        final categories = categoryState.categories;
                        if (categories.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: SizedBox.shrink(),
                          );
                        }
                        double totalBudget = 0;
                        for (final cat in categories) {
                          totalBudget += cat.budget ?? 0;
                        }
                        return BlocBuilder<AnalyticsCubit, AnalyticsState>(
                          builder: (context, analyticsState) {
                            double totalSpent = 0;
                            if (analyticsState is AnalyticsLoaded) {
                              final spending = analyticsState.categorySpending;
                              for (final cat in categories) {
                                totalSpent += spending[cat.name] ?? 0;
                              }
                            }
                            return SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Container(
                                    height: 1,
                                    color: AppColor.borderGray,
                                  ),
                                  const SizedBox(height: 24),
                                  CategoryInsights(
                                    totalCategories: categories.length,
                                    totalBudget: totalBudget,
                                    totalSpent: totalSpent,
                                  ),
                                  const SizedBox(height: 80),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
