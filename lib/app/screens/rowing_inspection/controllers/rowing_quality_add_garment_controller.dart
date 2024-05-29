import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../models/rowing_quality_all_faults_model.dart';
import '../models/rowing_quality_end_line_total_pcs_inspect_model.dart';
import '../models/rowing_quality_operation_model.dart';

class AddEndLineGarmentFaultController extends GetxController {
  final RxList<RowingQualityOperationListModel> operationList = RxList<RowingQualityOperationListModel>();
  final RxList<RowingQualityEndLineTotalPcsInspectListModel> inspectedPcsList = RxList<RowingQualityEndLineTotalPcsInspectListModel>();
  RxList<RowingQualityAllFaultsListModel> selectedFaults = <RowingQualityAllFaultsListModel>[].obs;
  RxList<RowingQualityOperationListModel> selectedOperation = <RowingQualityOperationListModel>[].obs;
  final RxList<RowingQualityAllFaultsListModel> faultsList = RxList<RowingQualityAllFaultsListModel>();
  final TextEditingController faultsController = TextEditingController();
  final TextEditingController operationController = TextEditingController();
  final RxString selectedFaultType = 'Minor'.obs;
  final RxBool buttonAction = RxBool(true);
  final RxBool isLoading = RxBool(true);
  RxInt totalFaultsAdded = 0.obs;
  final List<String> faultType = [
    'Minor',
    'Major',
  ];

  final RxInt currentResult = 0.obs;
  RxInt result = 0.obs;
  PageController pageController = PageController();

  bool isSelectedFault(RowingQualityAllFaultsListModel fault) {
    return selectedFaults.contains(fault);
  }

  bool isSelectedOperation(RowingQualityOperationListModel operationListModel) {
    return selectedOperation.contains(operationListModel);
  }

  late List<Map<String, dynamic>> garmentFaults;

  TextEditingController lineNoController = TextEditingController();
  TextEditingController bundleController = TextEditingController();
  TextEditingController bundleQtyController = TextEditingController();
  TextEditingController workOrderController = TextEditingController();
  TextEditingController endLineController = TextEditingController();
  int? formNo;

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;
    lineNoController.text = arguments['LineNo'];
    workOrderController.text = arguments['W/O'];
    bundleController.text = arguments['Bundle#']; // Assuming 'Bundle#' is the correct key
    bundleQtyController.text = arguments['B Qty'];
    endLineController.text = arguments['EndLine'];
    formNo = arguments['FormNo'];

    Debug.log("-------------------------------------------------------$formNo-------------------------------------------------------------");
    getRowingQualityFaultList();
    initializeGarmentFaults();
    getRowingQualityOperation();
    getRowingEndLineTotalPcsInspectList();
    super.onInit();
  }

  void initializeGarmentFaults() {
    int numberOfGarments = int.tryParse(bundleQtyController.text) ?? 0;
    garmentFaults = List.generate(
      numberOfGarments,
      (index) => {'fault': '', 'quantity': 1.obs},
    );
  }

  Future<void> getRowingQualityFaultList() async {
    isLoading(true);
    List<RowingQualityAllFaultsListModel>? responseList = await ApiFetch.getRowingQualityAllFaultList();
    isLoading(false);
    if (responseList != null) {
      faultsList.assignAll(responseList);
    }
  }


  Future<void> getRowingEndLineTotalPcsInspectList() async {
    isLoading(true);
    String data = "Workorder=${workOrderController.text}";
    isLoading(true);
    operationList.clear();
    List<RowingQualityEndLineTotalPcsInspectListModel>? responseList = await ApiFetch.getRowingEndLineTotalPcsInspect(data);
    isLoading(false);
    if (responseList != null) {
      inspectedPcsList.assignAll(responseList);
    }
  }



  Future<void> saveRowingQualityFaultDetail(garmentNumber) async {
    buttonAction(false);
    List<RowingQualityAllFaultsListModel> selectedFaultsWithCount =
    selectedFaults.where((fault) => fault.quantity.value > 0).toList();
    String selectedOperationNames =
    selectedOperation.map((op) => op.operationname).join(', ');
    String selectedOperationCode =
    selectedOperation.map((op) => op.operationcode).join(', ');
    Map<String, dynamic> payload = {
      "masterform": formNo,
      "InspGarmentNo": garmentNumber,
      "InspectionDetailFaults": selectedFaultsWithCount.asMap().entries.map((entry) {
        RowingQualityAllFaultsListModel fault = entry.value;
        return {
          "FormNoDefFk": fault.formNo,
          "FaultCount": fault.quantity.value,
          "FaultTypeCode": fault.formNoDefclsFk == 3
              ? selectedFaultType.value == 'Minor'
              ? '2'
              : '1'
              : fault.formNoDefclsFk,
          "oprtionCode": selectedOperationCode,
          "OprationName": selectedOperationNames, // Use the selected operation names here
        };
      }).toList(),
    };

    bool success = await ApiFetch.saveRowingQualityEndLineGarmentFault(payload);
    isLoading.value = false;
    buttonAction(true);
    if (success) {
      // Clear fault quantity and uncheck checkboxes
      selectedFaults.forEach((fault) {
        fault.quantity.value = 0;
      });

      selectedOperation.clear();
      selectedFaults.clear();
      operationController.clear();
      getRowingQualityOperation();
      getRowingEndLineTotalPcsInspectList();

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


  Future<void> getRowingQualityOperation() async {
    isLoading(true);
    String data = "Workorder=${workOrderController.text}";
    isLoading(true);
    operationList.clear();
    List<RowingQualityOperationListModel>? responseList = await ApiFetch.getRowingOperationList(data);
    isLoading(false);
    if (responseList != null) {
      operationList.assignAll(responseList);
    }
  }
  Future<void> rowingQualitySkipInspection() async {
    buttonAction(false);
    String params = "formNo=$formNo";
    bool success = await ApiFetch.rowingQualitySkipGarmentInspection(params);
    isLoading.value = false;
    buttonAction(true);
    if (success) {
      Get.snackbar(
        "Successfully",
        "Garment Inspection Skip Successfully!.",
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed(
        AppRoutes.endLineInspection,
          arguments: {
            'W/O': workOrderController.text,
          });
    } else {
      Get.snackbar(
        "Alert!",
        "Garment Inspection Not Skiped!.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void toggleFaultSelection(RowingQualityAllFaultsListModel fault, bool select) {
    if (select && !selectedFaults.contains(fault)) {
      fault.quantity.value = 1;
      selectedFaults.add(fault);
    } else if (!select && fault.quantity.value == 1) {
      selectedFaults.remove(fault);
    }
    update();
  }


  void toggleOperationSelection(RowingQualityOperationListModel operationListModel) {
    if (selectedOperation.contains(operationListModel)) {
      selectedOperation.remove(operationListModel);
    } else {
      selectedOperation.add(operationListModel);
    }
    update();
  }
}
