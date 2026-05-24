// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:money/core/colors/app_color.dart';
// import 'package:money/core/dimensions/dimension_app.dart';
// import 'package:money/core/extensions/theme_extension.dart';
// import 'package:money/features/home/presentation/providers/home_providers.dart';
// import 'package:money/features/home/presentation/view/settings_screen.dart';
//
// import '../../../../core/widgets_for_all_app/custom_linear_indicator.dart';
// import '../../../../core/widgets_for_all_app/gradient_button.dart';
//
// class MonthlyReportScreen extends StatefulWidget {
//   const MonthlyReportScreen({super.key});
//
//   @override
//   State<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
// }
//
// class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
//   late DateTime _selectedMonth;
//   final String _userId = 'test_user_123'; // TODO: Get from auth
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedMonth = DateTime.now();
//     // Load analytics data when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadAnalytics();
//     });
//   }
//
//   void _loadAnalytics() {
//     final analyticsNotifier = context.read<AnalyticsNotifier>();
//     analyticsNotifier.loadAnalytics(_userId, _selectedMonth.month, _selectedMonth.year);
//   }
//
//   String get _monthLabel {
//     const months = [
//       'January', 'February', 'March', 'April', 'May', 'June',
//       'July', 'August', 'September', 'October', 'November', 'December',
//     ];
//     return '${months[_selectedMonth.month - 1]} ${_selectedMonth.year}';
//   }
//
//   void _previousMonth() {
//     setState(() {
//       _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
//       _loadAnalytics();
//     });
//   }
//
//   void _nextMonth() {
//     setState(() {
//       _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
//       _loadAnalytics();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: Dimension.padding16,
//         vertical: Dimension.padding16,
//       ),
//       child: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header with settings
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Monthly Report',
//                             style: context.fonts.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '$_monthLabel Summary',
//                             style: context.fonts.bodyMedium?.copyWith(
//                               color: AppColor.gray,
//                             ),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () => SettingsScreen.show(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: AppColor.bottomNavBarBackGround,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.settings,
//                             color: AppColor.white,
//                             size: 22,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Month selector
//                   _buildMonthSelector(context),
//                   const SizedBox(height: 24),
//
//                   // Total Expenses
//                   _buildTotalExpenses(context),
//                   const SizedBox(height: 20),
//
//                   // Comparison row
//                   _buildComparisonRow(context),
//                   const SizedBox(height: 24),
//
//                   // Top Spending Category
//                   _buildTopCategory(context),
//                   const SizedBox(height: 24),
//
//                   // Spending Behavior
//                   _buildSpendingBehavior(context),
//                   const SizedBox(height: 24),
//
//                   // Category Breakdown
//                   _buildCategoryBreakdown(context),
//                   const SizedBox(height: 24),
//
//                   // Daily Statistics
//                   _buildDailyStatistics(context),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMonthSelector(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//         decoration: BoxDecoration(
//           color: AppColor.bottomNavBarBackGround,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: _previousMonth,
//               child: const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Icon(Icons.chevron_left, color: AppColor.gray, size: 20),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: AppColor.navGradient,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     color: AppColor.white,
//                     size: 14,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _monthLabel,
//                     style: const TextStyle(
//                       color: AppColor.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: _nextMonth,
//               child: const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Icon(
//                   Icons.chevron_right,
//                   color: AppColor.gray,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalExpenses(BuildContext context) {
//     return Consumer<AnalyticsNotifier>(
//       builder: (context, analytics, _) {
//         return Center(
//           child: Column(
//             children: [
//               Text(
//                 '\$${analytics.monthTotal.toStringAsFixed(2)}',
//                 style: context.fonts.displayMedium?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 36,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'Total Expenses',
//                 style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildComparisonRow(BuildContext context) {
//     return Consumer<AnalyticsNotifier>(
//       builder: (context, analytics, _) {
//         final percentageChange = analytics.percentageChange;
//         final isIncrease = percentageChange > 0;
//         final trendIcon = isIncrease ? Icons.trending_up : Icons.trending_down;
//         final trendColor = isIncrease ? AppColor.lightRed : AppColor.emeraldGreen;
//
//         return Row(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColor.bottomNavBarBackGround,
//                   borderRadius: BorderRadius.circular(Dimension.circular16),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(
//                           trendIcon,
//                           size: 14,
//                           color: trendColor,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'VS LAST MONTH',
//                           style: context.fonts.bodySmall?.copyWith(
//                             color: AppColor.gray,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
//                       style: context.fonts.headlineSmall?.copyWith(
//                         color: trendColor,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       isIncrease ? 'Spending increased' : 'Spending decreased',
//                       style: context.fonts.bodyMedium?.copyWith(
//                         color: AppColor.gray,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: AppColor.bottomNavBarBackGround,
//                   borderRadius: BorderRadius.circular(Dimension.circular16),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.attach_money,
//                           size: 14,
//                           color: AppColor.blueStart,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'DAILY AVERAGE',
//                           style: context.fonts.bodySmall?.copyWith(
//                             color: AppColor.gray,
//                             fontSize: 9,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '\$${analytics.dailyAverage.toStringAsFixed(2)}',
//                       style: context.fonts.headlineSmall?.copyWith(
//                         color: AppColor.blueStart,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Per day',
//                       style: context.fonts.bodyMedium?.copyWith(
//                         color: AppColor.gray,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildTopCategory(BuildContext context) {
//     return Consumer<AnalyticsNotifier>(
//       builder: (context, analytics, _) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [AppColor.primaryColor, AppColor.bottomNavBarBackGround],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(Dimension.circular16),
//             border: Border.all(color: AppColor.borderGray),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Most Spent On',
//                 style: context.fonts.bodySmall?.copyWith(
//                   color: AppColor.gray,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 analytics.topCategory,
//                 style: context.fonts.headlineSmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Top category for ${_monthLabel.split(' ')[0]}',
//                 style: context.fonts.bodyMedium?.copyWith(
//                   color: AppColor.gray,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSpendingBehavior(BuildContext context) {
//     return Consumer<AnalyticsNotifier>(
//       builder: (context, analytics, _) {
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColor.bottomNavBarBackGround,
//             borderRadius: BorderRadius.circular(Dimension.circular16),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Spending Insight',
//                 style: context.fonts.bodySmall?.copyWith(
//                   color: AppColor.gray,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 10,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.lightbulb,
//                     color: AppColor.yellowAccent,
//                     size: 18,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       analytics.spendingBehavior,
//                       style: context.fonts.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildCategoryBreakdown(BuildContext context) {
//     return Consumer<AnalyticsNotifier>(
//       builder: (context, analytics, _) {
//         if (analytics.categorySpending.isEmpty) {
//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColor.bottomNavBarBackGround,
//               borderRadius: BorderRadius.circular(Dimension.circular16),
//             ),
//             child: Center(
//               child: Text(
//                 'No spending data available',
//                 style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
//               ),
//             ),
//           );
//         }
//
//         return Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppColor.bottomNavBarBackGround,
//             borderRadius: BorderRadius.circular(Dimension.circular16),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Category Breakdown',
//                 style: context.fonts.bodySmall?.copyWith(
//                   color: AppColor.gray,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 10,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               ...analytics.categorySpending.entries.map((entry) {
//                 final percentage = (entry.value / analytics.monthTotal) * 100;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             entry.key,
//                             style: context.fonts.bodyMedium,
//                           ),
//                           Text(
//                             '\$${entry.value.toStringAsFixed(2)}',
//                             style: context.fonts.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(4),
//                         child: LinearProgressIndicator(
//                           value: percentage / 100,
//                           minHeight: 6,
//                           backgroundColor: AppColor.borderGray,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             AppColor.blueStart.withValues(alpha: 0.7),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${percentage.toStringAsFixed(1)}%',
//                         style: context.fonts.bodySmall?.copyWith(
//                           color: AppColor.gray,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildDailyStatistics(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColor.bottomNavBarBackGround,
//         borderRadius: BorderRadius.circular(Dimension.circular16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Daily Statistics',
//             style: context.fonts.bodySmall?.copyWith(
//               color: AppColor.gray,
//               fontWeight: FontWeight.w600,
//               fontSize: 10,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Days in month',
//                       style: context.fonts.bodySmall?.copyWith(
//                         color: AppColor.gray,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${DateTime(_selectedMonth.year, _selectedMonth.month + 1).difference(DateTime(_selectedMonth.year, _selectedMonth.month)).inDays} days',
//                       style: context.fonts.headlineSmall?.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Total transactions',
//                       style: context.fonts.bodySmall?.copyWith(
//                         color: AppColor.gray,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '0', // Would need transaction count from analytics
//                       style: context.fonts.headlineSmall?.copyWith(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//          Widget SliverToBoxAdapter(
//           slivers: [
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header with settings
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Monthly Report',
//                             style: context.fonts.headlineSmall?.copyWith(
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '$_monthLabel Summary',
//                             style: context.fonts.bodyMedium?.copyWith(
//                               color: AppColor.gray,
//                             ),
//                           ),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () => SettingsScreen.show(context),
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: AppColor.bottomNavBarBackGround,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.settings,
//                             color: AppColor.white,
//                             size: 22,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//
//                   // Month selector
//                   _buildMonthSelector(context),
//                   const SizedBox(height: 24),
//
//                   // Total Expenses
//                   _buildTotalExpenses(context),
//                   const SizedBox(height: 20),
//
//                   // Comparison row
//                   _buildComparisonRow(context),
//                   const SizedBox(height: 24),
//
//                   // Top Spending Categories
//                   _buildTopCategories(context),
//                   const SizedBox(height: 24),
//
//                   // Spending Behavior
//                   _buildSpendingBehavior(context),
//                   const SizedBox(height: 24),
//
//                   // Achievements
//                   _buildAchievements(context),
//                   const SizedBox(height: 24),
//
//                   // Export buttons
//                   _buildExportButtons(context),
//                   const SizedBox(height: 24),
//
//                   // Previous Reports
//                   _buildPreviousReports(context),
//                   const SizedBox(height: 24),
//
//                   // Export Options
//                   _buildExportOptions(context),
//                   const SizedBox(height: 100),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMonthSelector(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//         decoration: BoxDecoration(
//           color: AppColor.bottomNavBarBackGround,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: _previousMonth,
//               child: const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Icon(Icons.chevron_left, color: AppColor.gray, size: 20),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: AppColor.navGradient,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.calendar_today,
//                     color: AppColor.white,
//                     size: 14,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _monthLabel,
//                     style: const TextStyle(
//                       color: AppColor.white,
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: _nextMonth,
//               child: const Padding(
//                 padding: EdgeInsets.all(8),
//                 child: Icon(
//                   Icons.chevron_right,
//                   color: AppColor.gray,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTotalExpenses(BuildContext context) {
//     return Center(
//       child: Column(
//         children: [
//           Text(
//             '\$2,847.50',
//             style: context.fonts.displayMedium?.copyWith(
//               fontWeight: FontWeight.w700,
//               fontSize: 36,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Total Expenses',
//             style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildComparisonRow(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColor.bottomNavBarBackGround,
//               borderRadius: BorderRadius.circular(Dimension.circular16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.trending_down,
//                       size: 14,
//                       color: AppColor.emeraldGreen,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'VS LAST MONTH',
//                       style: context.fonts.bodySmall?.copyWith(
//                         color: AppColor.gray,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '-8.9%',
//                   style: context.fonts.headlineSmall?.copyWith(
//                     color: AppColor.emeraldGreen,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '\$277.30 saved',
//                   style: context.fonts.bodyMedium?.copyWith(
//                     color: AppColor.gray,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppColor.bottomNavBarBackGround,
//               borderRadius: BorderRadius.circular(Dimension.circular16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.attach_money,
//                       size: 14,
//                       color: AppColor.blueStart,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'DAILY AVERAGE',
//                       style: context.fonts.bodySmall?.copyWith(
//                         color: AppColor.gray,
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '\$94.92',
//                   style: context.fonts.headlineSmall?.copyWith(
//                     color: AppColor.blueStart,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   '30 days tracked',
//                   style: context.fonts.bodyMedium?.copyWith(
//                     color: AppColor.gray,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTopCategories(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Top Spending Categories',
//           style: context.fonts.bodyMedium?.copyWith(
//             color: AppColor.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _CategoryRow(
//           name: 'Food & Dining',
//           amount: 842,
//           percentage: 29.6,
//           color: const Color(0xFFFF6B35),
//         ),
//         const SizedBox(height: 12),
//         _CategoryRow(
//           name: 'Shopping',
//           amount: 623,
//           percentage: 21.9,
//           color: const Color(0xFF8B5CF6),
//         ),
//         const SizedBox(height: 12),
//         _CategoryRow(
//           name: 'Transport',
//           amount: 456,
//           percentage: 16.0,
//           color: const Color(0xFF3B82F6),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSpendingBehavior(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColor.bottomNavBarBackGround,
//         borderRadius: BorderRadius.circular(Dimension.circular16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Spending Behavior',
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'You tend to spend more on weekends and during evening hours. Consider setting up spending limits for these times.',
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.gray,
//               fontSize: 13,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAchievements(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Achievements This Month',
//           style: context.fonts.bodyMedium?.copyWith(
//             color: AppColor.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             _AchievementBadge(
//               icon: Icons.check_circle,
//               iconColor: AppColor.emeraldGreen,
//               text: 'Budget Goal Met',
//             ),
//             const SizedBox(width: 12),
//             _AchievementBadge(
//               icon: Icons.trending_down,
//               iconColor: AppColor.purpleEnd,
//               text: '8.9% Decrease',
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildExportButtons(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: GradientButton(
//             text: 'Export PDF',
//             icon: Icons.picture_as_pdf,
//             onTap: () {
//               ScaffoldMessenger.of(
//                 context,
//               ).showSnackBar(const SnackBar(content: Text('Exporting PDF...')));
//             },
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: GestureDetector(
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('Share feature coming soon')),
//               );
//             },
//             child: Container(
//               height: 48,
//               decoration: BoxDecoration(
//                 color: AppColor.bottomNavBarBackGround,
//                 borderRadius: BorderRadius.circular(Dimension.circular12),
//                 border: Border.all(color: AppColor.borderGray),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.share, color: AppColor.white, size: 18),
//                   SizedBox(width: 8),
//                   Text(
//                     'Share',
//                     style: TextStyle(
//                       color: AppColor.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPreviousReports(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Previous Reports',
//           style: context.fonts.bodyMedium?.copyWith(
//             color: AppColor.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 12),
//         _PreviousReportItem(
//           month: 'December 2025',
//           total: 3060,
//           changePercent: 12.4,
//           isIncrease: true,
//         ),
//         const SizedBox(height: 8),
//         _PreviousReportItem(
//           month: 'November 2025',
//           total: 3124,
//           changePercent: 5.6,
//           isIncrease: false,
//         ),
//         const SizedBox(height: 8),
//         _PreviousReportItem(
//           month: 'October 2025',
//           total: 2950,
//           changePercent: 7.8,
//           isIncrease: true,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildExportOptions(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColor.bottomNavBarBackGround,
//         borderRadius: BorderRadius.circular(Dimension.circular16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Export Options',
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.white,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           _ExportOptionRow(icon: Icons.download, text: 'PDF Report (Detailed)'),
//           const Divider(color: AppColor.borderGray, height: 24),
//           _ExportOptionRow(icon: Icons.download, text: 'CSV Data Export'),
//           const Divider(color: AppColor.borderGray, height: 24),
//           _ExportOptionRow(icon: Icons.share, text: 'Email Monthly Summary'),
//         ],
//       ),
//     );
//   }
//
//
// class _CategoryRow extends StatelessWidget {
//   final String name;
//   final double amount;
//   final double percentage;
//   final Color color;
//
//   const _CategoryRow({
//     required this.name,
//     required this.amount,
//     required this.percentage,
//     required this.color,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               name,
//               style: context.fonts.bodyMedium?.copyWith(
//                 color: AppColor.white,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Row(
//               children: [
//                 Text(
//                   '\$${amount.toStringAsFixed(0)}',
//                   style: context.fonts.bodyMedium?.copyWith(
//                     color: AppColor.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   '${percentage.toStringAsFixed(1)}%',
//                   style: context.fonts.bodyMedium?.copyWith(
//                     color: AppColor.gray,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         CustomPaint(
//           size: const Size(double.infinity, 4),
//           painter: CustomLinearIndicator(
//             progress: percentage / 100,
//             backgroundColor: AppColor.spaceBlue,
//             gradientColors: [color, color.withValues(alpha: 0.6)],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _AchievementBadge extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String text;
//
//   const _AchievementBadge({
//     required this.icon,
//     required this.iconColor,
//     required this.text,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: AppColor.bottomNavBarBackGround,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: iconColor, size: 18),
//           const SizedBox(width: 8),
//           Text(
//             text,
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.white,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _PreviousReportItem extends StatelessWidget {
//   final String month;
//   final double total;
//   final double changePercent;
//   final bool isIncrease;
//
//   const _PreviousReportItem({
//     required this.month,
//     required this.total,
//     required this.changePercent,
//     required this.isIncrease,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColor.bottomNavBarBackGround,
//         borderRadius: BorderRadius.circular(Dimension.circular12),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 month,
//                 style: context.fonts.bodyMedium?.copyWith(
//                   color: AppColor.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 '\$${total.toStringAsFixed(0)} total',
//                 style: context.fonts.bodyMedium?.copyWith(
//                   color: AppColor.gray,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Icon(
//                 isIncrease ? Icons.trending_up : Icons.trending_down,
//                 color: isIncrease ? AppColor.lightRed : AppColor.emeraldGreen,
//                 size: 16,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 '${changePercent.toStringAsFixed(1)}%',
//                 style: TextStyle(
//                   color: isIncrease ? AppColor.lightRed : AppColor.emeraldGreen,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ExportOptionRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//
//   const _ExportOptionRow({required this.icon, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('$text - Coming soon')));
//       },
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             text,
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.white,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Icon(icon, color: AppColor.gray, size: 18),
//         ],
//       ),
//     );
//   }
// }
