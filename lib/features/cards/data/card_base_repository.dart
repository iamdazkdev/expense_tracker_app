import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';

abstract class CardBaseRepository {
  Future<AppResult<void>> addCard(CardModel cardModel);
  Future<AppResult<void>> updateCard(CardModel cardModel);
  Future<AppResult<void>> deleteCard(String cardId);
  Future<AppResult<void>> getAllCard();
}
