// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardModelImpl _$$CardModelImplFromJson(Map<String, dynamic> json) =>
    _$CardModelImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      holderName: json['holderName'] as String,
      accountNumber: json['accountNumber'] as String,
      color: (json['color'] as num).toInt(),
      isDefault: json['isDefault'] as bool?,
      balance: (json['balance'] as num?)?.toDouble(),
      income: (json['income'] as num?)?.toDouble(),
      expense: (json['expense'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CardModelImplToJson(_$CardModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'holderName': instance.holderName,
      'accountNumber': instance.accountNumber,
      'color': instance.color,
      'isDefault': instance.isDefault,
      'balance': instance.balance,
      'income': instance.income,
      'expense': instance.expense,
    };
