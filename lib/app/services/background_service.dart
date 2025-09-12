
class BackgroundService {
  // static void onStart(ServiceInstance service) async {
  //   final NotificationManager notificationManager = NotificationManager();
  //   await notificationManager.init();
  //
  //   if (service is AndroidServiceInstance) {
  //     service.on('setAsForeground').listen((event) {
  //       service.setAsForegroundService();
  //     });
  //
  //     service.on('setAsBackground').listen((event) {
  //       service.setAsBackgroundService();
  //     });
  //
  //     service.on('stopService').listen((event) {
  //       service.stopSelf();
  //     });
  //   }
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   Timer.periodic(const Duration(seconds: 10), (timer) async {
  //     if (service is AndroidServiceInstance &&
  //         !(await service.isForegroundService())) {
  //       return;
  //     }
  //
  //     String userId = prefs.getString(Keys.userId) ?? "";
  //     if (userId.isNotEmpty) {
  //       List<DocumentVerifyAppListModel> currentList =
  //       await fetchDashboardAppList(userId);
  //
  //       for (var app in currentList) {
  //         String appKey = 'user_${userId}_lastCount_${app.appid}';
  //
  //         int lastCount = prefs.getInt(appKey) ?? 0;
  //         Debug.log(
  //             "....$appKey....appid....${app.appid}.appname...${app.appname}.lastCount...$lastCount.documentCount....${app.documentCount}");
  //
  //         if (app.documentCount != lastCount) {
  //           await prefs.setInt(appKey, app.documentCount);
  //
  //           String notificationMessage =
  //               'You have new documents in ${app.appname}';
  //
  //           await notificationManager.showNotification(
  //             app.appname,
  //             notificationMessage,
  //           );
  //         }
  //       }
  //     }
  //   });
  // }
  //
  // static Future<List<DocumentVerifyAppListModel>> fetchDashboardAppList(
  //     String userId) async {
  //   String param = "userId=$userId";
  //   List<DocumentVerifyAppListModel>? responseList =
  //   await ApiFetch.getVerifyDashboardAppList(param);
  //   return responseList ?? [];
  // }
}
