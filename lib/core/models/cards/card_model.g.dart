// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardModelImpl _$$CardModelImplFromJson(Map<String, dynamic> json) =>
    _$CardModelImpl(
      id: json['id'] as String,
      cardName: json['cardName'] as String,
      holderName: json['holderName'] as String,
      accountNumber: json['accountNumber'] as String,
      cardType: json['cardType'] as String,
      backgroundColor: (json['backgroundColor'] as num).toInt(),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CardModelImplToJson(_$CardModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cardName': instance.cardName,
      'holderName': instance.holderName,
      'accountNumber': instance.accountNumber,
      'cardType': instance.cardType,
      'backgroundColor': instance.backgroundColor,
      'balance': instance.balance,
      'createdAt': instance.createdAt.toIso8601String(),
    };
