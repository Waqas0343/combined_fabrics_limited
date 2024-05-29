import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../services/preferences.dart';

class RowingQualityDashBoardController extends GetxController {
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
