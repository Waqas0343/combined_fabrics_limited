import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import '../../../server/api_fetch.dart';
import '../../dialogs/dialog.dart';
import '../goods_inspection_models/inpected_igps_list_model.dart';
import '../goods_inspection_models/received_igps_list_model.dart';
import '../goods_inspection_models/requested_igps_list_model.dart';

class GoodsInspectionHomeController extends GetxController {
  final RxList<ReceivedIGPListModel> receivedIGpList = RxList<ReceivedIGPListModel>();
  final RxList<RequestedIGPSListModel> requestedIGpList = RxList<RequestedIGPSListModel>();
  final RxList<InspectedIGPListModel> inspectedIGpList = RxList<InspectedIGPListModel>();
  final RxBool isLoading = RxBool(true);
  final RxBool hasClosing = RxBool(false);
  final RxBool hasSearchText = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  final Debouncer debounce =
      Debouncer(delay: const Duration(milliseconds: 400));
  final RxBool isExpanded = RxBool(true);
  RxInt currentTabIndex = RxInt(0);
  TabController? tabController; // Add TabController
  RxBool isChecked = false.obs;

  @override
  void onInit() {
    Future.wait([
      getReceivedIGPList(),
      getRequestedIGPList(),
      getInspectedIGPList(),
    ]);
    super.onInit();
  }

  @override
  void onClose() {
    tabController?.dispose(); // Dispose the TabController when no longer needed
    super.onClose();
  }

  Future<void> getReceivedIGPList({String? query}) async {
    String params = "filter=${searchController.text}";
    isLoading(true);
    List<ReceivedIGPListModel>? responseList = await ApiFetch.getReceivedIGpListIGpsList(params);
    isLoading(false);
    if (responseList != null) {
      receivedIGpList.assignAll(responseList);
    }
  }

  Future<void> getRequestedIGPList({String? query}) async {
    String params = "filter=${searchController.text}";
    isLoading(true);
    List<RequestedIGPSListModel>? responseList = await ApiFetch.getRequestedIGpListIGpsList(params);
    isLoading(false);
    if (responseList != null) {
      requestedIGpList.assignAll(responseList);
    }
  }

  Future<void> getInspectedIGPList({String? query}) async {
    String params =
        "filter=${searchController.text}&history=${isChecked.value}";
    isLoading(true);
    List<InspectedIGPListModel>? responseList =
        await ApiFetch.getInspectedIGpListIGpsList(params);
    isLoading(false);
    if (responseList != null) {
      inspectedIGpList.assignAll(responseList);
    }
  }

  Future<void> igpReverse(int value) async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data = "IGPNo=$value";
    bool response = await ApiFetch.igpReverseBack(data);
    isLoading(false);
    Get.back();
    if (response) {
      Get.snackbar(
        "Message",
        'Your IGp Reverse Successfully',
        snackPosition: SnackPosition.TOP,
      );
      applyFilter();
    } else {
      Get.snackbar(
        "Message",
        'IGp Not Reverse!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> applyFilter() async {
    int currentTab = currentTabIndex.value;
    if (currentTab == 0) {
      receivedIGpList.clear();
      getReceivedIGPList();
    } else if (currentTab == 1) {
      requestedIGpList.clear();
      getRequestedIGPList();
    } else if (currentTab == 2) {
      inspectedIGpList.clear();
      getInspectedIGPList();
    }
  }

  void search(String text) {
    debounce.call(() {
      int currentTab = currentTabIndex.value;
      switch (currentTab) {
        case 0:
          receivedIGpList.clear();
          getReceivedIGPList(query: text);
          break;
        case 1:
          requestedIGpList.clear();
          getRequestedIGPList(query: text);
          break;
        case 2:
          inspectedIGpList.clear();
          getInspectedIGPList(query: text);
          break;
      }
    });
  }

  void setCurrentTabIndex(int index) {
    currentTabIndex.value = index;
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  void toggle() {
    isChecked.value = !isChecked.value;
  }
}
