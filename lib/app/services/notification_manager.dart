import 'dart:ui';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  NotificationManager._internal() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
      debug: true,
    );
  }
  @pragma("vm:entry-point")
  static Future <void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    // Your code goes here

    Get.to(AppRoutes.verifyDocumentDashBoard);
  }

  void navigateToTargetScreen([String? payload]) {
    if (payload != null) {
      Get.to(AppRoutes.home);
    } else {
      Get.to(AppRoutes.home);
    }
  }

  Future<void> showNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
