// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardModelImpl _$$CardModelImplFromJson(Map<String, dynamic> json) =>
    _$CardModelImpl(
      uuid: json['uuid'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      holderName: json['holderName'] as String,
      accountNumber: json['accountNumber'] as String,
      color: (json['color'] as num).toInt(),
      isDefault: json['isDefault'] as bool?,
      balance: (json['balance'] as num?)?.toDouble(),
      income: (json['income'] as num?)?.toDouble(),
      expense: (json['expense'] as num?)?.toDouble(),
      spendingLimit: (json['spendingLimit'] as num?)?.toDouble(),
      isLimitReminderEnabled: json['isLimitReminderEnabled'] as bool?,
      lastLimitReminderSent: json['lastLimitReminderSent'] == null
          ? null
          : DateTime.parse(json['lastLimitReminderSent'] as String),
      transactionType: $enumDecodeNullable(
          _$TransactionTypeEnumMap, json['transactionType']),
    );

Map<String, dynamic> _$$CardModelImplToJson(_$CardModelImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'userId': instance.userId,
      'name': instance.name,
      'holderName': instance.holderName,
      'accountNumber': instance.accountNumber,
      'color': instance.color,
      'isDefault': instance.isDefault,
      'balance': instance.balance,
      'income': instance.income,
      'expense': instance.expense,
      'spendingLimit': instance.spendingLimit,
      'isLimitReminderEnabled': instance.isLimitReminderEnabled,
      'lastLimitReminderSent':
          instance.lastLimitReminderSent?.toIso8601String(),
      'transactionType': _$TransactionTypeEnumMap[instance.transactionType],
    };

const _$TransactionTypeEnumMap = {
  TransactionType.expense: 'expense',
  TransactionType.income: 'income',
};
