import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:daily_expense_tracker_app/core/models/categories/category_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';
import 'package:daily_expense_tracker_app/features/categories/data/category_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';

class CategoryRepository implements CategoryBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final DbHiveClientBase _dbHiveClient;
  final AuthUserBase _authUser;
  CategoryRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
    required DbHiveClientBase dbHiveClient,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _dbHiveClient = dbHiveClient,
        _authUser = authUser;
  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<void>> addCategory(CategoryModel category) async {
    // TODO: implement addCategory
    try {
      final generateUUID = Helper.generateUUID();
      if (isUserLoggedIn) {
        await _dbFirestoreClient.setDocument(
          collectionPath: 'categories',
          merge: false,
          documentId: generateUUID,
          data: category.copyWith(id: generateUUID).toJson(),
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateCategory(CategoryModel category) async {
    // TODO: implement updateCategory
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'categories/${category.id}',
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
    // TODO: implement deleteCategory
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
}
