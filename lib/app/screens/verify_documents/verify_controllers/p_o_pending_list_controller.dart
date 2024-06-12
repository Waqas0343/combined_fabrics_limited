import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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

  final Map<String, List<PendingDocumentsListModel>> groupedPendingDocuments = {};
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  Map<String, List<PendingDocumentsListModel>> get filteredGroupedPendingDocuments {
    final query = searchQuery.value;
    final start = startDate.value;
    final end = endDate.value;

    return groupedPendingDocuments.map((key, value) {
      var filteredDocs = value.where((doc) {
        final matchesQuery = query.isEmpty ||
            doc.docnum.toString().contains(query) ||
            doc.lastuser.toString().contains(query);
        final matchesStartDate = start == null ||
            doc.createdDate.isAfter(start.subtract(const Duration(days: 1)));
        final matchesEndDate = end == null ||
            doc.createdDate.isBefore(end.add(const Duration(days: 1)));
        return matchesQuery && matchesStartDate && matchesEndDate;
      }).toList();
      filteredDocs.sort((a, b) => a.docnum.compareTo(b.docnum)); // Sort by docnum
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
    super.onInit();
  }

  Future<void> getDashboardAppList(int? appId) async {
    String param = "userId=$employeeName&appId=$appId";
    isLoading(true);
    groupedPendingDocuments.clear();
    List<PendingDocumentsListModel>? responseList = await ApiFetch.getPendingDocsList(param);
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

  Future<void> selectStartDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      startDate.value = selectedDate;
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      endDate.value = selectedDate;
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    searchController.clear();
    startDate.value = null;
    endDate.value = null;
  }
}
