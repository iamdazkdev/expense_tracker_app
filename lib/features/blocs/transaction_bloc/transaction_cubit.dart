import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../core/models/categories/category_model.dart';
import '../../../core/models/transactions/transaction_model.dart';
import '../../../core/service/network_info.dart';
import '../../transaction/data/repository/transaction_base_repository.dart';

part 'transaction_cubit.freezed.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionBaseRepository _transactionRepository;
  final NetworkBaseInfo _networkInfo;
  TransactionCubit(
      {required TransactionBaseRepository transactionRepository,
      required NetworkBaseInfo networkInfo})
      : _transactionRepository = transactionRepository,
        _networkInfo = networkInfo,
        super(const TransactionState.initial());

  Transaction _transaction = Transaction.empty();
  set transaction(Transaction value) => _transaction = value;
  bool _isEditing = false;
  set isEditing(bool value) => _isEditing = value;
  final TextEditingController _amountController = TextEditingController();
  TextEditingController get amountController => _amountController;
  late List<CategoryModel> listCategories = [];
  late CategoryModel? categoryModel;
  late Categorys categorys;

  void init() async {
    categorys = Categorys.values[1];
    categoryModel = null;
    if (_isEditing) {
      _amountController.text = _transaction.amount.toCurrencyString();
    } else {
      _amountController.clear();
      _transaction = Transaction.empty();
      _transaction = _transaction.copyWith(
          categorysIndex: categorys.index,
          categoryName: categorys.name,
          cardID: "d5b46602-2d15-4738-96f3-2cb3097a3444");
    }
    emit(_buildState());
  }

  void onCategorysChanged(Categorys categorys) {
    this.categorys = categorys;
    categoryModel = listCategories.firstWhere(
      (e) => e.toCategorys() == categorys,
      orElse: () => CategoryModel.empty(),
    );

    _transaction = _transaction.copyWith(
      categorysIndex: categorys.index,
      categoryName: categorys.name,
    );

    emit(_buildState());
  }

  void onCategoryChanged(CategoryModel category) {
    _transaction = _transaction.copyWith(
        categoryName: category.name,
        categorysIndex: category.index != null ? category.index! : 1);
    emit(_buildState());
  }

  void onCardChanged(CardModel card) {
    _transaction = _transaction.copyWith(cardID: card.uuid!);
    emit(_buildState());
  }

  void onTransactionCategoryChanged(TransactionType category) {
    _transaction = _transaction.copyWith(category: category);
    emit(_buildState());
  }

  void onTransactionDateChanged(DateTime date) {
    _transaction = _transaction.copyWith(date: date);
    emit(_buildState());
  }

  void addOrUpdateTransaction() {
    debugPrint(_transaction.toString());

    final amount = _amountController.text.isNotEmpty
        ? _amountController.text.toUnFormattedString().toDouble()
        : 0.0;

    if (amount == 0.0 || amount == 0 || amount == 0.00) {
      emit(TransactionState.error('Số tiền không hợp lệ'));
      return;
    }

    emit(const TransactionState.loading());

    final transactionUpdated = _transaction.copyWith(amount: amount);

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      try {
        if (_isEditing) {
          _transactionRepository.updateTransaction(transactionUpdated);
          emit(const TransactionState.success('Cập nhật giao dịch thành công'));
        } else {
          _transactionRepository.addTransaction(transactionUpdated);
          emit(const TransactionState.success('Thêm giao dịch thành công'));
        }
      } catch (error) {
        debugPrint('error: $error');
        emit(TransactionState.error(error.toString()));
      }
    });
  }

  void deleteTransaction(String transactionId) async {
    emit(const TransactionState.loading());

    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      try {
        _transactionRepository.deleteTransaction(transactionId);
        emit(const TransactionState.success('Transaction deleted success'));
      } catch (error) {
        debugPrint('error: $error');
        emit(TransactionState.error(error.toString()));
      }
    });
  }

  TransactionState _buildState() {
    return TransactionState.loadTransaction(
      categorys: Categorys.fromIndex(_transaction.categorysIndex),
      categoryModel: categoryModel,
      transactionCategory: _transaction.category,
      transactionDate: _transaction.date,
      cardID: _transaction.cardID,
    );
  }

  @override
  Future<void> close() {
    _isEditing = false;
    _amountController.dispose();
    return super.close();
  }

  Future<List<CategoryModel>> getCachedCategoryModels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList("cached_categories");
    if (jsonList == null) return [];
    return jsonList.map((e) => CategoryModel.fromJson(json.decode(e))).toList();
  }
}
