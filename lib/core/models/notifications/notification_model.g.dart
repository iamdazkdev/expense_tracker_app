// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      uuid: json['uuid'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as String?,
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      isRead: json['isRead'] as bool?,
      type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']),
      actionUrl: json['actionUrl'] as String?,
      priority: (json['priority'] as num?)?.toInt(),
      createdBySystem: json['createdBySystem'] as bool?,
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'body': instance.body,
      'userId': instance.userId,
      'sentAt': instance.sentAt?.toIso8601String(),
      'isRead': instance.isRead,
      'type': _$NotificationTypeEnumMap[instance.type],
      'actionUrl': instance.actionUrl,
      'priority': instance.priority,
      'createdBySystem': instance.createdBySystem,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.limitWarning: 'limitWarning',
  NotificationType.transactionSuccess: 'transactionSuccess',
  NotificationType.reminder: 'reminder',
  NotificationType.system: 'system',
};
