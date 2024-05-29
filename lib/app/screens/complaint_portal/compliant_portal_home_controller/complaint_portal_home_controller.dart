import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../complaint_models/complaint_chart_model.dart';
import '../complaint_models/complaint_dashboard.dart';

class ComplaintPortalHomeController extends GetxController {
  final RxList<ComplaintChartListModel> chartData = RxList<ComplaintChartListModel>();
  final Rx<ComplaintDashBoardDataModel?> complaintDashboard = Rx<ComplaintDashBoardDataModel?>(null);
  final RxBool _isLoadingComplainFeature = RxBool(false);
  RxList<ChartData> compaintOverViewData = RxList<ChartData>();
  final RxBool isLoading = RxBool(true);
  String departmentCode = Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";

  @override
  void onInit() {
    getComplaintDashboardData();
    super.onInit();
  }

  Future<void> getComplaintDashboardData() async {
    try {
      isLoading(true);
      final data = await ApiFetch.getComplaintDashBoard();
      isLoading(false);
      if (data != null) {
        complaintDashboard.value = data;
      }
    } catch (e, s) {
      Debug.log("Error fetching complaint data: $e");
      Debug.log("Stack trace: $s");
    }
  }

  Future<void> getComplaintChart() async {
    String params = "DeptCode=$departmentCode";
    isLoading(true);
    List<ComplaintChartListModel>? responseList = await ApiFetch.getComplaintChartData(params);
    isLoading(false);
    if (responseList == null) {
      return;
    }
    compaintOverViewData.clear();
    for (var complaint in responseList) {
      compaintOverViewData.add(
        ChartData(complaint.status, complaint.count,
            _getStatusColor(complaint.status)),
      );
    }
  }

  Color? _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.red;
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
        return const Color(0xff80cfbd);
      default:
        return null;
    }
  }

  List<DepartmentCount> get departmentCounts => complaintDashboard.value?.departmentCount ?? [];

  bool get isLoadingComplaint => _isLoadingComplainFeature.value;
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final int y;
  final Color? color;
}
