import 'package:daily_expense_tracker_app/core/models/categories/category_model.dart';

import '../../../../core/utils/models/app_result.dart';

abstract class CategoryBaseRepository {
  Future<AppResult<void>> addCategory(CategoryModel category);
  Future<AppResult<void>> updateCategory(CategoryModel category);
  Future<AppResult<void>> deleteCategory(String categoryId);
}
