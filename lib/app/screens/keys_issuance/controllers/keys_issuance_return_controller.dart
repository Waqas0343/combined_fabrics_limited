import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../models/kyes_model.dart';

class KeysIssuanceReturnController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController keysCodeController = TextEditingController();
  final TextEditingController employeeCodeController = TextEditingController();
  final Rxn<KeysListModel> keysDepartment = Rxn<KeysListModel>();
  final RxBool isLoading = RxBool(true);


  @override
  void onInit() {
    keysDepartment.value = Get.arguments['keys'];
    if (keysDepartment.value != null) {
      keysCodeController.text = keysDepartment.value!.keyCode.toString();
    }
    super.onInit();
  }

  Future<void> issueKeyToPerson() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }
    Map<String, dynamic> data = {
      "Key": keysCodeController.text,
      "CardNo": employeeCodeController.text,
      "Remarks": remarksController.text,
    };

    bool success = await ApiFetch.keysIssuanceAndReturn(data);
    if (success) {
      Get.snackbar(
        "Successfully",
        "Key Save Successfully.",
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(AppRoutes.keysDashBoardScreen);
    } else {
      Get.snackbar(
        "Alert",
        "Key Not Found!.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }






}
