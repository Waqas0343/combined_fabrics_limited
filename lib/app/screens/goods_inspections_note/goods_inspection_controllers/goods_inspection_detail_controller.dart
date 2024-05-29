import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';
import '../goods_inspection_models/goods_inspection_other_department_model.dart';
import '../goods_inspection_models/igps_detail_model.dart';
import '../goods_inspection_models/received_igps_list_model.dart';

class GoodsInspectionDetailController extends GetxController {
  final RxList<GoodsInspectionOtherDepartmentListModel> otherDepartmentList = RxList<GoodsInspectionOtherDepartmentListModel>();
  final Rxn<GoodsInspectionOtherDepartmentListModel?> selectedDepartment = Rxn<GoodsInspectionOtherDepartmentListModel?>();
  final TextEditingController selectedShortTextController = TextEditingController();
  String? userDepartment = Get.find<Preferences>().getString(Keys.departmentCode);
  final RxList<IGPDetailListModel> iGpDetailList = RxList<IGPDetailListModel>();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final Rxn<ReceivedIGPListModel> igpModel = Rxn<ReceivedIGPListModel>();
  final RxBool isSelectAllChecked = RxBool(false);
  var selectedItems = <IGPDetailListModel>[].obs;
  final RxBool buttonAction = RxBool(true);
  var iGpData = <IGPDetailListModel>[].obs;
  final RxBool isLoading = RxBool(true);
  final RxBool isExpanded = RxBool(true);

  @override
  void onInit() {
    igpModel.value = Get.arguments['model'];
    Future.wait([getIGPDetailList(), getOtherDepartmentList()]);
    super.onInit();
  }

  Future<void> getIGPDetailList() async {
    String params = "IGPNo=${igpModel.value?.igpNo}";
    isLoading(true);
    List<IGPDetailListModel>? responseList =
        await ApiFetch.getPendingIGpsDetail(params);
    isLoading(false);
    if (responseList != null) {
      iGpDetailList.assignAll(responseList);
    }
  }

  Future<void> getOtherDepartmentList() async {
    isLoading(true);
    List<GoodsInspectionOtherDepartmentListModel>? responseList =
        await ApiFetch.getOtherDepartmentInGoodInspection();
    isLoading(false);
    if (responseList != null) {
      otherDepartmentList.assignAll(responseList);
    }
  }

  Future<void> saveIGPsData() async {
    // buttonAction(false);
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

        List<Map<String, dynamic>> payload = selectedItems.map((iGPsData) {
          return {
            "IGPNo": iGPsData.igpNo,
            "IGPSrNo": iGPsData.igpSrNo,
            "ItemCode": iGPsData.itemDescriptionCode,
            "IGPQty": iGPsData.igpQty,
            "RequestedBy": employeeName,
            "DeptRequest": iGPsData.deptCode,
            "OtherDept": iGPsData.selectedDepartment != null
                ? iGPsData.selectedDepartment!.deptCode
                : null,
          };
        }).toList();
        bool success = await ApiFetch.sendIGPDRequest(payload);
        Get.back();
        if (success) {
          Get.snackbar(
            "Message",
            'IGPs Request Successfully!',
            snackPosition: SnackPosition.TOP,
          );
          Get.offAllNamed(AppRoutes.goodsInspectionDashboard);
        } else {
          Get.snackbar(
            "Message",
            'Request Not Saved!',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onCancel: () {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  String getUserDepartmentFunction() {
    String userDepartment =
        Get.find<Preferences>().getString(Keys.departmentCode) ?? "";
    return userDepartment;
  }

  void toggleSelect(IGPDetailListModel item) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
  }

  void toggleSelectAll() {
    isSelectAllChecked.value = !isSelectAllChecked.value;
    if (isSelectAllChecked.value) {
      selectedItems.assignAll(iGpDetailList);
    } else {
      selectedItems.clear();
    }
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }
}
