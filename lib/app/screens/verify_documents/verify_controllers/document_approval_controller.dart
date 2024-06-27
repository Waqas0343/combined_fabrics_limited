import 'dart:async';
import 'dart:io';
import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/server/server_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../home/home_controller.dart';
import '../verify_models/next_levels_users.dart';
import '../verify_models/pending_documents_model.dart';
import '../verify_models/update_app_level.dart';
import 'p_o_approve_screen_controller.dart';
import 'p_o_pending_list_controller.dart';

class DocumentApprovalController extends GetxController {
  var statusOptions = ['approved', 'rejected'].obs;
  var status = 'approved'.obs;
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";

  final RxList<NextLevelUsersListModel> approvedUsers =
      RxList<NextLevelUsersListModel>();

  final RxList<NextLevelUsersListModel> rejectedUsers =
      RxList<NextLevelUsersListModel>();
  final RxBool isLoading = RxBool(true);
  final RxBool isLoadingPdf = RxBool(true);

  var selectedUser = Rx<NextLevelUsersListModel?>(null);
  var comments = ''.obs;

  late PendingDocumentsListModel pendingDocumentsListModel;
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;
  var file; // Changed pdfUrl to file
  var pages = 0.obs;
  var isReady = false.obs;

  String? appName;
  int? appID;

  late int currentDocumentIndex;
  late List<PendingDocumentsListModel> pendingDocuments;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    final groupedPendingDocuments = arguments['groupedPendingDocuments']
        as Map<String, List<PendingDocumentsListModel>>;
    appID = arguments['AppID'];
    appName = arguments['AppName'];
    currentDocumentIndex = arguments['currentDocumentIndex'];

    // Initialize pendingDocuments with all documents from groupedPendingDocuments
    pendingDocuments = [];

    // Iterate through all users and collect all documents
    groupedPendingDocuments.forEach((key, value) {
      pendingDocuments.addAll(value);
    });
    print("index...3.............$currentDocumentIndex");

    fetchFunctions();
  }

  void fetchFunctions() {
    Debug.log("currentDocumentIndex...............$currentDocumentIndex");
    approvedUsers.clear();
    rejectedUsers.clear();
    selectedUser.value = null;
    for (var item in pendingDocuments) {
      if (currentDocumentIndex == item.docnum) {
        pendingDocumentsListModel = item;
      }
    }

    getNextLevelUsers(pendingDocumentsListModel.applogid);
    getBelowLevelUsers(pendingDocumentsListModel.applogid);
    fetchPdfUrl(
        pendingDocumentsListModel.appid, pendingDocumentsListModel.docnum);
  }

  void assignUser(NextLevelUsersListModel? user) {
    selectedUser.value = user;
  }

  void updateComments(String text) {
    comments.value = text;
  }

  void submit() async {
    if (status.value.isEmpty) {
      Get.snackbar('Error', 'Please select status',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if ((status.value == 'approved' &&
            approvedUsers.isNotEmpty &&
            selectedUser.value == null) ||
        (status.value == 'rejected' &&
            rejectedUsers.isNotEmpty &&
            selectedUser.value == null)) {
      Get.snackbar('Error', 'Please select a user for the selected status.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    await updateAppLevel();
  }

  Future<void> getNextLevelUsers(int? appLogId) async {
    isLoading(true);
    final responseList = await ApiFetch.getNextLevelUsers("appLogId=$appLogId");
    isLoading(false);
    if (responseList != null) {
      approvedUsers.assignAll(responseList);
    }
  }

  Future<void> getBelowLevelUsers(int? appLogId) async {
    isLoading(true);
    final responseList =
        await ApiFetch.getBelowLevelUsers("appLogId=$appLogId");
    isLoading(false);
    if (responseList != null) {
      rejectedUsers.assignAll(responseList);
    }
  }

  void changeStatus(String? newStatus) {
    if (newStatus != null) {
      status.value = newStatus;
      selectedUser.value = null;
    }
  }

  Future<void> updateAppLevel() async {
    try {
      isLoading(true);

      // Determine if userId is required based on the lists and status
      bool isUserIdRequired =
          (status.value == 'approved' && approvedUsers.isNotEmpty) ||
              (status.value == 'rejected' && rejectedUsers.isNotEmpty);

      UpdateAppLevelModel? updateAppLevelModel;
      if (isUserIdRequired && selectedUser.value != null) {
        updateAppLevelModel = UpdateAppLevelModel(
          appLogId: pendingDocumentsListModel.applogid,
          userId: employeeName,
          selectedUser: selectedUser.value!.userid,
          status: status.value == 'approved' ? 1 : 0,
          comments: comments.value,
          rejectLevel:
              status.value == 'approved' ? 4 : selectedUser.value!.authlevel,
          domainUser: '',
          loginUser: employeeName,
          computerName: '',
          ipAddress: '',
        );
      } else if (!isUserIdRequired) {
        updateAppLevelModel = UpdateAppLevelModel(
          appLogId: pendingDocumentsListModel.applogid,
          userId: employeeName,
          selectedUser: '',
          status: status.value == 'approved' ? 1 : 0,
          comments: comments.value,
          rejectLevel:
              status.value == 'approved' ? 4 : selectedUser.value!.authlevel,
          domainUser: '',
          loginUser: employeeName,
          computerName: '',
          ipAddress: '',
        );
      }

      Debug.log("................${updateAppLevelModel!.appLogId}");
      Debug.log("json................${updateAppLevelModel.toJson()}");

      // Simulate updateAppLevel API call with delay
      await ApiFetch.updateAppLevel(updateAppLevelModel);
      await updatePreferences();


      pendingDocuments.removeWhere((item) => item.docnum == currentDocumentIndex);

      // Check if there are more documents to process
      if (pendingDocuments.isEmpty) {
        // No more documents, go to previous pages
        Get.find<HomeController>().getCountAllDocs();
        Get.close(3); // Close three pages
      } else {
        currentDocumentIndex = pendingDocuments[0].docnum;
        Debug.log("...currentDocumentIndex...............$currentDocumentIndex");
        // Fetch functions for the next document

        fetchFunctions();
      }

      // Refresh other controllers
      Get.find<PendingDocumentsController>().getDashboardAppList(appID);
      Get.find<POApproveHomeController>().dashboardAppList();

      isLoading(false);
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong try again $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updatePreferences() async {
    // String appKey =
    //     'user_${employeeName}_lastCount_${pendingDocumentsListModel.appid}';
    // var pref = Get.find<Preferences>();
    // int lastCount = pref.getInt(appKey) ?? 0;
    //
    // await pref.setInt(appKey, lastCount - 1);
  }

  Future<void> fetchPdfUrl(int appId, int docId) async {
    isLoadingPdf(true);
    String param = "appId=$appId&documentsId=$docId";
    Debug.log("...............${ServerConfig.getVerifyGetFile + param}");
    file = await createFileOfPdfUrl(ServerConfig.getVerifyGetFile + param);
    isLoadingPdf(false);
  }

  Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  Future<File> createFileOfPdfUrl(String filePath) async {
    Completer<File> completer = Completer();
    try {
      final url = filePath;
      final uri = Uri.parse(url);
      final filename = uri.pathSegments.last; // Extract filename from URL

      var request = await HttpClient().getUrl(uri);
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        var dir = await getApplicationDocumentsDirectory();
        File file = File("${dir.path}/$filename");

        await file.writeAsBytes(bytes, flush: true);
        completer.complete(file);
      } else {
        throw Exception('Failed to load PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching or saving PDF: $e');
    }

    return completer.future;
  }
}
