import 'dart:async';

import 'package:auth_user/auth_user.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/enum/categorys.dart';
import '../../../../core/models/categories/category_model.dart';
import '../../../../core/models/transactions/totals_transaction_model.dart';
import '../../../../core/models/transactions/transaction_hive_model.dart';
import '../../../../core/models/transactions/transaction_model.dart';
import '../../../../core/utils/models/app_result.dart';
import '../../../categories/data/category_repository.dart';
import 'main_base_repository.dart';

class MainRepository implements MainBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final DbHiveClientBase _dbHiveClient;
  final AuthUserBase _authUser;

  MainRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required DbHiveClientBase dbHiveClient,
    required AuthUserBase authUser,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _dbHiveClient = dbHiveClient,
        _authUser = authUser;

  String get _currentUser => _authUser.currentUser!.uid;
  bool get _isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<List<Transaction>>> getAll({
    required int? limit,
  }) async {
    if (!_isUserLoggedIn) {
      final hiveTransactions = await _getHiveTransactions();
      final transactions = hiveTransactions
          .map(Transaction.fromHiveModel)
          .take(limit ?? hiveTransactions.length)
          .toList();
      return AppResult.success(transactions);
    }

    final transactions = await _getDataAndClearHive();
    final result = await _updateFirestoreAndGetData(transactions, limit);

    final success = await addAllCategories();
    debugPrint(success
        ? 'Categories added successfully!'
        : 'Failed to add categories.');

    return AppResult.success(result);
  }

  @override
  Future<AppResult<TotalsTransaction>> getTotals() async {
    if (!_isUserLoggedIn) {
      final transactions = await _getHiveTransactions();
      final totalsTransaction = TotalsTransaction.calculate(
        transactions.map(Transaction.fromHiveModel).toList(),
      );
      return AppResult.success(totalsTransaction);
    }

    final transactions = await _getDataAndClearHive();
    final result = await _updateFirestoreAndGetData(transactions, null);

    final totalsTransaction = TotalsTransaction.calculate(result);
    return AppResult.success(totalsTransaction);
  }

  Future<List<TransactionHive>> _getHiveTransactions() async {
    final transactions = await _dbHiveClient.getAll<TransactionHive>(
      boxName: 'transactions',
    );
    transactions.sort((a, b) => b.amount.compareTo(a.amount));
    return transactions;
  }

  Future<List<TransactionHive>> _getDataAndClearHive() async {
    final transactions = await _getHiveTransactions();
    await _dbHiveClient.clearAll<TransactionHive>(boxName: 'transactions');
    return transactions;
  }

  Future<List<Transaction>> _updateFirestoreAndGetData(
    List<TransactionHive> transactions,
    int? limit,
  ) async {
    final updatedTransactions = transactions.map((hive) {
      return Transaction.fromHiveModel(hive).copyWith(userId: _currentUser);
    }).toList();

    await Future.wait(
      updatedTransactions.map(
        (transaction) => _dbFirestoreClient.setDocument(
          collectionPath: 'transactions',
          documentId: transaction.uuid!,
          merge: false,
          data: transaction.toJson(),
        ),
      ),
    );

    final result = await _dbFirestoreClient.getQueryOrderBy<Transaction>(
      collectionPath: 'transactions',
      field: 'userId',
      isEqualTo: _currentUser,
      descending: true,
      orderByField: 'amount',
      limit: limit,
      mapper: (data, documentId) => Transaction.fromJson(data!),
    );
    return result;
  }

/*
  Future<bool> addAllCategories() async {
    final existingCategories = await _dbFirestoreClient.getQuery<CategoryModel>(
      collectionPath: 'categories',
      mapper: (data, documentId) => CategoryModel.fromJson(data!),
    );

    final existingCategoryNames =
        existingCategories.map((category) => category.name).toSet();

    final categoryRepository = CategoryRepository(
      dbFirestoreClient: _dbFirestoreClient,
      authUser: _authUser,
      dbHiveClient: _dbHiveClient,
    );

    final categoriesToAdd = Categorys.values.where(
      (category) => !existingCategoryNames.contains(category.name),
    );

    final futures = categoriesToAdd.map((category) {
      return categoryRepository.addAllCategories(
        CategoryModel.empty(),
        category,
      );
    }).toList();

    final results = await Future.wait(futures);

    for (var i = 0; i < results.length; i++) {
      final category = categoriesToAdd.elementAt(i);
      results[i].when(
        success: (_) =>
            debugPrint('Successfully added category: ${category.name}'),
        failure: (error) => debugPrint(
            'Failed to add category: ${category.name}, Error: $error'),
      );
    }

    return true;
  }
*/
  Future<bool> addAllCategories() async {
    final existingCategories = await _dbFirestoreClient.getQuery<CategoryModel>(
      collectionPath: 'categories',
      mapper: (data, documentId) => CategoryModel.fromJson(data!),
    );

    // Nếu đã có categories thì không thêm nữa
    if (existingCategories.isNotEmpty) {
      debugPrint('Categories đã tồn tại, không cần thêm.');
      return true;
    }

    final categoryRepository = CategoryRepository(
      dbFirestoreClient: _dbFirestoreClient,
      authUser: _authUser,
      dbHiveClient: _dbHiveClient,
    );

    final futures = Categorys.values.map((category) {
      return categoryRepository.addAllCategories(
        CategoryModel.empty(),
        category,
      );
    }).toList();

    final results = await Future.wait(futures);

    for (var i = 0; i < results.length; i++) {
      results[i].when(
        success: (_) => debugPrint(
            'Successfully added category: ${Categorys.values[i].name}'),
        failure: (error) => debugPrint(
            'Failed to add category: ${Categorys.values[i].name}, Error: $error'),
      );
    }

    return true;
  }
}
