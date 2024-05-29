import 'package:get/get.dart';

import '../models/kyes_model.dart';

class KeyHistoryController extends GetxController {
  List<KeysDetail> keysDetails = [];

  @override
  void onInit() {
    super.onInit();
    keysDetails = Get.arguments;
  }
}
