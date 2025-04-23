import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cards/card_model.dart';
import '../models/categories/category_model.dart';
import '../models/transactions/transaction_model.dart';

class SharedPrefsStorage {
  // Save CategoryModels
  static Future<void> cacheCategoryModels(
      List<CategoryModel> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> categoryJsonList =
        categories.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList("cached_categories", categoryJsonList);
  }

  // Load CategoryModels
  static Future<List<CategoryModel>> getCachedCategoryModels() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("cached_categories");
    if (jsonList == null) return [];
    return jsonList.map((e) => CategoryModel.fromJson(json.decode(e))).toList();
  }

  // Save CardModels
  static Future<void> cacheCardModels(List<CardModel> cards) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cardJsonList =
        cards.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList("cached_cards", cardJsonList);
  }

  // Load CardModels
  static Future<List<CardModel>> getCachedCardModels() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList("cached_cards");
    if (jsonList == null) return [];
    return jsonList.map((e) => CardModel.fromJson(json.decode(e))).toList();
  }

  static Future<void> clearCategoryModels() async {
    // Xóa cached categories
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_categories');
  }

  static Future<void> clearCardModels() async {
    // Xóa cached cards
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_cards');
  }

  /// Lưu ngày Timer đã khởi tạo vào SharedPreferences
  static Future<void> storeDateForTimer(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_timer_date', date.millisecondsSinceEpoch);
    debugPrint("Ngày Timer đã được lưu: ${date.toIso8601String()}");
  }

  /// Lấy ngày đã lưu từ SharedPreferences
  static Future<DateTime?> getStoredDateForTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_timer_date');
    if (timestamp != null) {
      DateTime storedDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      debugPrint("Ngày Timer đã lưu: ${storedDate.toIso8601String()}");
      return storedDate;
    }
    return null;
  }

  static Future<void> cacheTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();

    // Chuyển danh sách Transaction thành danh sách JSON
    final List<String> transactionJsonList = transactions
        .map(
          (e) => json.encode(
            e.toJson(),
          ),
        )
        .toList();

    // Lưu danh sách JSON vào SharedPreferences
    bool isCached =
        await prefs.setStringList("cached_transactions", transactionJsonList);
    if (isCached) {
      debugPrint(
          "✅ [CACHE SUCCESS]: Dữ liệu đã được lưu thành công vào cache.");
    } else {
      debugPrint("❌ [CACHE FAILED]: Lưu dữ liệu vào cache không thành công.");
    }
  }

  static Future<List<Transaction>> getCachedTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? transactionJsonList =
        prefs.getStringList("cached_transactions");

    if (transactionJsonList == null) {
      return [];
    }
    return transactionJsonList
        .map(
          (jsonString) => Transaction.fromJson(
            jsonDecode(jsonString),
          ),
        )
        .toList();
  }
}
