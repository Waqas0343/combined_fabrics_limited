import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_bundle_detail_model.dart';
import '../models/rowing_quality_inline_inspection_form_model.dart';

class RowingQualityEndLineController extends GetxController {
  final RxList<RowingQualityInlineInspectionFormListModel> workerAndOrderList = RxList<RowingQualityInlineInspectionFormListModel>();
  final Rxn<RowingQualityInlineInspectionFormListModel?> selectedOperator = Rxn<RowingQualityInlineInspectionFormListModel?>();
  final Rxn<RowingQualityBundleListModel?> selectedBundle = Rxn<RowingQualityBundleListModel?>();
  final RxList<RowingQualityBundleListModel> bundleList = RxList<RowingQualityBundleListModel>();
  String employeeDepartmentCode = Get.find<Preferences>().getString(Keys.departmentCode) ?? "";
  final TextEditingController selectedWorkOrderController = TextEditingController();
  final TextEditingController bundleNoController = TextEditingController();
  final TextEditingController bundleQtyController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  RxString selectedRadioValue = 'QMP'.obs;
  List<String> inspectionType = ["EndLine", "QMP"];
  final RxBool buttonAction = RxBool(true);
  DateTime dateTime = DateTime.now();
  final RxBool isLoading = RxBool(true);
  RowingQualityInlineInspectionFormListModel? selected;
  RowingQualityBundleListModel? selectedB;
  final RxString selectedLinSection = 'L15'.obs;
  final List<String> lineSectionName = [
    'L5',
    'L12',
    'L15',
    'L25',
  ];
  RxBool showButton = false.obs;
  @override
  void onInit() {
    dateController.text = dateFormat.format(dateTime);
    final arguments = Get.arguments as Map<String, dynamic>?;
    if(arguments==null){
      getRowingQualityInlineInspectionFormList(selectedLinSection.value);
    }
    if (arguments != null) {
      if (arguments.containsKey('W/O') && arguments.containsKey('LineNo')) {
        selectedWorkOrderController.text = arguments['W/O'];
        selectedLinSection.value = arguments['LineNo'];
        getRowingQualityInlineInspectionFormList(selectedLinSection.value);
        getRowingQualityBundleDetailList(selectedWorkOrderController.text);
      }
    }
    super.onInit();
  }

  Future<void> getRowingQualityInlineInspectionFormList(
      String selectedValue) async {
    String param = "unit=$selectedValue";
    isLoading(true);
    List<RowingQualityInlineInspectionFormListModel>? responseList = await ApiFetch.getRowingQualityInlineInspectionFormList(param);
    isLoading(false);
    if (responseList != null) {
      workerAndOrderList.assignAll(responseList);
    }
  }

  Future<void> getRowingQualityBundleDetailList(String selectedWorkerId) async {
    isLoading(true);
    String params = "workorder=$selectedWorkerId&unit=${selectedLinSection.value}";

    try {
      List<RowingQualityBundleListModel>? responseList =
          await ApiFetch.getRowingQualityBundleDetail(params);
      isLoading(false);
      if (responseList != null) {
        bundleList.assignAll(responseList);
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        'No Bundle Exist For This',
        snackPosition: SnackPosition.BOTTOM,
      );

      isLoading(false);
    }
  }

  Future<void> saveInspectionFormData() async {
    buttonAction(false);
    int inspectionType;
    if (selectedRadioValue == 'QMP') {
      inspectionType = 3;
    } else {
      inspectionType = 2;
    }
    int selectedLine = int.parse(selectedLinSection.replaceAll(RegExp(r'[^0-9]'), ''));
    Map<String, dynamic> payload = {
      "LineNo": selectedLine,
      "WoNumber": selectedOperator.value?.orderDescription ?? selectedWorkOrderController.text,
      "EndLineNo": inspectionType,
      "BundleNo": bundleNoController.text,
      "BundleQty": bundleQtyController.text,
      "CreatedBy": employeeName,
    };

    Debug.log(payload);
    Map<String, dynamic>? response = await ApiFetch.saveRowingQualityEndLineMasterForm(payload);
    isLoading.value = false;
    buttonAction(true);
    if (response != null && response["Status"] == true) {
      Get.snackbar(
        "Message",
        'Information Save Successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
      var returnData = response["ReturnData"];
      Get.toNamed(AppRoutes.endLineCheckGarmentScreen, arguments: {
        'LineNo': selectedLinSection.value,
        'W/O': selectedWorkOrderController.text,
        'EndLine': selectedRadioValue.value,
        'Bundle#': bundleNoController.text,
        'B Qty': bundleQtyController.text,
        'FormNo': returnData,
      });
      Debug.log('---------------------------------------Send ${selectedRadioValue.value}');
    } else {
      Get.snackbar(
        "ALERT!",
        'Information Not Save Successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectOption(String value) {
    selectedRadioValue.value = value;
  }
}
