import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/toaster.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';
import '../goods_inspection_models/goods_inspection_notification_model.dart';

class GoodsInspectionController extends GetxController {
  final Rxn<NotificationListModel> notificationModel = Rxn<NotificationListModel>();
  final TextEditingController acceptQtyController = TextEditingController();
  final TextEditingController rejectQtyController = TextEditingController();
  final TextEditingController rejectReasonController = TextEditingController();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final TextEditingController remarksController = TextEditingController();
  String departmentCode = Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  RxBool showRejectReason = RxBool(false);
  final RxBool isRejectQtyEmpty = RxBool(true);

  @override
  void onInit() {
    notificationModel.value = Get.arguments['model'];
    super.onInit();
  }

  Future<void> saveInspectionFormData() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    // Connectivity checking
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   buttonAction.value = true;
    //   return;
    // }
    Get.defaultDialog(
      title: 'Confirmation',
      middleText: 'Do you want to save the form?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        Get.dialog(const LoadingSpinner()); // Display loading spinner
        Map<String, dynamic> data = {
          "IGPNo": notificationModel.value?.igpNo,
          "IGPSrNo": notificationModel.value?.igpSrNo,
          "ItemCode": notificationModel.value?.itemCode,
          "IGPQty": notificationModel.value?.igpQty,
          "AcceptedQty": acceptQtyController.text,
          "RejQty": rejectQtyController.text,
          "RejReason": rejectReasonController.text,
          "Remarks": remarksController.text,
          "InspectionBy": employeeName,
          "DeptCode": departmentCode,
        };

        bool success = await ApiFetch.addGoodsInspectionFormData(data);
        Get.back();
        if (success) {
          Toaster.showToast("IGP Detail Added Successfully!");
          Get.offAllNamed(AppRoutes.goodsInspectionNotification);
        } else {
          Toaster.showToast("IGP Serial No is not Valid!");
        }
      },
      onCancel: () {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  void updateRejectQtyField() {
    final text = rejectQtyController.text;
    isRejectQtyEmpty.value = text.isEmpty;
  }
}
