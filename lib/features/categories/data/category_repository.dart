import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/enum/categorys.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:daily_expense_tracker_app/core/models/categories/category_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';
import 'package:daily_expense_tracker_app/features/categories/data/category_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';
import 'package:flutter/cupertino.dart';

class CategoryRepository implements CategoryBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final AuthUserBase _authUser;
  CategoryRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
    required DbHiveClientBase dbHiveClient,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _authUser = authUser;

  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<void>> addAllCategories(
      CategoryModel categoryModel, Categorys category) async {
    try {
      final generateUUID = Helper.generateUUID();
      if (isUserLoggedIn) {
        categoryModel = CategoryModel.fromCategorys(
          categorys: category,
          id: generateUUID,
        );
        await _dbFirestoreClient.setDocument(
          collectionPath: 'categories',
          merge: false,
          documentId: generateUUID,
          data: categoryModel.toJson(),
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> addCategory(CategoryModel category) async {
    // TODO: implement addCategory
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.setDocument(
          collectionPath: 'categories',
          merge: false,
          documentId: category.uuid,
          data: category.toJson(),
        );
      }
      debugPrint("Error: Unable to add Categories to FireStore");
      return const AppResult.success(null);
    } catch (err) {
      debugPrint("Error when add Categories to FireStore");
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateCategory(CategoryModel category) async {
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'categories/${category.uuid}',
          data: category.toJson(),
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> deleteCategory(String categoryId) async {
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.deleteDocument(
          collectionPath: 'categories/$categoryId',
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> getAll() async {
    // TODO: implement getAll
    try {
      await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "categories",
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
        orderByField: "name",
      );
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }
}
