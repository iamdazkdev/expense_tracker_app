import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    int? id,
    required String name,
    required String holderName,
    required String accountNumber,
    //required IconData icon,
    required int color,
    bool? isDefault,
    double? balance,
    double? income,
    double? expense,
  }) = _CardModel;

  // Phương thức để chuyển từ JSON thành đối tượng CardModel
  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  // Phương thức empty trả về đối tượng CardModel mặc định
  static CardModel empty() {
    return CardModel(
      id: null,
      name: '',
      holderName: '',
      accountNumber: '',
      // icon: Icons.credit_card,
      color: Colors.grey.toARGB32(),
      isDefault: false,
      balance: 0.0,
      income: 0.0,
      expense: 0.0,
    );
  }
}
