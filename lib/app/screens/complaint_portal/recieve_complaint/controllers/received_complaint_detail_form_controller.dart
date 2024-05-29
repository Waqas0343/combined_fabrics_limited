import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../server/api_fetch.dart';
import '../../../../services/preferences.dart';
import '../../complaint_models/complaint_assignee_model.dart';
import '../../complaint_models/complaint_button_model.dart';
import '../../complaint_models/get_complaint_by_department_number.dart';
import '../../complaint_models/get_demand_model.dart';
import '../../complaint_models/get_department_complaint_model.dart';
import '../../complaint_models/get_employee_by_department_model.dart';
import '../../complaint_models/get_to_department_model.dart';

class ReceivedComplaintDetailFormController extends GetxController {
  final TextEditingController planStartDateController = TextEditingController();
  final TextEditingController planEndDateController = TextEditingController();
  final TextEditingController actualStartDateController =
      TextEditingController();
  final TextEditingController actualEndDateController = TextEditingController();
  final RxList<ToDepartmentListModel> toDepartmentList =
      RxList<ToDepartmentListModel>();
  final Rxn<ToDepartmentListModel?> selectedToDepartment =
      Rxn<ToDepartmentListModel?>();
  final TextEditingController textarea = TextEditingController();
  final Rxn<DepartmentComplaintListModel> complaintModel =
      Rxn<DepartmentComplaintListModel>();
  final RxList<EmployeeByDepartmentListModel> employeeList =
      RxList<EmployeeByDepartmentListModel>();
  final RxList<ComplaintAssigneeListModel> assigneePerson =
      RxList<ComplaintAssigneeListModel>();
  final Rxn<EmployeeByDepartmentListModel?> selectEmp =
      Rxn<EmployeeByDepartmentListModel?>();
  final Rxn<GetComplaintByNoDataModel?> complaintData =
      Rxn<GetComplaintByNoDataModel?>();
  final RxList<DemandListModel> demandList = RxList<DemandListModel>();
  final Color selectedIconColor = Colors.blue;
  final Color selectedLabelColor = Colors.blue;
  final Rx<int> currentIndex = 0.obs;
  final RxBool isLoading = RxBool(true);
  String name = Get.find<Preferences>().getString(Keys.userId) ?? "Guest User";
  String cmpType = Get.find<Preferences>().getString(Keys.cmpType) ?? "CmpType";
  RxBool? isVerified = RxBool(false);
  RxBool? isResolved = RxBool(false);
  RxBool? isClose = RxBool(false);
  RxBool? isRejected = RxBool(false);
  final TextEditingController demandNoController = TextEditingController();
  final TextEditingController demandSerialTextController = TextEditingController();
  final RxBool hasSearchText = RxBool(false);
  int activeStep = 0;
  String? complaintDecider = '';

  @override
  void onInit() {
    complaintModel.value = Get.arguments['ComplaintModel'];
    complaintDecider = Get.arguments['ComplaintDecider'];
    Debug.log(complaintDecider);
    textarea.text = complaintModel.value!.detail;

    Future.wait([
      getToDepartment(),
      getEmployeeByDept(),
      getAssigneePerson(),
      changeComplaintStatus(),
      getComplaintButtonAction(),
      getComplaintDemand(),
      getComplaintByCMNO()
    ]);
    super.onInit();
  }

  Future<void> getToDepartment() async {
    isLoading(true);
    List<ToDepartmentListModel>? responseList =
        await ApiFetch.getToDepartments();
    isLoading(false);
    if (responseList != null) {
      toDepartmentList.assignAll(responseList);
    }
  }

  Future<void> getEmployeeByDept() async {
    String params = "DeptCode=${complaintModel.value?.toDeptCode}";
    isLoading(true);
    List<EmployeeByDepartmentListModel>? responseList =
        await ApiFetch.getEmployeeByDept(params);
    isLoading(false);
    if (responseList != null) {
      employeeList.assignAll(responseList);
    }
  }

  Future<void> getAssigneePerson() async {
    String params = "CMPNO=${complaintModel.value?.cmpNo}";
    isLoading(true);
    List<ComplaintAssigneeListModel>? responseList =
        await ApiFetch.getAssigneePerson(params);
    isLoading(false);
    if (responseList != null) {
      assigneePerson.assignAll(responseList);
    }
  }

