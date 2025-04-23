import 'package:auth_user/auth_user.dart';
import 'package:daily_expense_tracker_app/core/models/cards/card_model.dart';
import 'package:daily_expense_tracker_app/features/cards/data/card_base_repository.dart';
import 'package:db_firestore_client/db_firestore_client.dart';
import 'package:flutter/cupertino.dart';

import '../../features/notifications/data/notification_service.dart';

class NotificationHelper {
  final NotificationService notificationService;
  final CardBaseRepository cardRepository;
  final DbFirestoreClientBase dbFirestoreClient;

  NotificationHelper({
    required this.dbFirestoreClient,
    required this.notificationService,
    required this.cardRepository,
  });

  /// Kiểm tra nếu thẻ vượt hạn mức và chưa gửi thông báo hôm nay
  Future<void> checkAndSendLimitNotification(CardModel card) async {
    debugPrint("▶️ Bắt đầu checkAndSendLimitNotification");

    if (card.isLimitReminderEnabled != false) {
      debugPrint(
          "⏭️ Bỏ qua: isLimitReminderEnabled = ${card.isLimitReminderEnabled}");
      return;
    }
    debugPrint("✅ isLimitReminderEnabled = true");

    if (!card.isOverLimit) {
      debugPrint("⏭️ Bỏ qua: isOverLimit = ${card.isOverLimit}");
      return;
    }
    debugPrint("⚠️ isOverLimit = true");

    final now = DateTime.now();
    final lastSent = card.lastLimitReminderSent;
    debugPrint("📅 now = $now, lastSent = $lastSent");

    final isSameDay = lastSent != null &&
        lastSent.year == now.year &&
        lastSent.month == now.month &&
        lastSent.day == now.day;
    if (isSameDay) {
      debugPrint("⏭️ Bỏ qua: Đã gửi trong cùng ngày");
      return;
    }
    debugPrint("🆕 Chưa gửi hôm nay, chuẩn bị gửi notification");

    // 🔔 Gửi thông báo
    await notificationService.showNotification(
      "Vượt hạn mức chi tiêu",
      "Thẻ '${card.name}' đã vượt quá hạn mức cho phép.",
    );
    debugPrint("🔔 Đã gọi showNotification");

    // ✅ Cập nhật thời gian gửi thông báo lần cuối
    final updatedCard = card.copyWith(lastLimitReminderSent: now);
    await cardRepository.updateCard(updatedCard);
    debugPrint("💾 Đã cập nhật lastLimitReminderSent trong repository");
  }

  /// Trigger cho tất cả các thẻ
  Future<void> checkLimitNotificationsForAllCards() async {
    debugPrint("Đang kiểm tra limit của thẻ");
    List<CardModel> cards = await getCardsFromFireStore();

    for (final card in cards) {
      await checkAndSendLimitNotification(card);
    }
  }

  Future<List<CardModel>> getCardsFromFireStore() async {
    try {
      final result = await dbFirestoreClient.getQueryOrderBy(
        collectionPath: "cards",
        field: "userId",
        isEqualTo: AuthUser().currentUser!.uid,
        mapper: (data, documentId) => CardModel.fromJson(data!),
        orderByField: "name",
      );
      return result;
    } catch (err) {
      throw Exception('Failed to load cards: $err');
    }
  }
}
