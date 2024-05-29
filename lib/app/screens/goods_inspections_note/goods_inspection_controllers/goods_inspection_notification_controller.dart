import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../goods_inspection_models/goods_inspection_notification_model.dart';

class GoodsInspectionNotificationController extends GetxController {
  final RxList<NotificationListModel> notificationList =
      RxList<NotificationListModel>();
  final TextEditingController searchController = TextEditingController();
  final RxBool isLoading = RxBool(true);
  String deptCode =
      Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";
  String departmentCode =
      Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final RxBool hasSearchText = RxBool(false);

  @override
  void onInit() {
    getNotificationList();
    super.onInit();
  }

  Future<void> getNotificationList() async {
    String params = "DeptCode=$deptCode&IGPNo=${searchController.text}";
    isLoading(true);
    List<NotificationListModel>? responseList =
        await ApiFetch.getNotificationRequest(params);
    isLoading(false);
    if (responseList != null) {
      notificationList.assignAll(responseList);
    }
  }

  Future<void> saveInspectionFormData(int selectedIndex) async {
    if (notificationList.isEmpty) {
      Get.snackbar(
        "Message",
        'Notification List is empty!',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (selectedIndex < 0 || selectedIndex >= notificationList.length) {
      Get.snackbar(
        "Message",
        'Invalid index!',
        snackPosition: SnackPosition.TOP,
      );

      return;
    }

    NotificationListModel selectedNotification =
        notificationList[selectedIndex];

    Map<String, dynamic> data = {
      "IGPNo": selectedNotification.igpNo,
      "IGPSrNo": selectedNotification.igpSrNo,
      "ItemCode": selectedNotification.itemCode,
      "IGPQty": selectedNotification.igpQty,
      "InspectionBy": employeeName,
      "AcceptedQty": selectedNotification.igpQty,
      "DeptCode": departmentCode,
    };

    bool success = await ApiFetch.addGoodsInspectionFormData(data);

    if (success) {
      Get.snackbar(
        "Message",
        'IGP Inspection Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      refreshPage();
    } else {
      Get.snackbar(
        "Message",
        'IGP Serial No is not Valid!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> applyFilter() async {
    notificationList.clear();
    getNotificationList();
  }

  Future<void> refreshPage() async {
    notificationList.clear();
    getNotificationList();
  }
}
