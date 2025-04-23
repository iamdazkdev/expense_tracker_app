import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/models/notifications/notification_model.dart';
import 'package:daily_expense_tracker_app/core/utils/models/app_result.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/cupertino.dart';

import 'notification_base_repository.dart';

class NotificationRepository implements NotificationBaseRepository {
  final DbFirestoreClientBase _dbFirestoreClient;
  final AuthUserBase _authUser;

  NotificationRepository({
    required DbFirestoreClientBase dbFirestoreClient,
    required AuthUserBase authUser,
  })  : _dbFirestoreClient = dbFirestoreClient,
        _authUser = authUser;

  bool get isUserLoggedIn => _authUser.currentUser != null;

  @override
  Future<AppResult<void>> saveNotification(
      NotificationModel notification) async {
    // TODO: implement saveNotification
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.setDocument(
          collectionPath: 'notifications',
          merge: false,
          documentId: notification.uuid,
          data: notification.toJson(),
        );
      }
      debugPrint("Error: Unable to add Notifications to FireStore");
      return const AppResult.success(null);
    } catch (err) {
      debugPrint("Error when add Notifications to FireStore");
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> deleteNotification(String notificationId) async {
    // TODO: implement deleteNotification
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.deleteDocument(
          collectionPath: 'notifications/$notificationId',
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> getAllNotifications() async {
    // TODO: implement getAllNotifications
    try {
      await _dbFirestoreClient.getQueryOrderBy(
        collectionPath: "notifications",
        field: "userId",
        isEqualTo: _authUser.currentUser!.uid,
        mapper: (data, documentId) => NotificationModel.fromJson(data!),
        orderByField: "sentAt",
      );
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }

  @override
  Future<AppResult<void>> updateNotification(
      NotificationModel notification) async {
    // TODO: implement updateNotification
    try {
      if (isUserLoggedIn) {
        await _dbFirestoreClient.updateDocument(
          collectionPath: 'notifications/${notification.uuid}',
          data: notification.toJson(),
        );
      }
      return const AppResult.success(null);
    } catch (err) {
      return AppResult.failure(err.toString());
    }
  }
}
