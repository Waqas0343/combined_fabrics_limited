import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/documents_track_list.dart';
import '../verify_models/verify_doc_dashboard_model.dart';

class DocumentsTrackListController extends GetxController {
  final RxBool isLoading = true.obs;
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  var documentsTrackListModel = <DocumentsTrackListModel>[].obs;
  var filteredDocumentsTrackListModel = <DocumentsTrackListModel>[].obs;
  late RxList<DocumentVerifyAppListModel> appsList = RxList<DocumentVerifyAppListModel>();
  var selectedApp = Rx<DocumentVerifyAppListModel?>(null);
  var selectedStatus = 'pending'.obs;
  var searchQuery = ''.obs;  // New search query variable
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    appsList.assignAll(arguments['appsList']);
    if (appsList.isNotEmpty) {
      appsList.removeWhere((item) => item.appid == 99999);

      selectedApp.value = appsList[0];
      fetchDocumentList(appsList[0].appid);
    }
    super.onInit();
  }

  Future<void> fetchDocumentList(int? appId) async {
    isLoading(true);
    final responseList = await ApiFetch.getDocsTrackList("appId=$appId");
    isLoading(false);
    if (responseList != null) {
      responseList.sort((a, b) => a.docnum.compareTo(b.docnum));
      documentsTrackListModel.assignAll(responseList);
      filterDocuments();
    }
  }

  Future<void> fetchDocumentSearchList(String query) async {
    isLoading(true);
    final responseList = await ApiFetch.getDocsTrackSearchList("docNum=$query");
    isLoading(false);
    if (responseList != null) {
      responseList.sort((a, b) => a.docnum.compareTo(b.docnum));
      documentsTrackListModel.assignAll(responseList);
      filterDocuments();
    }
  }

  void filterDocuments() {
    isLoading(true);
    final status = selectedStatus.value;
    final appId = selectedApp.value?.appid;
    final query = searchQuery.value.toLowerCase();

    filteredDocumentsTrackListModel.value = documentsTrackListModel.where((doc) {
      final matchesApp = appId == null || doc.appid == appId;
      final matchesStatus = status == 'both' ||
          (status == 'approved' && doc.status == 1) ||
          (status == 'pending' && doc.status == 0);
      final matchesQuery = doc.docnum.toString().toLowerCase().contains(query);
      return matchesApp && matchesStatus && matchesQuery;
    }).toList();
    isLoading(false);
  }

  void changeApp(DocumentVerifyAppListModel? app) {
    selectedApp.value = app;
    fetchDocumentList(app?.appid);
  }

  void changeStatus(String status) {
    selectedStatus.value = status;
    filterDocuments();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterDocuments();
    if (query.isNotEmpty && filteredDocumentsTrackListModel.isEmpty) {
      fetchDocumentSearchList(query);
    }
  }
}
