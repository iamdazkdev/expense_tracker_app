class StatComparisonData {
  final double totalIncomeLast;
  final double totalExpenseLast;
  final double totalIncomeThis;
  final double totalExpenseThis;

  final double avgTransactionLast;
  final double avgTransactionThis;

  final Map<String, double> categoryBreakdownLast;
  final Map<String, double> categoryBreakdownThis;

  StatComparisonData({
    required this.totalIncomeLast,
    required this.totalExpenseLast,
    required this.totalIncomeThis,
    required this.totalExpenseThis,
    required this.avgTransactionLast,
    required this.avgTransactionThis,
    required this.categoryBreakdownLast,
    required this.categoryBreakdownThis,
  });
}
