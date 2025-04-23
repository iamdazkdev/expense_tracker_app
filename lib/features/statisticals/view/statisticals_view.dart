import 'package:daily_expense_tracker_app/core/extension/extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/stat_comparison_data_model.dart';

class StatisticalView extends StatefulWidget {
  final StatComparisonData weeklyData;
  final StatComparisonData monthlyData;
  final StatComparisonData yearlyData;

  const StatisticalView({
    super.key,
    required this.weeklyData,
    required this.monthlyData,
    required this.yearlyData,
  });

  @override
  State<StatisticalView> createState() => _StatisticalViewState();
}

class _StatisticalViewState extends State<StatisticalView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Tuần', 'Tháng', 'Năm'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('So sánh chi tiêu'),
        bottom: TabBar(
          controller: _tabController,
          tabs: titles.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(widget.weeklyData, 'tuần'),
          _buildTabContent(widget.monthlyData, 'tháng'),
          _buildTabContent(widget.yearlyData, 'năm'),
        ],
      ),
    );
  }

  Widget _buildTabContent(StatComparisonData data, String label) {
    final percentChange = data.totalExpenseLast > 0
        ? (data.totalExpenseThis - data.totalExpenseLast) /
            data.totalExpenseLast *
            100
        : 100.0;
    final formattedPercent = percentChange.toStringAsFixed(1);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('1. Tổng thu nhập & Tổng chi tiêu'),
          SizedBox(height: 200, child: _buildIncomeExpenseBar(data)),
          const SizedBox(height: 24),
          _sectionTitle('2. Giá trị trung bình mỗi giao dịch'),
          SizedBox(height: 200, child: _buildAvgTransactionBar(data)),
          const SizedBox(height: 24),
          _sectionTitle('3. Phân bổ chi tiêu theo danh mục'),
          SizedBox(height: 200, child: _buildPieChart(data)),
          const SizedBox(height: 24),
          _sectionTitle('4. Biến động % so với $label trước'),
          Row(
            children: [
              Icon(
                percentChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                color: percentChange >= 0 ? Colors.red : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                'Chi tiêu ${percentChange >= 0 ? 'tăng' : 'giảm'} $formattedPercent% so với $label trước',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
  Widget _buildIncomeExpenseBar(StatComparisonData data) {
    final spots = <BarChartGroupData>[
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: data.totalIncomeLast, color: Colors.blue),
        BarChartRodData(toY: data.totalIncomeThis, color: Colors.blue.shade200),
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: data.totalExpenseLast, color: Colors.red),
        BarChartRodData(toY: data.totalExpenseThis, color: Colors.red.shade200),
      ]),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          groupsSpace: 40,
          barGroups: spots,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value ~/ 1000000}M', // Format theo đơn vị triệu
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('Thu nhập');
                  if (value == 1) return const Text('Chi tiêu');
                  return const Text('');
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              //tooltipBgColor: Colors.blueAccent,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                double value = rod.toY;
                String label = groupIndex == 0 ? 'Thu nhập' : 'Chi tiêu';
                return BarTooltipItem(
                  '$label: ${value.toCurrencyString()}',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvgTransactionBar(StatComparisonData data) {
    final spots = <BarChartGroupData>[
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: data.avgTransactionLast, color: Colors.green),
        BarChartRodData(
          toY: data.avgTransactionThis,
          color: Colors.green.shade200,
        ),
      ]),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 40,
          barGroups: spots,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value ~/ 1000000}M',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('Giá trị TB');
                  return const Text('');
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              //tooltipBgColor: Colors.greenAccent,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                double value = rod.toY;
                return BarTooltipItem(
                  'Giá trị TB: ${value.toCurrencyString()}',
                  TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

/*  Widget _buildIncomeExpenseBar(StatComparisonData data) {
    final spots = <BarChartGroupData>[
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: data.totalIncomeLast, color: Colors.blue),
        BarChartRodData(toY: data.totalIncomeThis, color: Colors.blue.shade200),
      ]),
      BarChartGroupData(x: 1, barRods: [
        BarChartRodData(toY: data.totalExpenseLast, color: Colors.red),
        BarChartRodData(toY: data.totalExpenseThis, color: Colors.red.shade200),
      ]),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          groupsSpace: 40,
          barGroups: spots,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value ~/ 1000000}M', // tuỳ theo đơn vị bạn đang dùng
                    style: const TextStyle(
                      fontSize: 10, // 👈 giảm size tại đây
                      color: Colors.grey, // hoặc màu bạn muốn
                    ),
                    textAlign: TextAlign.left,
                  );
                },
                reservedSize: 30, // 👈 giảm kích thước chiếm không gian nếu cần
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('Thu nhập');
                  if (value == 1) return const Text('Chi tiêu');
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvgTransactionBar(StatComparisonData data) {
    final spots = <BarChartGroupData>[
      BarChartGroupData(x: 0, barRods: [
        BarChartRodData(toY: data.avgTransactionLast, color: Colors.green),
        BarChartRodData(
          toY: data.avgTransactionThis,
          color: Colors.green.shade200,
        ),
      ]),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          groupsSpace: 40,
          barGroups: spots,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 40,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value ~/ 1000000}M',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.left,
                  );
                },
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('Giá trị TB');
                  return const Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  Widget _buildPieChart(StatComparisonData data) {
    final sections = <PieChartSectionData>[];
    data.categoryBreakdownThis.forEach((key, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          title: NumberFormat.compactCurrency(symbol: '').format(value),
          radius: 50,
        ),
      );
    });

    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 30,
      ),
    );
  }
}
