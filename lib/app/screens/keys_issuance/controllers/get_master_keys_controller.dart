import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../server/api_fetch.dart';
import '../../dialogs/dialog.dart';
import '../models/get_master_keys_model.dart';

class GetMasterKeysController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<MasterKeysListModel> masterKeysList =
      RxList<MasterKeysListModel>();
  final RxBool hasSearchText = RxBool(false);
  final RxBool isLoading = RxBool(true);

  @override
  void onInit() {
    getMasterKeysList();
    super.onInit();
  }

  Future<void> getMasterKeysList() async {
    isLoading(true);
    String params = "KeyCode=${searchController.text}";
    List<MasterKeysListModel>? responseList =
        await ApiFetch.getMasterKeysList(params);
    isLoading(false);
    if (responseList != null) {
      masterKeysList.assignAll(responseList);
    }
  }

  Future<void> applyFilter() async {
    masterKeysList.clear();
    getMasterKeysList();
  }

  Future<void> deleteRecord(int value) async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data = "Id=$value";
    bool response = await ApiFetch.deleteKey(data);
    isLoading(false);
    Get.back();
    if (response) {
      Get.snackbar(
        "Message",
        'Your Records Delete Successfully',
        snackPosition: SnackPosition.TOP,
      );
      applyFilter();
    } else {
      Get.snackbar(
        "Message",
        'Records Not Delete!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
