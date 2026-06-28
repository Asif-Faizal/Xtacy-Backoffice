import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:xtacy_backoffice/core/theme/app_theme.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({
    super.key,
    required this.data,
    required this.title,
  });

  final Map<String, int> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _ChartContainer(
        title: title,
        child: const Center(child: Text('No data available')),
      );
    }

    final entries = data.entries.toList();
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return _ChartContainer(
      title: title,
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY.toDouble() + 2,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    final label = entries[index].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        label.length > 8 ? '${label.substring(0, 6)}…' : label,
                        style: const TextStyle(fontSize: 9),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 32),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            barGroups: List.generate(entries.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: entries[i].value.toDouble(),
                    color: AppTheme.carbonBlue,
                    width: 16,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.soldCount,
    required this.unsoldCount,
    required this.title,
  });

  final int soldCount;
  final int unsoldCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    final total = soldCount + unsoldCount;
    if (total == 0) {
      return _ChartContainer(
        title: title,
        child: const Center(child: Text('No data available')),
      );
    }

    return _ChartContainer(
      title: title,
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: soldCount.toDouble(),
                      title: 'Sold\n$soldCount',
                      color: AppTheme.successGreen,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: unsoldCount.toDouble(),
                      title: 'Unsold\n$unsoldCount',
                      color: AppTheme.warningOrange,
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MonthlyBarChartWidget extends StatelessWidget {
  const MonthlyBarChartWidget({
    super.key,
    required this.data,
    required this.title,
    required this.barColor,
  });

  final Map<String, double> data;
  final String title;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _ChartContainer(
        title: title,
        child: const Center(child: Text('No data available')),
      );
    }

    final entries = data.entries.toList();
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return _ChartContainer(
      title: title,
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY + (maxY * 0.1),
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        entries[index].key,
                        style: const TextStyle(fontSize: 9),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 40),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            barGroups: List.generate(entries.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: entries[i].value,
                    color: barColor,
                    width: 16,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _ChartContainer extends StatelessWidget {
  const _ChartContainer({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
