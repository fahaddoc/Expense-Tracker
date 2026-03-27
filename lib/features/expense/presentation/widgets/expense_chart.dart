import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/expense.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryTotals;

  const ExpensePieChart({
    super.key,
    required this.categoryTotals,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return const Center(
        child: Text('No expenses to show'),
      );
    }

    final total = categoryTotals.values.fold<double>(0, (sum, value) => sum + value);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: categoryTotals.entries.map((entry) {
                final percentage = (entry.value / total) * 100;
                return PieChartSectionData(
                  color: entry.key.color,
                  value: entry.value,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Legend
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: categoryTotals.entries.map((entry) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: entry.key.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${entry.key.displayName}: ${CurrencyFormatter.format(entry.value)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseBarChart({
    super.key,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text('No expenses to show'),
      );
    }

    // Group expenses by day of week
    final Map<int, double> dailyTotals = {};
    for (var expense in expenses) {
      final dayOfWeek = expense.date.weekday;
      dailyTotals[dayOfWeek] = (dailyTotals[dayOfWeek] ?? 0) + expense.amount;
    }

    final maxY = dailyTotals.values.isEmpty
        ? 1000.0
        : dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.2;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxY,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  CurrencyFormatter.format(rod.toY),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(7, (index) {
            final dayOfWeek = index + 1;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: dailyTotals[dayOfWeek] ?? 0,
                  color: Theme.of(context).colorScheme.primary,
                  width: 20,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
