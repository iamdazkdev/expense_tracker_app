import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/helper/helper.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../core/models/notifications/notification_model.dart';
import 'notification_repository.dart';

AuthUser authUser = AuthUser();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);

// Listen foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;

      if (notification != null) {
        // Hiển thị local
        NotificationService().showNotification(
          notification.title ?? '',
          notification.body ?? '',
        );

        // ✅ Nếu đang đăng nhập thì lưu thông báo vào Firestore
        if (authUser.currentUser != null) {
          final uuid = UniqueKey().toString(); // Hoặc dùng helper tạo UUID
          final userId = authUser.currentUser!.uid;

          final notificationModel = NotificationModel(
            uuid: uuid,
            title: notification.title ?? '',
            body: notification.body ?? '',
            userId: userId,
            sentAt: DateTime.now(),
            isRead: false,
          );

          NotificationRepository(
            dbFirestoreClient: DbFirestoreClient(),
            authUser: authUser,
          ).saveNotification(notificationModel);
        }
      }
    });

    // Listen background click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Notification clicked!');
    });
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _localNotifications.show(
      0,
      title,
      body,
      notificationDetails,
      payload: 'Custom Payload',
    );

    // ✅ Nếu user đang đăng nhập → lưu thông báo
    if (authUser.currentUser != null) {
      final uuid = Helper.generateUUID();
      final userId = authUser.currentUser!.uid;

      final notificationModel = NotificationModel(
        uuid: uuid,
        title: title,
        body: body,
        userId: userId,
        sentAt: DateTime.now(),
        isRead: false,
      );

      await NotificationRepository(
        dbFirestoreClient: DbFirestoreClient(),
        authUser: authUser,
      ).saveNotification(notificationModel);
    }
  }
}
