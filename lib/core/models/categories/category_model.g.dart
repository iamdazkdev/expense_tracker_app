// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorName: (json['colorName'] as num).toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorName': instance.colorName,
      'note': instance.note,
    };
