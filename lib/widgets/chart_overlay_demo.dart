import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BusStatusGraph extends StatelessWidget {
  final List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
  ];

  final List<int> busStatuses = [
    20, 15, 25, 10,
  ];

  final List<String> busStatusLabels = [
    "Working",
    "Offline",
    "Maintenance"
  ];

  final List<Color> statusColors = [
    Colors.green, // Working
    Colors.red,   // Offline
    Colors.orange // Maintenance
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _buildBarGroups(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend for the statuses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(busStatusLabels.length, (index) {
                return Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: statusColors[index],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      busStatusLabels[index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(busStatuses.length, (index) {
      // Assign color based on status
      Color barColor;
      if (busStatuses[index] > 20) {
        barColor = Colors.green; // Working
      } else if (busStatuses[index] > 15) {
        barColor = Colors.orange; // Maintenance
      } else {
        barColor = Colors.red; // Offline
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: busStatuses[index].toDouble(),
            color: barColor,
            width: 16,
          ),
        ],
      );
    });
  }
}
