import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/toaster.dart';
import '../../../debug/debug_pointer.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';
import '../models/get_rowing_quality_garment_detial_model.dart';
import '../models/rowing_quality_fault_model.dart';

class AddInLineFaultsController extends GetxController {
  final RxList<RowingQualityPendingGarmentDetailListModel>rowingQualityPendingGarmentList = RxList<RowingQualityPendingGarmentDetailListModel>();
  final RxList<RowingQualityFaultListModel> faultsList = RxList<RowingQualityFaultListModel>();
  RxList<RowingQualityFaultListModel> selectedFaults = <RowingQualityFaultListModel>[].obs;
  final TextEditingController faultsController = TextEditingController();
  TextEditingController addFaultController = TextEditingController();
  List<Map<String, dynamic>> garmentFaults = List.generate(
    7,
    (index) => {'fault': '', 'quantity': 0.obs},
  );
  final TextEditingController remarksController = TextEditingController();
  bool isSelectedFault(RowingQualityFaultListModel fault) {
    return selectedFaults.contains(fault);
  }
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final RxString selectedFaultType = 'Minor'.obs;
  final RxBool buttonAction = RxBool(true);
  final RxBool isLoading = RxBool(true);
  RxInt totalFaultsAdded = 0.obs;
  String operator = '';
  String? machineCode;
  String? workOrder;
  String? operation;
  String? lineNo;
  int? formNo;
  RxBool isNoWork = false.obs;
  final List<String> faultType = [
    'Minor',
    'Major',
  ];

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    operator = arguments['Operator'];
    workOrder = arguments['W/O'];
    machineCode = arguments['M/C'];
    operation = arguments['Operation'];
    formNo = arguments['FormNo'];
    lineNo = arguments['LineNo'];
    Future.wait([
      // getRowingQualityPendingGarmentDetail(),
      getRowingQualityFaultList(),
    ]);
    super.onInit();
  }

  Future<void> getRowingQualityFaultList() async {
    isLoading(true);
    List<RowingQualityFaultListModel>? responseList =
        await ApiFetch.getRowingQualityFaultList();
    isLoading(false);
    if (responseList != null) {
      faultsList.assignAll(responseList);
    }
  }

  Future<void> saveNewFault() async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data = "FaultName=${addFaultController.text}";
    bool response = await ApiFetch.saveNewRowingFaultName(data);
    isLoading(false);
    Get.back();

    if (response) {
      Get.snackbar(
        "Successfully",
        "Your Fault added successfully.",
        snackPosition: SnackPosition.TOP,
      );

      await getRowingQualityFaultList();
    } else {
      Get.snackbar(
        "Alert!",
        "Failed to add the Fault.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> saveRowingQualityFaultDetail(garmentNumber) async {
    buttonAction(false);
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   buttonAction.value = true;
    //   return;
    // }
    List<RowingQualityFaultListModel> selectedFaultsWithCount = selectedFaults.where((fault) => fault.quantity.value > 0).toList();
    Debug.log('------------------------------------------------------------$formNo------------------------------------------------------');
    Map<String, dynamic> payload = {
      "masterform": formNo,
      "InspGarmentNo": garmentNumber,
      "InspectionDetailFaults":
          selectedFaultsWithCount.asMap().entries.map((entry) {
        RowingQualityFaultListModel fault = entry.value;

        return {
          "FormNoDefFk": fault.formNo,
          "FaultCount": fault.quantity.value,
          "FaultTypeCode": fault.formNoDefclsFk == 3
              ? selectedFaultType.value == 'Minor'
                  ? '2'
                  : '1'
              : fault.formNoDefclsFk
        };
      }).toList(),
    };

    Debug.log(payload);
    bool success = await ApiFetch.saveRowingQualityFaultDetail(payload);
    isLoading.value = false;
    buttonAction(true);
    if (success) {
      selectedFaults.removeWhere((fault) => fault.quantity.value > 0);
      Get.snackbar(
        "Successfully",
        "Rowing Quality Fault Add Successfully!.",
        snackPosition: SnackPosition.TOP,
      );

      Get.back();
    } else {
      Get.snackbar(
        "Alert!",
        "Rowing Quality Fault Add!.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Color calculateFlagColor(List<Map<String, dynamic>> garmentFaultDetails) {
    int totalFaults = garmentFaultDetails.fold<int>(0, (sum, details) {
      return sum + details['faultCount'] as int;
    });
    bool hasMajorFault = garmentFaultDetails.any((details) => details['type'] == 'Major');
    if (hasMajorFault) {
      return Colors.red;
    }
    bool hasTwoMinorFaults = garmentFaultDetails.where((details) => details['type'] == 'Minor').length >= 2;
    bool hasTwoMajorFaults = garmentFaultDetails.where((details) => details['type'] == 'Major' && details['faultCount'] >= 2).isNotEmpty;
    bool hasOneMinorAndOneMajorFault = garmentFaultDetails.where((details) => details['type'] == 'Minor' && details['faultCount'] == 1).isNotEmpty &&
        garmentFaultDetails.where((details) => details['type'] == 'Major' && details['faultCount'] == 1).isNotEmpty;

    if (hasTwoMinorFaults || hasTwoMajorFaults || hasOneMinorAndOneMajorFault) {
      return Colors.red;
    }

    bool hasMinorFault = garmentFaultDetails.any((details) => details['type'] == 'Minor');
    if (hasMinorFault) {
      return Colors.yellow;
    }
    if (totalFaults == 0) {
      return Colors.green;
    } else if (totalFaults == 1) {
      return Colors.yellow;
    } else {
      return Colors.transparent;
    }
  }
  void toggleFaultSelection(RowingQualityFaultListModel fault, bool select) {
    if (select && !selectedFaults.contains(fault)) {
      // Add to selected faults only if it's not already present
      fault.quantity.value = 1; // Set quantity to 1 when selected
      selectedFaults.add(fault); // Add to selected faults
    } else if (!select && fault.quantity.value == 1) {
      // Remove from selected faults only if it's already present and quantity is 1
      selectedFaults.remove(fault); // Remove from selected faults
    }
    update();
  }


  Future<void> saveInspectionFlagColor() async {
    buttonAction(false);
    const darkSilverColor = Color(0xFF707070);
    Map<String, dynamic> payload = {
      "flag":darkSilverColor.value.toRadixString(16).toUpperCase(),
      "FormNoRdimFk": formNo,
      "Remarks": remarksController.text,
      "CreatedBy": employeeName,
    };
    Debug.log(payload);

    bool success = await ApiFetch.saveRowingQualityInspectionFlag(payload);
    isLoading.value = false;
    buttonAction(true);

    if (success) {
      Toaster.showToast("Fault Flag Add Successfully!.");
      Get.offAllNamed(AppRoutes.inLineInspection);
    } else {
      Toaster.showToast("Fault Flag Not Add!.");
    }
  }

  void toggleSwitch(bool value) {
    isNoWork.value = value;
  }
}
