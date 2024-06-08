import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../verify_models/document_history.dart';

class DocumentHistoryController extends GetxController {
  var documentHistoryList = <DocumentHistoryList>[].obs;
  final RxBool isLoading = RxBool(true);
  int? appLogId;
  final DateFormat dateFormat = DateFormat('EEEE, MMMM d, yyyy h:mm a');
  Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    appLogId = arguments['appLogId'];
    fetchDocumentHistory(appLogId);
    super.onInit();
  }

  Future<void> fetchDocumentHistory(int? appLogId) async {
    isLoading(true);
    final responseList = await ApiFetch.getDocHistory("appLogId=$appLogId");
    isLoading(false);
    if (responseList != null) {
      // Sort the response list by autoid
      responseList.sort((a, b) => a.autoid.compareTo(b.autoid));
      documentHistoryList.assignAll(responseList);
    }
  }
}
