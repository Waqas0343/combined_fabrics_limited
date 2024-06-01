import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/pending_documents_model.dart';

class POPendingDocumentsController extends GetxController {
  final RxBool isLoading = RxBool(true);
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;
  int? appID;
  String? appName;

  final Map<String, List<PendingDocumentsListModel>> groupedPendingDocuments =
      {};

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    appID = arguments['AppID'];
    appName = arguments['AppName'];
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
      // Group pending documents by the last user and store them in the map
      groupedPendingDocuments.clear(); // Clear previous data
      for (var document in responseList) {
        final lastUser = document.lastuser;
        if (!groupedPendingDocuments.containsKey(lastUser)) {
          groupedPendingDocuments[lastUser] = [];
        }
        groupedPendingDocuments[lastUser]!.add(document);
      }
    }
  }
}
