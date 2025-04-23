import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enum/notification_type_enum.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String uuid,
    required String title,
    required String body,
    required String? userId,
    DateTime? sentAt,
    bool? isRead,
    NotificationType? type,
    String? actionUrl,
    int? priority,
    bool? createdBySystem,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.empty() => const NotificationModel(
        uuid: '',
        title: '',
        body: '',
        userId: '',
      );
}
