import 'package:daily_expense_tracker_app/features/statisticals/data/stat_comparison_data_model.dart';

import '../../../core/enum/transaction.dart';
import '../../../core/models/transactions/transaction_model.dart';

StatComparisonData generateComparisonData(
  List<Transaction> allTransactions,
  DateTime now,
  String rangeType,
) {
  DateTime thisStart;
  DateTime lastStart;
  Duration duration;

  switch (rangeType) {
    case 'week':
      thisStart = DateTime(now.year, now.month, now.day - now.weekday + 1);
      lastStart = thisStart.subtract(const Duration(days: 7));
      duration = const Duration(days: 7);
      break;
    case 'month':
      thisStart = DateTime(now.year, now.month, 1);
      lastStart = DateTime(now.year, now.month - 1, 1);
      duration = DateTime(now.year, now.month, 0).difference(thisStart);
      break;
    case 'year':
      thisStart = DateTime(now.year, 1, 1);
      lastStart = DateTime(now.year - 1, 1, 1);
      duration = Duration(days: 365);
      break;
    default:
      throw Exception('Unsupported rangeType: $rangeType');
  }

  final thisEnd = thisStart.add(duration);
  final lastEnd = lastStart.add(duration);

  final thisPeriod = allTransactions.where(
    (t) => t.date.isAfter(thisStart) && t.date.isBefore(thisEnd),
  );
  final lastPeriod = allTransactions.where(
    (t) => t.date.isAfter(lastStart) && t.date.isBefore(lastEnd),
  );

  double incomeThis = 0;
  double expenseThis = 0;
  double incomeLast = 0;
  double expenseLast = 0;

  final Map<String, double> categoryThis = {};
  final Map<String, double> categoryLast = {};

  double totalThis = 0;
  double totalLast = 0;

  for (final t in thisPeriod) {
    if (t.category == TransactionType.income) {
      incomeThis += t.amount;
    } else {
      expenseThis += t.amount;
      categoryThis[t.category.name] =
          (categoryThis[t.category.name] ?? 0) + t.amount;
    }
    totalThis += t.amount;
  }

  for (final t in lastPeriod) {
    if (t.category == TransactionType.income) {
      incomeLast += t.amount;
    } else {
      expenseLast += t.amount;
      categoryLast[t.category.name] =
          (categoryLast[t.category.name] ?? 0) + t.amount;
    }
    totalLast += t.amount;
  }

  final avgThis = thisPeriod.isNotEmpty ? totalThis / thisPeriod.length : 0;
  final avgLast = lastPeriod.isNotEmpty ? totalLast / lastPeriod.length : 0;

  final Map<String, double> result = {};
  for (final t in allTransactions) {
    result[t.categoryName] = (result[t.categoryName] ?? 0) + t.amount;
  }
  return StatComparisonData(
    totalIncomeLast: incomeLast,
    totalExpenseLast: expenseLast,
    totalIncomeThis: incomeThis,
    totalExpenseThis: expenseThis,
    avgTransactionLast: double.tryParse(avgLast.toString()) ?? 0.0,
    avgTransactionThis: double.tryParse(avgThis.toString()) ?? 0.0,
    categoryBreakdownLast: categoryLast,
    categoryBreakdownThis: categoryThis,
    result: result,
  );
}
