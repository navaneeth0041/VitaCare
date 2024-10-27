import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatefulWidget {
  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  List<DataModel> _list = List<DataModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
    // Sample data for blood pressure (in mmHg) and sugar levels (in mg/dL)
    _list = [
      DataModel(key: "Mon", bloodPressure: 120, sugarLevel: 90),
      DataModel(key: "Tue", bloodPressure: 122, sugarLevel: 95),
      DataModel(key: "Wed", bloodPressure: 118, sugarLevel: 92),
      DataModel(key: "Thu", bloodPressure: 125, sugarLevel: 98),
      DataModel(key: "Fri", bloodPressure: 119, sugarLevel: 93),
      DataModel(key: "Sat", bloodPressure: 121, sugarLevel: 94),
      DataModel(key: "Sun", bloodPressure: 120, sugarLevel: 90),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          maxY: 140,
          backgroundColor: Colors.white,
          barGroups: _chartGroups(),
          borderData: FlBorderData(
            border: const Border(bottom: BorderSide(), left: BorderSide()),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300],
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String day = _list[group.x.toInt()].key;
                double value = rod.toY;
                return BarTooltipItem(
                  '$day\n$value',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    List<BarChartGroupData> list = [];
    for (int i = 0; i < _list.length; i++) {
      list.add(
        BarChartGroupData(
          x: i,
          barRods: [
            // Blood Pressure Bar
            BarChartRodData(
              toY: _list[i].bloodPressure,
              color: Colors.deepOrange,
              width: 10,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFFF78154), Color(0xFFF45B69)],
              ),
            ),
            // Sugar Level Bar
            BarChartRodData(
              toY: _list[i].sugarLevel,
              color: Colors.lightBlue,
              width: 10,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)],
              ),
            ),
          ],
          barsSpace: 8, // Spacing between bars
        ),
      );
    }
    return list;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final day = _list[value.toInt()].key;
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              day,
              style: TextStyle(fontSize: 10, color: Colors.black87),
            ),
          );
        },
      );
}

class DataModel {
  final String key; // Day of the week
  final double bloodPressure; // Blood pressure value
  final double sugarLevel; // Sugar level value

  DataModel({required this.key, required this.bloodPressure, required this.sugarLevel});
}
