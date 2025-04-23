import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/transaction.dart';

part 'card_model.freezed.dart';
part 'card_model.g.dart';

@freezed
class CardModel with _$CardModel {
  const factory CardModel({
    required String? uuid,
    required String? userId,
    required String name,
    required String holderName,
    required String accountNumber,
    required int color,
    bool? isDefault,
    double? balance,
    double? income,
    double? expense,
    // 🔔 Hạn mức chi tiêu được đặt cho thẻ
    double? spendingLimit,
    // ⏰ Bật tắt nhắc nhở khi vượt hạn mức
    bool? isLimitReminderEnabled,
    // 📅 Thời điểm lần cuối gửi cảnh báo (giúp tránh spam thông báo)
    DateTime? lastLimitReminderSent,
    TransactionType? transactionType,
  }) = _CardModel;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);

  static CardModel empty() {
    return CardModel(
      uuid: null,
      name: '',
      holderName: '',
      accountNumber: '',
      color: Colors.grey.value,
      isDefault: false,
      balance: 0.0,
      income: 0.0,
      expense: 0.0,
      spendingLimit: 0.0,
      isLimitReminderEnabled: false,
      lastLimitReminderSent: null,
      transactionType: null,
      userId: '',
    );
  }
}

extension CardModelColorExtension on CardModel {
  Color get getColor => Color(color);
}

extension CardModelLimitExtension on CardModel {
  bool get isOverLimit {
    if (spendingLimit == null) return false;
    return (expense ?? 0) > spendingLimit!;
  }
}

extension CardModelBalanceExtension on CardModel {
  double get getBalance {
    return (income ?? 0.0) - (expense ?? 0.0);
  }
}