  Future<void> removeAssignee(ComplaintAssigneeListModel assigneeModel) async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "AssignedPerson": assigneeModel.employeeCode,
    };

    bool success = await ApiFetch.removeAssignee(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Employee Removed Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      assigneePerson.remove(assigneeModel); // Remove the employee from the list
    } else {
      Get.snackbar(
        "Message",
        'Failed to Remove Employee!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> addAssignee(
      EmployeeByDepartmentListModel selectedEmployee) async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "UserId": name, // Assuming employeeCode is already defined
      "AssignedPerson": selectedEmployee.employeeCode,
    };

    bool success = await ApiFetch.addAssignee(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Employee Added Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      await getAssigneePerson(); // Call the function to update the list
    } else {
      Get.snackbar(
        "Message",
        'Failed to Add Employee!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> changeDepartment(ToDepartmentListModel selectedEmployee) async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "StatusBy": name,
      "DeptCode": selectedToDepartment.value?.departmentCode,
    };

    bool success = await ApiFetch.changeDepartment(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Change Department Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      await getAssigneePerson(); // Call the function to update the list
    } else {
      Get.snackbar(
        "Message",
        'Failed to Department Change!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> setPlanDate() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }
    String selectedPlanStartDate = planStartDateController.text.isNotEmpty
        ? planStartDateController.text.toString()
        : "";

    String selectedPlanEndDate =
        planEndDateController.text.isNotEmpty ? planEndDateController.text : "";

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "StartDate": selectedPlanStartDate.toString(),
      "EndDate": selectedPlanEndDate.toString(),
      "UserId": name,
    };

    bool success = await ApiFetch.setPlanDate(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Plan Date Added Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Failed to Add Plan Date!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> setActualDate() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }
    String selectedActualStartDate = actualStartDateController.text.isNotEmpty
        ? actualStartDateController.text
        : " ";

    String selectedActualEndDate = actualEndDateController.text.isNotEmpty
        ? actualEndDateController.text
        : "";
    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "StartDate": selectedActualStartDate.toString(),
      "EndDate": selectedActualEndDate.toString(),
      "UserId": name,
    };

    bool success = await ApiFetch.setActualDate(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Actual Date Add Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      complaintModel.refresh();
      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Failed to Add Actual Date!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat().format(picked);
      controller.text =
          formattedDate; // Update the text field with the formatted date
    }
  }

  Future<void> closeComplaint() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "UserId": name,
    };

    bool success = await ApiFetch.closeComplaint(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Complaint Close Successfully!',
        snackPosition: SnackPosition.TOP,
      );

      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Complaint Id Not Found!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> resolveComplaint() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "UserId": name,
    };

    bool success = await ApiFetch.resolveComplaint(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Complaint Resolve Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Complaint Id Not Found!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> complaintReject() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "UserId": name,
    };

    bool success = await ApiFetch.complaintReject(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Complaint Reject Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Complaint Id Not Found!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> complaintVerified() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    Map<String, dynamic> data = {
      "CmpNo": complaintModel.value?.cmpNo,
      "StatusBy": name,
    };

    bool success = await ApiFetch.complaintVerify(data);
    if (success) {
      Get.snackbar(
        "Message",
        'Complaint Verify Successfully!',
        snackPosition: SnackPosition.TOP,
      );
      getComplaintByCMNO();
    } else {
      Get.snackbar(
        "Message",
        'Complaint Id Not Found!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> changeComplaintStatus() async {
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   return;
    // }

    if (complaintModel.value?.statusId == 1) {
      Map<String, dynamic> data = {
        "CmpNo": complaintModel.value?.cmpNo,
        "DeptCode": selectedToDepartment.value?.departmentCode,
        "UserId": name,
      };

      bool success = await ApiFetch.complaintVerify(data);
      if (success) {
        Get.snackbar(
          "Message",
          'Complaint Status Acknowledged!',
          snackPosition: SnackPosition.TOP,
        );
        getComplaintByCMNO();
      } else {
        Get.snackbar(
          "Message",
          'Complaint Id Not Found!',
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> getComplaintButtonAction() async {
    String cmpType =
        Get.find<Preferences>().getString(Keys.cmpType) ?? "CmpType";
    String params = "CmpNo=${complaintModel.value?.cmpNo}&CmpType=$cmpType";
    isLoading(true);
    ComplaintButtonData? buttonData = await ApiFetch.getComplaintButtonAction(params);
    isLoading(false);
    if (buttonData != null) {
      isVerified?.value = buttonData.verified ?? false;
      isResolved?.value = buttonData.resovled ?? false;
      isClose?.value = buttonData.closed ?? false;
      isRejected?.value = buttonData.rejected ?? false;

      Debug.log(isVerified?.value);
      Debug.log(isResolved?.value);
      Debug.log(isClose?.value);
      Debug.log(isRejected?.value);
    } else {
      Get.snackbar(
        "Message",
        'Failed to fetch data from the API!',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> getComplaintByCMNO() async {
    isLoading.value = true;
    String params = "CMPNO=${complaintModel.value?.cmpNo}";
    try {
      GetComplaintByNoDataModel? response =
          await ApiFetch.getComplaintByCMPNO(params);
      isLoading.value = false;
      if (response != null) {
        complaintData.value = response;
      } else {
        complaintData.value = null;
        Get.snackbar(
          "Message",
          'Complaint Data Found Successfully',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (error) {
      isLoading.value = false;
      Debug.log('Error fetching complaint: $error');
      Get.snackbar(
        "Message",
        'Error fetching complaint data',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> getComplaintDemand() async {
    String params =
        "DemandNo=${complaintModel.value?.demandNo ?? demandNoController.text}"
        "&Srno=${complaintModel.value?.demandSrno ?? demandSerialTextController.text}";
    isLoading(true);
    List<DemandListModel>? responseList =
        await ApiFetch.getComplaintDemand(params);
    isLoading(false);
    if (responseList != null && responseList.isNotEmpty) {
      demandList.assignAll(responseList);
      String? demand = responseList[0].demandNo.toString();
      String? pr = responseList[0].pr;
      String? po = responseList[0].po;
      String? igp = responseList[0].igp;
      String? grn = responseList[0].grn;
      String? issueNo = responseList[0].issueNo;
      String? serialNo = responseList[0].srNo.toString();

      String? demandType;

      if (demand.isNotEmpty && pr.isEmpty) {
        demandType = "PR";
      } else if (demand.isNotEmpty && pr.isNotEmpty && po.isEmpty) {
        demandType = "PO";
      } else if (demand.isNotEmpty &&
          pr.isNotEmpty &&
          po.isNotEmpty &&
          igp.isEmpty) {
        demandType = "IGP";
      } else if (demand.isNotEmpty &&
          pr.isNotEmpty &&
          po.isNotEmpty &&
          igp.isNotEmpty &&
          grn.isEmpty) {
        demandType = "GRN";
      } else if (demand.isNotEmpty &&
          pr.isNotEmpty &&
          po.isNotEmpty &&
          igp.isNotEmpty &&
          grn.isNotEmpty &&
          issueNo.isEmpty) {
        demandType = "Isssu/Transfer";
      }

      if (demand.isNotEmpty) {
        Map<String, dynamic> dataParams = {
          "CmpNo": complaintModel.value?.cmpNo,
          "DemandNo": demand,
          "DemandSrno": serialNo,
        };
        await ApiFetch.addComplaintDemand(dataParams);
      }

      Map<String, dynamic> data = {
        "CmpNo": complaintModel.value?.cmpNo,
        "DemandType": demandType,
        "UserId": name,
      };
      bool success = await ApiFetch.changeComplaintDemandStatus(data);
      if (success) {
        Get.snackbar(
          "Message",
          'Complaint Status Acknowledged!',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Message",
          'Complaint Id Not Found!',
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  Future<void> applyFilter() async {
    demandList.clear();
    getComplaintDemand();
  }

  @override
  void onClose() {
    planStartDateController.dispose();
    planEndDateController.dispose();
    actualStartDateController.dispose();
    actualEndDateController.dispose();
    super.onClose();
  }
}

class TableRowData {
  final String id;
  final String empName;

  TableRowData({required this.id, required this.empName});
}
