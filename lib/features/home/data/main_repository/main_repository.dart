import 'dart:async';

import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_repository.dart';
import 'package:daily_expense_tracker_app/features/notifications/data/notification_service.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:db_hive_client/db_hive_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enum/categorys.dart';
import '../../../../core/helper/notification_helper.dart';
import '../../../../core/helper/shared_prefs_storage.dart';
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
  late CategoryRepository _categoryRepository;
  late CardRepository _cardRepository;
  MainRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required DbHiveClientBase dbHiveClient,
    required AuthUserBase authUser,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _dbHiveClient = dbHiveClient,
        _authUser = authUser;

  String get _currentUser => _authUser.currentUser!.uid;
  bool get _isUserLoggedIn => _authUser.currentUser != null;
  late Timer timer;
  bool isTimerInitialized = false;

  @override
  Future<AppResult<List<Transaction>>> getAll({
    required int? limit,
  }) async {
    _categoryRepository = CategoryRepository(
      dbFirestoreClient: _dbFirestoreClient,
      authUser: AuthUser(),
      dbHiveClient: DbHiveClient(),
    );
    _cardRepository = CardRepository(
      dbFirestoreClient: _dbFirestoreClient,
      authUser: authUser,
    );

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
    //loadAndCacheData();
    // Chỉ thiết lập Timer nếu chưa khởi tạo hôm nay
    if (!isTimerInitialized) {
      final now = DateTime.now();
      final storedDate = await SharedPrefsStorage.getStoredDateForTimer();

      // nếu chưa lưu hoặc khác ngày thì khởi tạo
      if (storedDate == null || !_isSameDay(now, storedDate)) {
        isTimerInitialized = true;
        // Lưu ngày hôm nay
        await SharedPrefsStorage.storeDateForTimer(now);
        // Tạo Timer định kỳ 4 giờ
        timer = Timer.periodic(const Duration(hours: 4), (timer) {
          debugPrint("🕰️ Timer đã được kích hoạt và đang chạy.");
          NotificationHelper(
            dbFirestoreClient: _dbFirestoreClient,
            notificationService: NotificationService(),
            cardRepository: _cardRepository,
          ).checkLimitNotificationsForAllCards();
        });
      }
    }
    unawaited(addAllCategories());
    unawaited(deleteDuplicateCategories());
    loadAndCacheData();
    return AppResult.success(result);
  }

  void loadAndCacheData() async {
    await loadAndCacheDataFromFirebase();
  }

  // Kiểm tra ngày có phải cùng ngày hay không
  bool _isSameDay(DateTime now, DateTime storedDate) {
    return now.year == storedDate.year &&
        now.month == storedDate.month &&
        now.day == storedDate.day;
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

  Future<bool> addAllCategories() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final existingCategories =
          await _dbFirestoreClient.getQuery<CategoryModel>(
        collectionPath: 'categories',
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
      );

      final existingNames = existingCategories
          .map((cat) => cat.name.toLowerCase().trim())
          .toSet();

      final categoryRepository = CategoryRepository(
        dbFirestoreClient: _dbFirestoreClient,
        authUser: _authUser,
        dbHiveClient: _dbHiveClient,
      );

      final categoriesToAdd = <Categorys>[];
      final alreadyExistCategories = <Categorys>[];

      for (final category in Categorys.values) {
        final name = category.name.toLowerCase().trim();
        if (existingNames.contains(name)) {
          alreadyExistCategories.add(category);
        } else {
          categoriesToAdd.add(category);
        }
      }

      if (alreadyExistCategories.isNotEmpty) {
        debugPrint('📦 Các categories đã tồn tại:');
        for (final category in alreadyExistCategories) {
          debugPrint('   • ${category.name}');
        }
      }

      if (categoriesToAdd.isEmpty) {
        debugPrint('✅ Tất cả categories đã tồn tại trên Firestore.');
        await prefs.setBool('has_added_categories', true);
        return true;
      }

      debugPrint('🔄 Đang thêm ${categoriesToAdd.length} categories mới:');
      for (final category in categoriesToAdd) {
        debugPrint('   ➕ ${category.name}');
      }

      final emptyModel = CategoryModel.empty();

      final results = await Future.wait(categoriesToAdd.map((category) {
        return categoryRepository.addAllCategories(emptyModel, category);
      }));

      for (var i = 0; i < results.length; i++) {
        results[i].when(
          success: (_) =>
              debugPrint('✅ Đã thêm category: ${categoriesToAdd[i].name}'),
          failure: (error) => debugPrint(
              '❌ Lỗi khi thêm category: ${categoriesToAdd[i].name}, Lỗi: $error'),
        );
      }

      await prefs.setBool('has_added_categories', true);
      return true;
    } catch (e) {
      debugPrint('❌ addAllCategories gặp lỗi: $e');
      return false;
    }
  }

  Future<void> deleteDuplicateCategories() async {
    final categories = await _dbFirestoreClient.getQuery<CategoryModel>(
      collectionPath: 'categories',
      mapper: (data, documentId) =>
          CategoryModel.fromJson(data!).copyWith(uuid: documentId!),
    );

    final Map<String, List<CategoryModel>> groupedByName = {};

    for (final category in categories) {
      final cleanedName = category.name.toLowerCase().trim();
      groupedByName.putIfAbsent(cleanedName, () => []).add(category);
    }

    int totalDeleted = 0;

    for (final entry in groupedByName.entries) {
      final duplicates = entry.value;

      if (duplicates.length > 1) {
        final toDelete = duplicates.sublist(1);
        final deletedNames = <String>[];

        await Future.wait(toDelete.map((category) async {
          await _categoryRepository.deleteCategory(category.uuid);
          deletedNames.add("${category.name} (ID: ${category.uuid})");
        }));

        for (final name in deletedNames) {
          debugPrint("🗑️ Đã xoá category trùng: $name");
        }

        totalDeleted += toDelete.length;
      }
    }

    debugPrint("✅ Xoá trùng xong, tổng cộng đã xoá $totalDeleted categories.");
  }

