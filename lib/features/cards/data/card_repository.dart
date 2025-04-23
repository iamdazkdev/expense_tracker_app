import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/cupertino.dart';

class CardRepository implements CardBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final AuthUserBase _authUser;

  CardRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _authUser = authUser;

  /// The [isUserLoggedIn] method is used to check if the user is logged in.
  /// If the user is logged in, it returns true.
  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<void>> addCard(CardModel cardModel) async {
    // TODO: implement addCard
    try {
      if (isUserLoggedIn) {
        final existingCards = await _dbFirestoreClient.getQuery(
          collectionPath: "cards",
          field: "userId",
          isEqualTo: _authUser.currentUser!.uid,
          mapper: (data, documentId) => CardModel.fromJson(data!),
        );

        // Đặt thẻ đầu tiên tạo làm Defaults.
        final updatedCard = cardModel.copyWith(
          isDefault: existingCards.isEmpty ? true : false,
        );

        await _dbFirestoreClient.setDocument(
          collectionPath: 'cards',
          merge: false,
          documentId: updatedCard.uuid!,
          data: updatedCard.toJson(),
        );
      }
      debugPrint("Success: Successfully to add Card to FireStore");
      return const AppResult.success(null);
    } catch (err) {
      debugPrint("Error when add Card to FireStore");
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateCard(CardModel cardModel) async {
    // TODO: implement updateCard
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'cards/${cardModel.uuid}',
          data: cardModel.toJson(),
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> deleteCard(String cardId) async {
    // TODO: implement deleteCard
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.deleteDocument(
          collectionPath: 'cards/$cardId',
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> getAllCard() async {
    // TODO: implement getAllCard
    try {
      await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "cards",
        field: "userId",
        isEqualTo: _authUser.currentUser!.uid,
        mapper: (data, documentId) => CardModel.fromJson(data!),
        orderByField: "name",
      );
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }
}
