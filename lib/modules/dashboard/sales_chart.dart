import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/modules/dashboard/sales_model.dart';

enum SalesChartGroupBy { perTanggal, perProduk }

class SalesChart extends StatelessWidget {
  final List<SalesDataModel> data;
  final SalesChartGroupBy groupBy;

  const SalesChart({super.key, required this.data, this.groupBy = SalesChartGroupBy.perTanggal});

  @override
  Widget build(BuildContext context) {
    if (groupBy == SalesChartGroupBy.perTanggal) {
      return SizedBox(child: _buildLineChart());
    } else {
      return SizedBox(child: _buildBarChart());
    }
  }

  Widget _buildLineChart() {
    final grouped = <DateTime, double>{};
    for (var d in data) {
      final date = DateTime(d.date.year, d.date.month, d.date.day);
      grouped[date] = (grouped[date] ?? 0) + d.totalSales;
    }

    final sortedEntries = grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    final spots =
        sortedEntries.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value.value.toDouble());
        }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, _) {
                int index = value.toInt();
                if (index >= 0 && index < sortedEntries.length) {
                  final date = sortedEntries[index].key;
                  return Text("${date.month}/${date.day}", style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              getTitlesWidget: (value, _) => Text(value.toInt().toString()),
              reservedSize: 40,
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildBarChart() {
    final grouped = <String, double>{};
    for (var d in data) {
      final label = "${d.productName} (${d.productCode})";
      grouped[label] = (grouped[label] ?? 0) + d.totalSales;
    }

    final entries = grouped.entries.toList();
    final bars =
        entries.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value.toDouble(),
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                final index = value.toInt();
                if (index < entries.length) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: Text(entries[index].key, style: TextStyle(fontSize: 12)),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              reservedSize: 40,
              getTitlesWidget: (value, _) => Text(value.toInt().toString()),
            ),
          ),
        ),
        gridData: FlGridData(show: true),
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
