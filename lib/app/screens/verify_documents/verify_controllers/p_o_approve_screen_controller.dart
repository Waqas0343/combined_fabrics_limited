import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/verify_doc_dashboard_model.dart';

class POApproveHomeController extends GetxController {
  final RxList<DocumentVerifyAppListModel> dashboardAppList =
      RxList<DocumentVerifyAppListModel>();
  final RxBool isLoading = RxBool(true);
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";

  @override
  void onInit() {
    // TODO: implement onInit
    Debug.log("employeeName $employeeName");
    getDashboardAppList(employeeName);
    super.onInit();
  }

  Future<void> getDashboardAppList(String userId) async {
    String param = "userId=$userId";
    isLoading(true);
    List<DocumentVerifyAppListModel>? responseList =
        await ApiFetch.getVerifyDashboardAppList(param);
    isLoading(false);
    if (responseList != null) {
      dashboardAppList.assignAll(responseList);
    }
  }
}
