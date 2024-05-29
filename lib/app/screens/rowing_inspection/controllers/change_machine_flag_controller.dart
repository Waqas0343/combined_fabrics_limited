import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_change_flag_model.dart';
import '../models/rowing_quality_flag_color_model.dart';
import '../models/rowing_quality_machine_dashboard_model.dart';

class ChangeMachineFlagController extends GetxController {
  final RxList<ChangeFlagReasonListModel> reasonList = RxList<ChangeFlagReasonListModel>();
  final RxList<ChangeFlagReasonListModel> selectedReason = <ChangeFlagReasonListModel>[].obs;
  final Rxn<RowingQualityMachineDashboardListModel> machineModel = Rxn<RowingQualityMachineDashboardListModel>();
  final RxList<FlagColorListModel> flagColorList = RxList<FlagColorListModel>();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final TextEditingController reasonController = TextEditingController();
  Rx<FlagColorListModel?> selectedFlag = Rx<FlagColorListModel?>(null);
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = RxBool(true);
  @override
  void onInit() {
    machineModel.value = Get.arguments['model'];
    getRowingQualityMachineWithFlag();
    getReasonName();
    super.onInit();
  }

  Future<void> getRowingQualityMachineWithFlag() async {
    isLoading(true);
    List<FlagColorListModel>? responseList = await ApiFetch.getRowingQualityFlagColor();
    isLoading(false);
    if (responseList != null) {
      flagColorList.assignAll(responseList);
    }
  }

  Future<void> getReasonName() async {
    isLoading(true);
    List<ChangeFlagReasonListModel>? responseList = await ApiFetch.getRowingQualityChangeFlgReason();
    isLoading(false);
    if (responseList != null) {
      reasonList.assignAll(responseList);
    }
  }
  Future<void> rowingQualityMachineFlagUpdate() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    String remarks = selectedReason.map((item) => item.reasons).join(", ");
    String params = "Machine=${machineModel.value?.machineCode}&flagcolor=${selectedFlag.value?.colorHexCode}&Remarks=$remarks&userid=$employeeName";
    Debug.log(params);
    bool success = await ApiFetch.changeMachineFlagUpdate(params);
    isLoading.value = false;
    buttonAction(true);
    if (success) {
      Get.snackbar(
        "Successfully",
        "Machine Flag Change Successfully!.",
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(AppRoutes.rowingInspectionDashboard);
    } else {
      Get.snackbar(
        "Alert!",
        "Machine Flag Not Change!.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

}
