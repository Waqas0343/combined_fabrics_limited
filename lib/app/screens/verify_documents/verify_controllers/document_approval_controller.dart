import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/next_levels_users.dart';
import '../verify_models/pending_documents_model.dart';
import '../verify_models/update_app_level.dart';

class DocumentApprovalController extends GetxController {
  var statusOptions = ['approved', 'rejected'].obs;
  var status = 'approved'.obs;
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";

  final RxList<NextLevelUsersListModel> approvedUsers =
      RxList<NextLevelUsersListModel>();

  final RxList<NextLevelUsersListModel> rejectedUsers =
      RxList<NextLevelUsersListModel>();
  final RxBool isLoading = RxBool(true);

  var selectedUser = Rx<NextLevelUsersListModel?>(null);
  var comments = ''.obs;
  late PendingDocumentsListModel pendingDocumentsListModel;
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;
  var pdfUrl = ''.obs;
  var pages = 0.obs;
  var isReady = false.obs;
  String? appName;
  late PDFViewController pdfViewController;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    pendingDocumentsListModel = arguments['docItem'];
    appName = arguments['AppName'];
    getNextLevelUsers(pendingDocumentsListModel.applogid);
    getBelowLevelUsers(pendingDocumentsListModel.appid);
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

  Future<void> getBelowLevelUsers(int? appId) async {
    isLoading(true);
    final responseList =
        await ApiFetch.getBelowLevelUsers("appId=$appId&userId=$employeeName");
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
            userId: selectedUser.value!.userid,
            status: status.value == 'approved' ? 1 : 0,
            comments: comments.value,
            rejectLevel: 4,
            domainUser: '',
            loginUser: employeeName,
            computerName: '',
            ipAddress: '');
      } else if (!isUserIdRequired) {
        updateAppLevelModel = UpdateAppLevelModel(
            appLogId: pendingDocumentsListModel.applogid,
            userId: '',
            status: status.value == 'approved' ? 1 : 0,
            comments: comments.value,
            rejectLevel: 4,
            domainUser: '',
            loginUser: employeeName,
            computerName: '',
            ipAddress: '');
      }

      if (updateAppLevelModel != null) {
        isLoading(true);
        // await ApiFetch.updateAppLevel(updateAppLevelModel);
        isLoading(false);
        Get.snackbar('Success', 'Document updated successfully.',
            snackPosition: SnackPosition.BOTTOM);
        Get.close(2);
      } else {
        Get.snackbar('Error', 'User selection is required.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'Something went wrong try again $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchPdfUrl(int appId, int docId) async {
    // String param = "appId=$appId&documentsId=$employeeName";
    String param = "appId=8&documentsId=24050026";
    // pdfUrl.value = (await ApiFetch.fetchPdfUrl(param)) ?? '';
    fromAsset('assets/188.pdf', '188.pdf').then((f) {
      pdfUrl.value = f.path;
    });
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
}
