import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/toaster.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../goods_inspection_models/goods_inspection_receive_igps_model.dart';

class GoodsInspectionReceiveIGPController extends GetxController {
  final RxList<ReceiveIGPListModel> receiveList = RxList<ReceiveIGPListModel>();
  final RxBool isLoading = RxBool(true);
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final TextEditingController searchController = TextEditingController();
  final RxBool hasSearchText = RxBool(false);

  @override
  void onInit() {
    getReceiveIGPList();
    super.onInit();
  }

  Future<void> getReceiveIGPList() async {
    isLoading(true);
    String params = "igpNo=${searchController.text}";
    List<ReceiveIGPListModel>? responseList = await ApiFetch.getReceiveIGPList(params);
    isLoading(false);
    if (responseList != null) {
      receiveList.assignAll(responseList);
    }
  }

  Future<void> saveReceiveIGP(int igpNo) async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }
    Map<String, dynamic> data = {
      "IGPNo": igpNo,
      "ReceivedBy": employeeName,
    };

    bool success = await ApiFetch.receiveIGP(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Receive IGP Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      Toaster.showToast("");
      applyFilter();
    } else {
      Get.snackbar(
        "Message",
        'Failed to Receive IGP!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> applyFilter() async {
    receiveList.clear();
    getReceiveIGPList();
  }
}
