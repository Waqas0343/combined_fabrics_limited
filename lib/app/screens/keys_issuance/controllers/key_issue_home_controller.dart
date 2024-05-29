import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../server/api_fetch.dart';
import '../models/kyes_model.dart';

class KeysHomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final Rx<KeyDashBoardModel?> keysDataList = Rx<KeyDashBoardModel?>(null);
  final RxList<KeysListModel> keysList = RxList<KeysListModel>();
  final RxList<KeysDetail> keysDetailData = RxList<KeysDetail>();
  final RxBool hasSearchText = RxBool(false);
  final RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    getKeys();
    super.onInit();
  }

  Future<void> getKeys() async {
    isLoading(true);
    String params = "KeyCode=${searchController.text}";
    final data = await ApiFetch.getKeysList(params);
    isLoading(false);
    if (data != null) {
      keysDataList.value = data;
      keysList.value = data.keysData;

    }
  }


Future<void> applyFilter() async {
  keysList.clear();
  getKeys();
}
}
