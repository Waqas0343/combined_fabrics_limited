import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _notificationId = 0;

  NotificationManager._internal() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
          Debug.log("notificationResponse ........ ${notificationResponse.id}");
          navigateToTargetScreen();
        });
  }

  void navigateToTargetScreen() {
    Get.to(AppRoutes.home);
  }

  Future<void> showNotification(String title, String body) async {
    int notificationId = _getNextNotificationId();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  int _getNextNotificationId() {
    return _notificationId++;
  }
}
