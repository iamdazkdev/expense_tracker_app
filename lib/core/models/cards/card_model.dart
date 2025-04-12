import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    required String id,
    required String cardName,
    required String holderName,
    required String accountNumber,
    required String cardType,
    required int backgroundColor,
    @Default(0.0) double balance,
    required DateTime createdAt,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  factory CardModel.empty() {
    return CardModel(
      id: '',
      cardName: '',
      holderName: '',
      accountNumber: '',
      cardType: '',
      backgroundColor: Colors.blue.value,
      balance: 0.0,
      createdAt: DateTime.now(),
    );
  }
}

extension CardModelX on CardModel {
  Color get background => Color(backgroundColor);
}
