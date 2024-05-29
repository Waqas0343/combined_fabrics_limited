import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../server/api_fetch.dart';
import '../models/key_report_model.dart';

class ViewKeyReportsController extends GetxController {
  final RxList<KeyReportListModel> keyReportsList = RxList<KeyReportListModel>();
  final TextEditingController searchController = TextEditingController();
  final RxBool hasSearchText = RxBool(false);
  final RxBool isLoading = RxBool(true);
  @override
  void onInit() {
    getKeyReports();
    super.onInit();
  }
  Future<void> getKeyReports({String? query}) async {
    String params = "KeyCode=${searchController.text}";
    isLoading(true);
    List<KeyReportListModel>? responseList = await ApiFetch.getKeyReports(params);
    isLoading(false);
    if (responseList != null) {
      keyReportsList.assignAll(responseList);
    }
  }
  Future<void> applyFilter() async {
    keyReportsList.clear();
    getKeyReports();
  }
}
