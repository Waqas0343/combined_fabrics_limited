import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../server/api_fetch.dart';
import '../../../../services/preferences.dart';
import '../../complaint_models/complaint_dashboard.dart';
import '../../complaint_models/complaint_status_model.dart';
import '../../complaint_models/get_department_complaint_model.dart';
import '../../complaint_models/get_department_model.dart';

class ReceivedComplaintController extends GetxController {
  final RxList<ComplaintStatusListModel> statusList = RxList<ComplaintStatusListModel>();
  final RxList<DepartmentListModel> departmentList = RxList<DepartmentListModel>();
  final RxList<DepartmentComplaintListModel> complaintList = RxList<DepartmentComplaintListModel>();
  Rx<DepartmentListModel?> selectedDepartment = Rx<DepartmentListModel?>(null);
  Rx<ComplaintStatusListModel?> selectedStatus = Rx<ComplaintStatusListModel?>(null);
  String employeeCode =Get.find<Preferences>().getString(Keys.employeeCode) ?? "Guest User";
  String hodCode =Get.find<Preferences>().getString(Keys.userId) ?? "Guest User";
  String deptCode =Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";
  String deptAdmin =Get.find<Preferences>().getString(Keys.departmentAdmin) ?? "Guest User";
  String cmpType = Get.find<Preferences>().getString(Keys.cmpType) ?? "CmpType";
  final TextEditingController complaintTextController = TextEditingController();
  final Rxn<DepartmentCount> dashboardDepartment = Rxn<DepartmentCount>();
  final RxBool hasSearchText = RxBool(false);
  final RxBool isLoading = RxBool(true);
  final RxBool _hasMore = RxBool(false);
  final RxBool hasMore = RxBool(true);
  var isExpanded = false.obs;
  int offset = 1;
  int sortBy = 4;
  bool sortDesc = true;
  int pageSize = 50;

  @override
  void onInit() {
    super.onInit();
    if (cmpType == "Admin" && Get.arguments != null && Get.arguments.containsKey('dashboardDepartment')) {
      dashboardDepartment.value = Get.arguments['dashboardDepartment'];
      Debug.log(dashboardDepartment.value);
    }
    Future.wait([
      getDepartment(),
      getStatus(),
    ]).then((_) {
      selectedDepartment.value = departmentList.isNotEmpty ? departmentList[0] : null;
      if (cmpType == "Launcher") {
        selectedStatus.value = statusList.isNotEmpty ? statusList[2] : null;
      } else if (cmpType == "Reciever") {
        selectedStatus.value = statusList.isNotEmpty ? statusList[1] : null;
      } else {
        selectedStatus.value = statusList.isNotEmpty ? statusList[1] : null;
      }
      getComplaintList();
    });
  }


  Future<void> getDepartment() async {
    String params = cmpType != "Admin"
        ? "UserId=$employeeCode"
        : "UserId=${dashboardDepartment.value?.deptCode ?? deptCode}";
    isLoading(true);
    List<DepartmentListModel>? responseList = await ApiFetch.getDepartments(params);
    isLoading(false);
    if (responseList == null || responseList.isEmpty) {
      params = cmpType != "Admin"
          ? "UserId=$hodCode"
          : "UserId=${dashboardDepartment.value?.deptName ?? 'Board Of Directors'}";
      isLoading(true);
      responseList = await ApiFetch.getDepartments(params);
      isLoading(false);
    }
    if (responseList != null) {
      departmentList.assignAll(responseList);
    }
  }

  Future<void> getStatus() async {
    String cmpType = Get.find<Preferences>().getString(Keys.cmpType) ?? "CmpType";
    String replaceValue;
    if (cmpType == "Launcher") {
      replaceValue = "LaunchedComplaint";
    } else if (cmpType == "Reciever") {
      replaceValue = "RecievedComplaint";
    } else {
      replaceValue = "Admin";
    }
    String params = "Status=$replaceValue";
    isLoading(true);
    List<ComplaintStatusListModel>? responseList = await ApiFetch.getComplaintStatusList(params);
    isLoading(false);
    if (responseList != null) {
      statusList.assignAll(responseList);
    }
  }

  Future<void> getComplaintList() async {
    isLoading(true);
    if (cmpType != "Admin"
        ? (selectedDepartment.value != null && selectedStatus.value != null)
        : (dashboardDepartment.value?.deptName != null && selectedStatus.value != null)) {
      String cmpType = Get.find<Preferences>().getString(Keys.cmpType) ?? "CmpType";
      String replaceValue;
      if (cmpType == "Launcher") {
        replaceValue = "LaunchedComplaint";
      } else if (cmpType == "Reciever") {
        replaceValue = "RecievedComplaint";
      } else {
        replaceValue = "Admin";
      }

      Map<String, dynamic> queryParams = {
        "PageNo": offset,
        "PageSize": pageSize,
        "Query": complaintTextController.text,
        "SortBy": sortBy,
        "SortDesc": sortDesc,
        "Status": selectedStatus.value?.status,
        "ToDeptCode": cmpType != "Admin"
            ? selectedDepartment.value?.deptCode ?? deptCode
            : dashboardDepartment.value?.deptCode ?? deptCode,
        "UserId": replaceValue,
      };
      Debug.log(queryParams);
      List<DepartmentComplaintListModel>? responseList = await ApiFetch.getDepartmentComplaintList(queryParams);
      isLoading(false);
      if (responseList == null || responseList.isEmpty) {
        _hasMore(false);
        return;
      }
      if (offset == 1) {
        complaintList.clear();
      }
      complaintList.addAll(responseList);
      if (responseList.length < pageSize) {
        _hasMore(false);
      } else {
        _hasMore(true);
        offset++;
      }
    }
  }

  void toggleExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  Future<void> applyFilter() async {
    offset = 1;
    complaintList.clear();
    getComplaintList();
  }
}
