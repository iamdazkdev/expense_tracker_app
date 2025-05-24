import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:daily_expense_tracker_app/features/statisticals/view/widgets/pie_chart_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator_widget.dart';

class DynamicPieChart extends StatefulWidget {
  final List<String> titles;
  final List<double> values;
  final List<Color> colors;

  const DynamicPieChart({
    super.key,
    required this.titles,
    required this.values,
    required this.colors,
  }) : assert(
          titles.length == values.length && values.length == colors.length,
          'All input lists must have the same length',
        );

  @override
  State<DynamicPieChart> createState() => _DynamicPieChartState();
}

class _DynamicPieChartState extends State<DynamicPieChart> {
  int touchedIndex = -1;

  double get _total => widget.values.fold(0, (sum, item) => sum + item);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(height: 18),
          Expanded(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse?.touchedSection == null) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse!
                                  .touchedSection!.touchedSectionIndex;
                            }
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: _buildSections(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Tổng',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        /* _formatCurrency(_total)*/ _total
                            .toCurrencyWithSymbol(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                widget.titles.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Indicator(
                    color: widget.colors[index],
                    text: widget.titles[index],
                    isSquare: true,
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 28),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return List.generate(widget.values.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 22.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final percentage = _total == 0 ? 0 : (widget.values[i] / _total * 100);

      return PieChartSectionData(
        color: widget.colors[i],
        value: widget.values[i],
        title: '${percentage.toStringAsFixed(2)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: PieCharColors.mainTextColor1,
          shadows: shadows,
        ),
      );
    });
  }
}
