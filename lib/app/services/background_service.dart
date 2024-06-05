import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'notification_service.dart';

class BackgroundService {
  static void onStart(ServiceInstance service) async {
    // Initialize the notification manager
    final NotificationManager notificationManager = NotificationManager();
    await notificationManager.init();

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      // Start foreground service with a persistent notification
      // service.setForegroundNotificationInfo(
      //   title: "Flutter Background Service",
      //   content: "Running in background",
      // );
    }

    // Timer to display notification every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (service is AndroidServiceInstance && !(await service.isForegroundService())) {
        return;
      }

      String currentTime = DateTime.now().toString();
      await notificationManager.showNotification(
        'Background Service',
        'Current Time: $currentTime',
      );
    });
  }
}
