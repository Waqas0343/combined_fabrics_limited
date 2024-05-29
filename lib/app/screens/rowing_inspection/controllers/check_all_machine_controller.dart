import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../server/api_fetch.dart';
import '../models/rowing_quality_machine_dashboard_model.dart';

class CheckAllMachineFlagController extends GetxController {
  final RxList<RowingQualityMachineDashboardListModel> machineList = RxList<RowingQualityMachineDashboardListModel>();
  final TextEditingController searchController = TextEditingController();
  final RxBool hasSearchText = RxBool(false);
  final RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    getRowingQualityMachineWithFlag();
  }

  Future<void> getRowingQualityMachineWithFlag() async {
    isLoading(true);
    String params = "Machinecode=${searchController.text}";
    List<RowingQualityMachineDashboardListModel>? responseList = await ApiFetch.getRowingQualityDashBoardMachine(params);
    isLoading(false);
    if (responseList != null) {
      machineList.assignAll(responseList);
    }
  }
  Future<void> applyFilter() async {
    machineList.clear();
    getRowingQualityMachineWithFlag();
  }
}
