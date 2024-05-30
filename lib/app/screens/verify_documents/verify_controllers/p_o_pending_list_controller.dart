import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/pending_documents_model.dart';
import '../verify_models/verify_doc_dashboard_model.dart';

class POPendingDocumentsController extends GetxController {
  final RxList<PendingDocumentsListModel> pendingDocumentsList = RxList<PendingDocumentsListModel>();
  final RxBool isLoading = RxBool(true);
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx <DateTime> dateTime = DateTime.now().obs;
  int? appID;
  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    appID = arguments['AppID'];
    Debug.log('-----------------------------$appID');
    getDashboardAppList(appID);
    super.onInit();
  }

  Future<void> getDashboardAppList(int? appId) async {
    String param = "userId=$employeeName&appId=$appId";
    isLoading(true);
    List<PendingDocumentsListModel>? responseList =
        await ApiFetch.getPendingDocsList(param);
    isLoading(false);
    if (responseList != null) {
      pendingDocumentsList.assignAll(responseList);
    }
  }
}
