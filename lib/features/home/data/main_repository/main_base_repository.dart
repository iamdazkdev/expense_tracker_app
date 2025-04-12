import '../../../../core/models/transactions/totals_transaction_model.dart';
import '../../../../core/models/transactions/transaction_model.dart';
import '../../../../core/utils/models/app_result.dart';

abstract class MainBaseRepository {
  Future<AppResult<List<Transaction>>> getAll({required int? limit});
  Future<AppResult<TotalsTransaction>> getTotals();
}
