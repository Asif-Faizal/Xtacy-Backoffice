import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtacy_backoffice/core/utils/currency_formatter.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_bloc.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_event.dart';
import 'package:xtacy_backoffice/presentation/blocs/dashboard/dashboard_state.dart';
import 'package:xtacy_backoffice/presentation/widgets/chart_widgets.dart';
import 'package:xtacy_backoffice/presentation/widgets/empty_state_widget.dart';
import 'package:xtacy_backoffice/presentation/widgets/shimmer_loading.dart';
import 'package:xtacy_backoffice/presentation/widgets/stat_card.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const DashboardLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.status == DashboardStatus.loading) {
            return const ShimmerLoading(isGrid: false, itemCount: 4);
          }

          if (state.status == DashboardStatus.failure) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Failed to load dashboard',
              subtitle: state.errorMessage,
              action: ElevatedButton(
                onPressed: () =>
                    context.read<DashboardBloc>().add(const DashboardLoadRequested()),
                child: const Text('Retry'),
              ),
            );
          }

          final stats = state.stats;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const DashboardRefreshRequested());
              await Future<void>.delayed(const Duration(milliseconds: 500));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;
                final crossAxisCount = isWide ? 4 : 2;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.8 : 1.4,
                      children: [
                        StatCard(
                          title: 'Total Investment',
                          value: CurrencyFormatter.format(stats.totalInvestment),
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        StatCard(
                          title: 'Inventory Value',
                          value: CurrencyFormatter.format(stats.inventoryValue),
                          icon: Icons.inventory_outlined,
                          color: AppTheme.carbonBlueDark,
                        ),
                        StatCard(
                          title: 'Total Sales',
                          value: CurrencyFormatter.format(stats.totalSales),
                          icon: Icons.point_of_sale_outlined,
                          color: AppTheme.successGreen,
                        ),
                        StatCard(
                          title: 'Total Profit',
                          value: CurrencyFormatter.format(stats.totalProfit),
                          icon: Icons.trending_up,
                          color: AppTheme.successGreen,
                        ),
                        StatCard(
                          title: 'Purchased',
                          value: '${stats.productsPurchased}',
                          icon: Icons.shopping_bag_outlined,
                        ),
                        StatCard(
                          title: 'Sold',
                          value: '${stats.productsSold}',
                          icon: Icons.check_circle_outline,
                        ),
                        StatCard(
                          title: 'Remaining',
                          value: '${stats.productsRemaining}',
                          icon: Icons.warehouse_outlined,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Today's Summary",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 1.8 : 1.4,
                      children: [
                        StatCard(
                          title: 'Purchased Today',
                          value: '${stats.purchasedToday}',
                          icon: Icons.add_shopping_cart,
                        ),
                        StatCard(
                          title: 'Sold Today',
                          value: '${stats.soldToday}',
                          icon: Icons.sell_outlined,
                        ),
                        StatCard(
                          title: "Today's Revenue",
                          value: CurrencyFormatter.format(stats.todayRevenue),
                          icon: Icons.attach_money,
                        ),
                        StatCard(
                          title: "Today's Profit",
                          value: CurrencyFormatter.format(stats.todayProfit),
                          icon: Icons.trending_up,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    BarChartWidget(
                      title: 'Products by Category',
                      data: stats.productsByCategory,
                    ),
                    const SizedBox(height: 16),
                    PieChartWidget(
                      title: 'Sold vs Unsold',
                      soldCount: stats.soldCount,
                      unsoldCount: stats.unsoldCount,
                    ),
                    const SizedBox(height: 16),
                    MonthlyBarChartWidget(
                      title: 'Monthly Purchases',
                      data: stats.monthlyPurchases,
                      barColor: AppTheme.carbonBlue,
                    ),
                    const SizedBox(height: 16),
                    MonthlyBarChartWidget(
                      title: 'Monthly Sales',
                      data: stats.monthlySales,
                      barColor: AppTheme.successGreen,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Category Summary',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...stats.categorySummaries.map((summary) => Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  summary.category,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 8),
                                _SummaryRow(
                                  label: 'Purchased',
                                  value: '${summary.purchased}',
                                ),
                                _SummaryRow(
                                  label: 'Sold',
                                  value: '${summary.sold}',
                                ),
                                _SummaryRow(
                                  label: 'Remaining',
                                  value: '${summary.remaining}',
                                ),
                                _SummaryRow(
                                  label: 'Investment',
                                  value: CurrencyFormatter.format(summary.investment),
                                ),
                                _SummaryRow(
                                  label: 'Revenue',
                                  value: CurrencyFormatter.format(summary.revenue),
                                ),
                                _SummaryRow(
                                  label: 'Profit',
                                  value: CurrencyFormatter.format(summary.profit),
                                ),
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: AppTheme.carbonGray50)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
