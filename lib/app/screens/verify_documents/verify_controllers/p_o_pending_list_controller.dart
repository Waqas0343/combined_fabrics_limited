import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../verify_models/next_levels_users.dart';
import '../verify_models/pending_documents_model.dart';

class PendingDocumentsController extends GetxController {
  final RxBool isLoading = RxBool(true);
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  Rx<DateTime> dateTime = DateTime.now().obs;
  int? appID;
  bool isDropDown = false;
  String? appName;
  int currentDocumentIndex = 0;
  final Map<String, List<PendingDocumentsListModel>> groupedPendingDocuments =
      {};
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // User selection related variables
  final RxString selectedUser = 'Select User'.obs;

  final RxList<String> userOptions = RxList<String>();

  Map<String, List<PendingDocumentsListModel>>
      get filteredGroupedPendingDocuments {
    final query = searchQuery.value;
    final bool shouldFilterByUser = appID == 6;

    return groupedPendingDocuments.map((key, value) {
      var filteredDocs = value.where((doc) {
        final matchesUser = shouldFilterByUser
            ? selectedUser.value == 'Select User' ||
                doc.userid.toLowerCase() == selectedUser.value.toLowerCase()
            : true;
        final matchesQuery = query.isEmpty ||
            doc.docnum.toString().contains(query) ||
            doc.lastuser.toString().contains(query);
        return matchesUser && matchesQuery;
      }).toList();

      filteredDocs
          .sort((a, b) => a.docnum.compareTo(b.docnum)); // Sort by docnum

      return MapEntry(key, filteredDocs);
    })
      ..removeWhere((key, value) => value.isEmpty);
  }

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    appID = arguments['AppID'];
    appName = arguments['AppName'];
    Debug.log('-----------------------------$appID');
    getDashboardAppList(appID);
    if (appID == 6 &&
        (employeeName.toLowerCase() == 'atif.sheikh' ||
            employeeName.toLowerCase() == 'tariq.mahmood')) {
      isDropDown = true;
      getSameLevelUsers();
    }
    super.onInit();
  }

  Future<void> getDashboardAppList(int? appId) async {
    String param = "userId=$employeeName&appId=$appId";
    isLoading(true);
    groupedPendingDocuments.clear();
    List<PendingDocumentsListModel>? responseList =
        await ApiFetch.getPendingDocsList(param);
    isLoading(false);
    if (responseList != null) {
      groupedPendingDocuments.clear(); // Clear previous data
      for (var document in responseList) {
        final lastUser = document.lastuser.toLowerCase();
        if (!groupedPendingDocuments.containsKey(lastUser)) {
          groupedPendingDocuments[lastUser] = [];
        }
        groupedPendingDocuments[lastUser]!.add(document);
      }

      // Sort each group's documents by docnum
      groupedPendingDocuments.forEach((key, value) {
        value.sort((a, b) => a.docnum.compareTo(b.docnum));
      });
    }
  }

  Future<void> getSameLevelUsers({int appId = 6, int level = 3}) async {
    String param = "appId=$appId&level=$level";
    isLoading(true);
    List<NextLevelUsersListModel>? responseList =
        await ApiFetch.getSameLevelUsers(param);

    List<String> users = ['Select User']; // Initialize with default value
    for (var user in responseList!) {
      users.add(user.username.toLowerCase());
      Debug.log(user.username);
    }
    userOptions.assignAll(users);

    isLoading(false);
  }

  void changeUser(String? newUser) {
    selectedUser.value = newUser!;
    // Trigger an update to apply the new filter
    searchQuery.refresh();
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
  }
}
