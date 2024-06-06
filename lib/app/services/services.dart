import 'dart:async';
import 'package:combined_fabrics_limited/app/services/preferences.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import '../debug/debug_pointer.dart';
import '../screens/verify_documents/verify_models/verify_doc_dashboard_model.dart';
import '../server/api_fetch.dart';
import 'notification_manager.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import '../../app_assets/styles/strings/app_constants.dart';

class Services {
  static final Services _instance = Services._();

  Services._();

  factory Services() => _instance;

  Future<void> initServices() async {
    await Get.putAsync<Preferences>(() => Preferences().initial());
  }

  static void onStart(ServiceInstance service) async {
    final NotificationManager notificationManager = NotificationManager();
    await notificationManager.init();

    // Initialize Preferences within the background service
    final prefs = await Preferences().initial();
    Get.put(prefs, permanent: true);

    if (service is AndroidServiceInstance) {
      service.on('setAsForeground').listen((event) {
        service.setAsForegroundService();
      });

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) {
        service.stopSelf();
      });
    }

    Timer.periodic(const Duration(seconds: 20), (timer) async {
      if (service is AndroidServiceInstance &&
          !(await service.isForegroundService())) {
        return;
      }

      String userId = Get.find<Preferences>().getString(Keys.userId) ?? "";
      if (userId.isNotEmpty) {
        List<DocumentVerifyAppListModel> currentList =
            await fetchDashboardAppList(userId);

        for (var app in currentList) {
          String appKey = 'user_${userId}_lastCount_${app.appid}';

          int lastCount = Get.find<Preferences>().getInt(appKey) ?? 0;
          Debug.log(
              "....$appKey....appid....${app.appid}.appname...${app.appname}.lastCount...$lastCount.documentCount....${app.documentCount}");

          if (app.documentCount != lastCount) {
            await Get.find<Preferences>().setInt(appKey, app.documentCount);

            // String notificationMessage =
            //     'You have new documents in ${app.appname}';
            String notificationMessage =
                'Some documents in ${app.appname} have been processed';

            // String notificationMessage = app.documentCount > lastCount
            //     ? 'You have new documents in ${app.appname}'
            //     : 'Some documents in ${app.appname} have been processed';

            await notificationManager.showNotification(
              app.appname,
              notificationMessage,
            );
          }
        }
      }
    });
  }

  static Future<List<DocumentVerifyAppListModel>> fetchDashboardAppList(
      String userId) async {
    String param = "userId=$userId";
    List<DocumentVerifyAppListModel>? responseList =
        await ApiFetch.getVerifyDashboardAppList(param);
    return responseList ?? [];
  }
}
