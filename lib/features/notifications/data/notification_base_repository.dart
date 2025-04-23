import 'package:daily_expense_tracker_app/core/models/notifications/notification_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';

abstract class NotificationBaseRepository {
  Future<AppResult<void>> saveNotification(NotificationModel notification);
  Future<AppResult<void>> getAllNotifications();
  Future<AppResult<void>> updateNotification(NotificationModel notification);
  Future<AppResult<void>> deleteNotification(String notificationId);
}
