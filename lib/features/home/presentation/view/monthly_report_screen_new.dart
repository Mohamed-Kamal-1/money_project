// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:money/core/colors/app_color.dart';
// import 'package:money/core/dimensions/Dimension_app.dart';
// import 'package:money/core/extensions/theme_extension.dart';
// import 'package:money/features/home/presentation/providers/home_providers.dart';
// import 'package:money/features/home/presentation/view/settings_screen.dart';
// import 'package:money/main.dart';
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
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedMonth = DateTime.now();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadAnalytics();
//     });
//   }
//
//   void _loadAnalytics() {
//     final analyticsNotifier = context.read<AnalyticsNotifier>();
//     analyticsNotifier.loadAnalytics(
//       kUserId,
//       _selectedMonth.month,
//       _selectedMonth.year,
//     );
//   }
//
//   String get _monthLabel {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
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
//         child: Consumer<AnalyticsNotifier>(
//           builder: (context, analytics, _) {
//             return CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header with settings
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Monthly Report',
//                                 style: context.fonts.headlineSmall?.copyWith(
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 '$_monthLabel Summary',
//                                 style: context.fonts.bodyMedium?.copyWith(
//                                   color: AppColor.gray,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           GestureDetector(
//                             onTap: () => SettingsScreen.show(context),
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: AppColor.bottomNavBarBackGround,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.settings,
//                                 color: AppColor.white,
//                                 size: 22,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Month selector
//                       _buildMonthSelector(context),
//                       const SizedBox(height: 24),
//
//                       // Loading indicator
//                       if (analytics.isLoading)
//                         const Padding(
//                           padding: EdgeInsets.symmetric(vertical: 40),
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               color: AppColor.blueStart,
//                             ),
//                           ),
//                         )
//                       else ...[
//                         // Total Expenses
//                         _buildTotalExpenses(context, analytics),
//                         const SizedBox(height: 20),
//
//                         // Comparison row
//                         _buildComparisonRow(context, analytics),
//                         const SizedBox(height: 24),
//
//                         // Top Spending Category
//                         _buildTopCategory(context, analytics),
//                         const SizedBox(height: 24),
//
//                         // Spending Behavior
//                         _buildSpendingBehavior(context, analytics),
//                         const SizedBox(height: 24),
//
//                         // Category Breakdown
//                         _buildCategoryBreakdown(context, analytics),
//                         const SizedBox(height: 24),
//
//                         // Daily Statistics
//                         _buildDailyStatistics(context, analytics),
//                         const SizedBox(height: 24),
//
//                         // Previous Reports
//                         _buildPreviousReports(context),
//                         const SizedBox(height: 100),
//                       ],
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
//   Widget _buildTotalExpenses(
//     BuildContext context,
//     AnalyticsNotifier analytics,
//   ) {
//     return Center(
//       child: Column(
//         children: [
//           Text(
//             '\$${analytics.monthTotal.toStringAsFixed(2)}',
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
//   Widget _buildComparisonRow(
//     BuildContext context,
//     AnalyticsNotifier analytics,
//   ) {
//     final percentageChange = analytics.percentageChange;
//     final isIncrease = percentageChange > 0;
//     final trendIcon = isIncrease ? Icons.trending_up : Icons.trending_down;
//     final trendColor = isIncrease ? AppColor.lightRed : AppColor.emeraldGreen;
//
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
//                     Icon(trendIcon, size: 14, color: trendColor),
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
//                   '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
//                   style: context.fonts.headlineSmall?.copyWith(
//                     color: trendColor,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   isIncrease ? 'Spending increased' : 'Spending decreased',
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
//                   '\$${analytics.dailyAverage.toStringAsFixed(2)}',
//                   style: context.fonts.headlineSmall?.copyWith(
//                     color: AppColor.blueStart,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 20,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   'Per day',
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
//   Widget _buildTopCategory(BuildContext context, AnalyticsNotifier analytics) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppColor.primaryColor, AppColor.bottomNavBarBackGround],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(Dimension.circular16),
//         border: Border.all(color: AppColor.borderGray),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Most Spent On',
//             style: context.fonts.bodySmall?.copyWith(
//               color: AppColor.gray,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             analytics.topCategory.isEmpty ? 'No data' : analytics.topCategory,
//             style: context.fonts.headlineSmall?.copyWith(
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Top category for ${_monthLabel.split(' ')[0]}',
//             style: context.fonts.bodyMedium?.copyWith(
//               color: AppColor.gray,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSpendingBehavior(
//     BuildContext context,
//     AnalyticsNotifier analytics,
//   ) {
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
//             'Spending Insight',
//             style: context.fonts.bodySmall?.copyWith(
//               color: AppColor.gray,
//               fontWeight: FontWeight.w600,
//               fontSize: 10,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               const Icon(
//                 Icons.lightbulb,
//                 color: AppColor.yellowAccent,
//                 size: 18,
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   analytics.spendingBehavior.isEmpty
//                       ? 'Add transactions to see insights'
//                       : analytics.spendingBehavior,
//                   style: context.fonts.bodyMedium?.copyWith(
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryBreakdown(
//     BuildContext context,
//     AnalyticsNotifier analytics,
//   ) {
//     if (analytics.categorySpending.isEmpty) {
//       return Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColor.bottomNavBarBackGround,
//           borderRadius: BorderRadius.circular(Dimension.circular16),
//         ),
//         child: Center(
//           child: Text(
//             'No spending data available',
//             style: context.fonts.bodyMedium?.copyWith(color: AppColor.gray),
//           ),
//         ),
//       );
//     }
//
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
//             'Category Breakdown',
//             style: context.fonts.bodySmall?.copyWith(
//               color: AppColor.gray,
//               fontWeight: FontWeight.w600,
//               fontSize: 10,
//               letterSpacing: 0.5,
//             ),
//           ),
//           const SizedBox(height: 12),
//           ...analytics.categorySpending.entries.map((entry) {
//             final percentage = analytics.monthTotal == 0
//                 ? 0.0
//                 : (entry.value / analytics.monthTotal) * 100;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(entry.key, style: context.fonts.bodyMedium),
//                       Text(
//                         '\$${entry.value.toStringAsFixed(2)}',
//                         style: context.fonts.bodyMedium?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(4),
//                     child: LinearProgressIndicator(
//                       value: percentage / 100,
//                       minHeight: 6,
//                       backgroundColor: AppColor.borderGray,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         AppColor.blueStart.withValues(alpha: 0.7),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${percentage.toStringAsFixed(1)}%',
//                     style: context.fonts.bodySmall?.copyWith(
//                       color: AppColor.gray,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDailyStatistics(
//     BuildContext context,
//     AnalyticsNotifier analytics,
//   ) {
//     final daysInMonth = DateTime(
//       _selectedMonth.year,
//       _selectedMonth.month + 1,
//     ).difference(DateTime(_selectedMonth.year, _selectedMonth.month)).inDays;
//
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
//                       '$daysInMonth days',
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
//                       '${analytics.transactionCount}',
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
//
//   Widget _buildPreviousReports(BuildContext context) {
//     return Consumer<MonthlyReportNotifier>(
//       builder: (context, reportNotifier, _) {
//         final reports = reportNotifier.reports;
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
//                 'Previous Reports',
//                 style: context.fonts.bodySmall?.copyWith(
//                   color: AppColor.gray,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 10,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               if (reports.isEmpty)
//                 Text(
//                   'No previous reports yet',
//                   style: context.fonts.bodyMedium?.copyWith(
//                     color: AppColor.gray,
//                   ),
//                 )
//               else
//                 ...reports.take(5).map((report) {
//                   const months = [
//                     'Jan',
//                     'Feb',
//                     'Mar',
//                     'Apr',
//                     'May',
//                     'Jun',
//                     'Jul',
//                     'Aug',
//                     'Sep',
//                     'Oct',
//                     'Nov',
//                     'Dec',
//                   ];
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedMonth = DateTime(report.year, report.month);
//                           _loadAnalytics();
//                         });
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: AppColor.primaryColor,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(color: AppColor.borderGray),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${months[report.month - 1]} ${report.year}',
//                               style: context.fonts.bodyMedium?.copyWith(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Text(
//                               '\$${report.totalExpenses.toStringAsFixed(2)}',
//                               style: context.fonts.bodyMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 color: AppColor.lightRed,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
