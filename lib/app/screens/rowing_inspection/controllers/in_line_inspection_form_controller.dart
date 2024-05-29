import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/helpers/toaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';
import '../models/rowing_quality_operator_operation_model.dart';

class InLineInspectionFormController extends GetxController {
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedOperator = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedWorkOrder = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final RxList<RowingQualityOperatorOperationListModel> operationList = RxList<RowingQualityOperatorOperationListModel>();
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final TextEditingController inLineInspectionController = TextEditingController();
  final TextEditingController selectedOperatorController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  DateTime dateTime = DateTime.now();
  final RxString selectedRound = 'Round 1'.obs;
  final RxString selectedSection = 'Section 1'.obs;
  final RxString selectedLinSection = 'L15'.obs;
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = RxBool(true);
  final List<String> rounds = [
    'Round 1',
    'Round 2',
    'Round 3',
    'Round 4',
    'Round 5',
    'Round 6',
  ];
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  RowingQualityInlineInspectionFormListModel? selected;

  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    final arguments = Get.arguments as Map<String, dynamic>?;
    if(arguments==null){
      getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    }
    if (arguments != null) {
      if (arguments.containsKey('LineNo')) {
        selectedLinSection.value = arguments['LineNo'];
        getRowingQualityInlineInspectionFormList(selectedLinSection.value);
      }
    }
    super.onInit();
  }

  Future<void> getRowingQualityInlineInspectionFormList(String selectedValue) async {
    String param = "unit=$selectedValue";
    isLoading(true);
    List<RowingQualityInlineInspectionFormListModel>? responseList = await ApiFetch.getRowingQualityInlineInspectionFormList(param);
    isLoading(false);
    if (responseList != null) {
      workerAndOrderList.assignAll(responseList);
    }
  }

  Future<void> getRowingQualityOperationList(String selectedWorkerId) async {
    isLoading(true);
    String params = "machineID=$selectedWorkerId";

    try {
      List<RowingQualityOperatorOperationListModel>? responseList =
          await ApiFetch.getRowingQualityOperationList(params);
      isLoading(false);
      if (responseList != null) {
        operationList.assignAll(responseList);
      }
    } catch (e) {
      Toaster.showToast("Error fetching RowingQualityOperationList");

      isLoading(false);
    }
  }

  Future<void> saveInspectionFormData(int selectedIndex) async {
    buttonAction(false);
    int selectedRoundValue =
    int.parse(selectedRound.replaceAll(RegExp(r'[^0-9]'), ''));
    int selectedLine =
    int.parse(selectedLinSection.replaceAll(RegExp(r'[^0-9]'), ''));

    RowingQualityOperatorOperationListModel? selectedOperation =
    operationList.elementAt(selectedIndex);

    Map<String, dynamic> payload = {
      "StitchInspectionType": selectedSection.value,
      "LineNo": selectedLine,
      "RoundNo": selectedRoundValue,
      "EmpOperatorCode": selectedOperation.workerId,
      "WoNumber": selectedOperation.orderId,
      "OperationCode": selectedOperation.operationId,
      "MachineCode": selectedOperation.machineId,
      "BundleNo": 0,
      "GarmentsToInspect": 7,
      "CreatedBy": employeeName,
    };

    Debug.log(payload);
    Map<String, dynamic>? response = await ApiFetch.saveRowingQualityDetail(payload);
    isLoading.value = false;
    buttonAction(true);
    if (response != null && response["Status"] == true) {
      Toaster.showToast("Information Save Successfully!.");
      var returnData = response["ReturnData"];
      Get.toNamed(
        AppRoutes.addInLineInspectionFault,
        arguments: {
          'LineNo': selectedLinSection.value,
          'Operator': selectedOperation.workerName,
          'W/O': selectedWorkOrder.value?.orderId.toString(),
          'M/C': selectedOperation.machineId.toString(),
          'Operation': selectedOperation.operationDescription,
          'FormNo': returnData,
        },
      );
    } else {
      Toaster.showToast("Information Not Saved");
    }
  }


  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(minutes: 10),
      ),
    );

    if (date != null) {
      dateController.text = dateFormat.format(date);
      dateTime = date;
    }
  }
}
