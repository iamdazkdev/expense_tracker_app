import '../../../core/models/transactions/transaction_model.dart';

class StatisticalUtils {
  static Map<String, double> generateCategorySummaryByName(
      List<Transaction> allTransactions) {
    final Map<String, double> result = {};

    for (final t in allTransactions) {
      result[t.categoryName] = (result[t.categoryName] ?? 0) + t.amount;
    }

    return result;
  }
}
