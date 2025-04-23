import 'package:auth_user/auth_user.dart';
import 'package:bloc/bloc.dart';
import 'package:daily_expense_tracker_app/core/helper/shared_prefs_storage.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enum/enum.dart';
import '../../../../core/extension/extension.dart';
import '../../../core/helper/notification_helper.dart';
import '../../../core/models/categories/category_model.dart';
import '../../../core/models/transactions/transaction_model.dart';
import '../../cards/data/card_repository.dart';
import '../../notifications/data/notification_service.dart';
import '../../transaction/data/repository/transaction_base_repository.dart';

part 'transaction_cubit.freezed.dart';
part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionBaseRepository _transactionRepository;
  TransactionCubit({
    required TransactionBaseRepository transactionRepository,
  })  : _transactionRepository = transactionRepository,
        //  _cardRepository = cardRepository,
        super(const TransactionState.initial());

  Transaction _transaction = Transaction.empty();
  CardModel cardModel = CardModel.empty();
  late CardBaseRepository _cardRepository;
  late DbFirestoreClientBase _dbFirestoreClientBase;

  set transaction(Transaction value) => _transaction = value;
  bool _isEditing = false;
  set isEditing(bool value) => _isEditing = value;
  final TextEditingController _amountController = TextEditingController();
  TextEditingController get amountController => _amountController;
  late List<CategoryModel> listCategories = [];
  late List<CardModel> listCards = [];
  late CategoryModel? categoryModel;
  late Categorys categorys;
  late Transaction? _oldTransaction;

  void init() async {
    _dbFirestoreClientBase = DbFirestoreClient();
    _cardRepository = CardRepository(
      dbFirestoreClient: _dbFirestoreClientBase,
      authUser: AuthUser(),
    );

    listCards = await SharedPrefsStorage.getCachedCardModels();
    categorys = Categorys.values[1];
    categoryModel = null;

    if (_isEditing) {
      debugPrint("Chỉnh sửa card");
      _amountController.text = _transaction.amount.toCurrencyString();
      cardModel = getCardById(_transaction.cardID)!;
      _oldTransaction = _transaction;
    } else {
      _amountController.clear();
      _transaction = Transaction.empty();
      cardModel = getDefaultCard()!;
      _transaction = _transaction.copyWith(
        categorysIndex: categorys.index,
        categoryName: categorys.name,
        cardID: cardModel.uuid!,
      );
    }

    emit(_buildState());
  }

  CardModel? getCardById(String id) {
    try {
      return listCards.firstWhere((card) => card.uuid == id);
    } catch (e) {
      debugPrint("Error when get CardByID");
      return CardModel.empty();
    }
  }

  CardModel? getDefaultCard() {
    try {
      return listCards.firstWhere((card) => card.isDefault == true);
    } catch (e) {
      debugPrint("Error when get Defaults Card");
      return CardModel.empty();
    }
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
    cardModel = getCardById(card.uuid!)!;
    emit(_buildState());
  }

  void onTransactionTypeChanged(TransactionType transactionType) {
    _transaction = _transaction.copyWith(category: transactionType);
    cardModel = cardModel.copyWith(transactionType: transactionType);
    emit(_buildState());
  }

  void onTransactionDateChanged(DateTime date) {
    _transaction = _transaction.copyWith(date: date);
    emit(_buildState());
  }

  void addOrUpdateTransaction() async {
    // Tạo trigger khi cần thiết và kiểm tra thông báo vượt hạn mức
    final limitNotificationTrigger = NotificationHelper(
        dbFirestoreClient: _dbFirestoreClientBase,
        notificationService: NotificationService(),
        cardRepository: _cardRepository);
    listCards = await SharedPrefsStorage.getCachedCardModels();
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
    Future.delayed(const Duration(milliseconds: 300)).then((_) async {
      try {
        final newCard = getCardById(transactionUpdated.cardID)!;

        if (_isEditing) {
          final oldTransaction = _oldTransaction!;
          final oldAmount = oldTransaction.amount;
          final oldType = oldTransaction.category;
          final oldCardID = oldTransaction.cardID;

          final newAmount = transactionUpdated.amount;
          final newType = transactionUpdated.category;
          final newCardID = transactionUpdated.cardID;

          debugPrint("======= [DEBUG TRANSACTION UPDATE] =======");
          debugPrint("Old Transaction:");
          debugPrint("- Card ID: $oldCardID");
          debugPrint("- Type: $oldType");
          debugPrint("- Amount: $oldAmount");

          debugPrint("New Transaction:");
          debugPrint("- Card ID: $newCardID");
          debugPrint("- Type: $newType");
          debugPrint("- Amount: $newAmount");
          debugPrint("==========================================");

          _transactionRepository.updateTransaction(transactionUpdated);

          if (oldCardID != newCardID) {
            // Đổi thẻ
            final oldCard = getCardById(oldCardID)!;
            final newCard = getCardById(newCardID)!;

            // Trừ khỏi thẻ cũ
            CardModel updatedOldCard;
            if (oldType == TransactionType.income) {
              updatedOldCard = oldCard.copyWith(
                income: (oldCard.income ?? 0) - oldAmount,
              );
            } else {
              updatedOldCard = oldCard.copyWith(
                expense: (oldCard.expense ?? 0) - oldAmount,
              );
            }

            // Cộng vào thẻ mới
            CardModel updatedNewCard;
            if (newType == TransactionType.income) {
              updatedNewCard = newCard.copyWith(
                income: (newCard.income ?? 0) + newAmount,
              );
            } else {
              updatedNewCard = newCard.copyWith(
                expense: (newCard.expense ?? 0) + newAmount,
              );
            }

            _cardRepository.updateCard(updatedOldCard);
            _cardRepository.updateCard(updatedNewCard);
          } else {
            // Không đổi thẻ
            CardModel updatedCard = newCard;

            if (oldType != newType) {
              // Đổi loại giao dịch
              if (oldType == TransactionType.income) {
                updatedCard = updatedCard.copyWith(
                  income: (updatedCard.income ?? 0) - oldAmount,
                  expense: (updatedCard.expense ?? 0) + oldAmount,
                );
              } else {
                updatedCard = updatedCard.copyWith(
                  expense: (updatedCard.expense ?? 0) - oldAmount,
                  income: (updatedCard.income ?? 0) + oldAmount,
                );
              }
            } else {
              // Cùng loại giao dịch
              if (newType == TransactionType.income) {
                updatedCard = updatedCard.copyWith(
                  income: (updatedCard.income ?? 0) - oldAmount + newAmount,
                );
              } else {
                updatedCard = updatedCard.copyWith(
                  expense: (updatedCard.expense ?? 0) - oldAmount + newAmount,
                );
              }
            }

            _cardRepository.updateCard(updatedCard);
          }

          emit(TransactionState.success('Cập nhật giao dịch thành công'));
        } else {
          // Thêm mới
          _transactionRepository.addTransaction(transactionUpdated);

          CardModel updatedCard = newCard;
          if (transactionUpdated.category == TransactionType.income) {
            updatedCard = updatedCard.copyWith(
              income: (updatedCard.income ?? 0) + transactionUpdated.amount,
            );
          } else {
            updatedCard = updatedCard.copyWith(
              expense: (updatedCard.expense ?? 0) + transactionUpdated.amount,
            );
          }

          _cardRepository.updateCard(updatedCard);
          await limitNotificationTrigger.checkLimitNotificationsForAllCards();
          emit(TransactionState.success('Thêm giao dịch thành công'));
        }
      } catch (e) {
        emit(TransactionState.error("Lỗi: ${e.toString()}"));
      }
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    emit(const TransactionState.loading());

    try {
      Transaction? transaction = await _dbFirestoreClientBase.getDocument(
          documentId: transactionId,
          collectionPath: "transactions",
          objectMapper: (data, id) =>
              Transaction.fromMap(data!, transactionId));
      if (transaction == null) {
        emit(const TransactionState.error('Không tìm thấy giao dịch'));
        return;
      }
      final card = getCardById(transaction.cardID);
      if (card == null) {
        emit(const TransactionState.error('Không tìm thấy thẻ'));
        return;
      }

      CardModel updatedCard = card;
      if (transaction.category == TransactionType.income) {
        updatedCard = updatedCard.copyWith(
          income: (updatedCard.income ?? 0) - transaction.amount,
        );
      } else {
        updatedCard = updatedCard.copyWith(
          expense: (updatedCard.expense ?? 0) - transaction.amount,
        );
      }
      await _cardRepository.updateCard(updatedCard);
      // Xoá transaction
      await _transactionRepository.deleteTransaction(transactionId);

      emit(const TransactionState.success('Giao dịch đã xóa thành công'));
    } catch (error) {
      debugPrint('error: $error');
      emit(TransactionState.error(error.toString()));
    }
  }

  TransactionState _buildState() {
    return TransactionState.loadTransaction(
      categorys: Categorys.fromIndex(_transaction.categorysIndex),
      categoryModel: categoryModel,
      transactionCategory: _transaction.category,
      transactionDate: _transaction.date,
      cardID: _transaction.cardID,
      listCards: listCards,
    );
  }

  @override
  Future<void> close() {
    _isEditing = false;
    _amountController.dispose();
    return super.close();
  }
}