/*
  Future<bool> addAllCategories() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final existingCategories =
          await _dbFirestoreClient.getQuery<CategoryModel>(
        collectionPath: 'categories',
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
      );

      final existingNames = existingCategories
          .map((cat) => cat.name.toLowerCase().trim())
          .toSet();

      final categoryRepository = CategoryRepository(
        dbFirestoreClient: _dbFirestoreClient,
        authUser: _authUser,
        dbHiveClient: _dbHiveClient,
      );

      final categoriesToAdd = Categorys.values.where((category) {
        final name = category.name.toLowerCase().trim();
        return !existingNames.contains(name);
      }).toList();

      if (categoriesToAdd.isEmpty) {
        debugPrint('✅ Tất cả categories đã tồn tại trên Firestore.');
        await prefs.setBool('has_added_categories', true);
        return true;
      }

      debugPrint('🔄 Đang thêm ${categoriesToAdd.length} category chưa có...');

      final results = await Future.wait(categoriesToAdd.map((category) {
        return categoryRepository.addAllCategories(
          CategoryModel.empty(),
          category,
        );
      }));

      for (var i = 0; i < results.length; i++) {
        results[i].when(
          success: (_) =>
              debugPrint('✅ Đã thêm category mới: ${categoriesToAdd[i].name}'),
          failure: (error) => debugPrint(
              '❌ Lỗi khi thêm category: ${categoriesToAdd[i].name}, Lỗi: $error'),
        );
      }

      // ✅ Đánh dấu đã thêm vào SharedPreferences
      await prefs.setBool('has_added_categories', true);
      return true;
    } catch (e) {
      debugPrint('❌ addAllCategories gặp lỗi: $e');
      return false;
    }
  }
*/
/*  Future<bool> addAllCategories() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final existingCategories =
          await _dbFirestoreClient.getQuery<CategoryModel>(
        collectionPath: 'categories',
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
      );

      final existingNames = existingCategories
          .map((cat) => cat.name.toLowerCase().trim())
          .toSet();

      final categoryRepository = CategoryRepository(
        dbFirestoreClient: _dbFirestoreClient,
        authUser: _authUser,
        dbHiveClient: _dbHiveClient,
      );

      final categoriesToAdd = <Categorys>[];
      final alreadyExistCategories = <Categorys>[];

      for (final category in Categorys.values) {
        final name = category.name.toLowerCase().trim();
        if (existingNames.contains(name)) {
          alreadyExistCategories.add(category);
        } else {
          categoriesToAdd.add(category);
        }
      }

      if (alreadyExistCategories.isNotEmpty) {
        debugPrint('📦 Các categories đã tồn tại:');
        for (final category in alreadyExistCategories) {
          debugPrint('   • ${category.name}');
        }
      }

      if (categoriesToAdd.isEmpty) {
        debugPrint('✅ Tất cả categories đã tồn tại trên Firestore.');
        await prefs.setBool('has_added_categories', true);
        return true;
      }

      debugPrint('🔄 Đang thêm ${categoriesToAdd.length} categories mới:');
      for (final category in categoriesToAdd) {
        debugPrint('   ➕ ${category.name}');
      }

      final results = await Future.wait(categoriesToAdd.map((category) {
        return categoryRepository.addAllCategories(
          CategoryModel.empty(),
          category,
        );
      }));

      for (var i = 0; i < results.length; i++) {
        results[i].when(
          success: (_) =>
              debugPrint('✅ Đã thêm category: ${categoriesToAdd[i].name}'),
          failure: (error) => debugPrint(
              '❌ Lỗi khi thêm category: ${categoriesToAdd[i].name}, Lỗi: $error'),
        );
      }

      await prefs.setBool('has_added_categories', true);
      return true;
    } catch (e) {
      debugPrint('❌ addAllCategories gặp lỗi: $e');
      return false;
    }
  }

  Future<void> deleteDuplicateCategories() async {
    final categories = await _dbFirestoreClient.getQuery<CategoryModel>(
      collectionPath: 'categories',
      mapper: (data, documentId) =>
          CategoryModel.fromJson(data!).copyWith(uuid: documentId!),
    );

    // Gom nhóm theo tên đã được làm sạch
    final Map<String, List<CategoryModel>> groupedByName = {};

    for (final category in categories) {
      final cleanedName = category.name.toLowerCase().trim();
      groupedByName.putIfAbsent(cleanedName, () => []).add(category);
    }

    int totalDeleted = 0;

    for (final entry in groupedByName.entries) {
      final duplicates = entry.value;

      if (duplicates.length > 1) {
        final toDelete = duplicates.sublist(1);

        for (final category in toDelete) {
          // Gọi phương thức delete từ categoryRepository để xoá category
          await _categoryRepository.deleteCategory(category.uuid);
          debugPrint(
              "🗑️ Đã xoá category trùng: ${category.name} (ID: ${category.uuid})");
          totalDeleted++;
        }
      }
    }
    debugPrint("✅ Xoá trùng xong, tổng cộng đã xoá $totalDeleted categories.");
  }*/

  Future<List<CategoryModel>> getCategoriesFromFireStore() async {
    try {
      final result = await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "categories",
        mapper: (data, documentId) => CategoryModel.fromJson(data!),
        orderByField: "name",
      );
      return result;
    } catch (err) {
      throw Exception('Failed to load categories: $err');
    }
  }

  Future<List<CardModel>> getCardsFromFireStore() async {
    try {
      final result = await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "cards",
        field: "userId",
        isEqualTo: AuthUser().currentUser!.uid,
        mapper: (data, documentId) => CardModel.fromJson(data!),
        orderByField: "name",
      );
      return result;
    } catch (err) {
      throw Exception('Failed to load cards: $err');
    }
  }

  Future<void> loadAndCacheDataFromFirebase() async {
    try {
      // Tải & cache categories
      final categories = await getCategoriesFromFireStore();
      if (categories.isNotEmpty) {
        await SharedPrefsStorage.cacheCategoryModels(categories);
        debugPrint("✅ Cached ${categories.length} categories");
      } else {
        // Clear cache nếu categories rỗng
        await SharedPrefsStorage.clearCategoryModels();
        debugPrint(
            "⚠️ No categories fetched from Firestore. Cleared cached categories.");
      }
      // Tải & cache cards
      final cards = await getCardsFromFireStore();
      if (cards.isNotEmpty) {
        await SharedPrefsStorage.cacheCardModels(cards);
        debugPrint("✅ Cached ${cards.length} cards");
      } else {
        // Clear cache nếu cards rỗng
        await SharedPrefsStorage.clearCardModels();
        debugPrint("⚠️ No cards fetched from Firestore. Cleared cached cards.");
      }
    } catch (e) {
      debugPrint('❌ Error loading data from Firestore: $e');
    }
  }
}
