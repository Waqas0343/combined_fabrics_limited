import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../debug/debug_pointer.dart';
import '../../../../routes/app_routes.dart';
import '../../../../server/api_fetch.dart';
import '../../../../services/preferences.dart';
import '../../../dialogs/dialog.dart';
import '../../complaint_models/get_department_model.dart';
import '../../complaint_models/get_long_name_model.dart';
import '../../complaint_models/get_short_long_name_model.dart';
import '../../complaint_models/get_short_name_assetcode_model.dart';
import '../../complaint_models/get_to_department_model.dart';
import 'dart:io';

class NewComplaintController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxList<DepartmentListModel> departmentList = RxList<DepartmentListModel>();
  final RxList<ShortNameAssetCodeListModel> shortNameList = RxList<ShortNameAssetCodeListModel>();
  final RxList<LongNameModelList> longNameList = RxList<LongNameModelList>();
  final Rxn<ShortNameAssetCodeListModel?> selectedShort = Rxn<ShortNameAssetCodeListModel?>();
  final RxList<ToDepartmentListModel> toDepartmentList = RxList<ToDepartmentListModel>();
  final Rxn<ToDepartmentListModel?> selectedToDepartment = Rxn<ToDepartmentListModel?>();
  RxList<AssetCodeModel> assetCodeList = <AssetCodeModel>[].obs;
  TextEditingController assetCodeController = TextEditingController();
  final TextEditingController textarea = TextEditingController();
  Rx<DepartmentListModel?> selectedDepartment = Rx<DepartmentListModel?>(null);
  Rx<LongNameModelList?> selectedLong = Rx<LongNameModelList?>(null);
  final RxBool isLoading = RxBool(true);
  RxString selectedRadioValue = ''.obs;
  String hodCode = Get.find<Preferences>().getString(Keys.userId) ?? " ";
  String employeeCode = Get.find<Preferences>().getString(Keys.userId) ?? " ";
  final TextEditingController selectedLongTextController = TextEditingController();
  final TextEditingController selectedShortTextController = TextEditingController();
  final Debouncer debounce = Debouncer(delay: const Duration(seconds: 40));
  final RxList<TableRowData> tableDataList = <TableRowData>[].obs;
  List<Color> rowColors = [
    const Color(0xffe5f7f1),
    Colors.white,
  ];
  final picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<String?> selectedImageBase64 = Rx<String?>(null);
  final RxBool buttonAction = RxBool(true);

  @override
  void onInit() {
    super.onInit();
    Future.wait([getDepartment(), getToDepartment()]).then((_) {
      selectedDepartment.value = departmentList.isNotEmpty ? departmentList[0] : null;
      getShortNameAssetCode(selectedDepartment.value?.deptCode);
      getLongNameAssetCode(selectedDepartment.value?.deptCode);
    });
  }

  Future<void> getDepartment() async {
    String params = "UserId=$employeeCode";
    isLoading(true);
    List<DepartmentListModel>? responseList =
        await ApiFetch.getDepartments(params);
    isLoading(false);
    if (responseList == null || responseList.isEmpty) {
      params = "UserId=$hodCode";
      isLoading(true);
      responseList = await ApiFetch.getDepartments(params);
      isLoading(false);
    }
    if (responseList != null) {
      departmentList.assignAll(responseList);
    }
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

  Future<void> getShortNameAssetCode(int? deptCode) async {
    String params = "DeptCode=";
    if (deptCode != null) {
      params += deptCode.toString();
    }
    isLoading(true);
    List<ShortNameAssetCodeListModel>? responseList =
        await ApiFetch.getShortNameAssetCodes(params);
    isLoading(false);
    if (responseList != null) {
      shortNameList.assignAll(responseList);
    }
  }

  Future<void> getLongNameAssetCode(int? deptCode) async {
    String params = "DeptCode=";
    if (deptCode != null) {
      params += deptCode.toString();
    }
    isLoading(true);
    List<LongNameModelList>? responseList =
        await ApiFetch.getLongNameAssetCodes(params);
    isLoading(false);
    if (responseList != null) {
      longNameList.assignAll(responseList);
    }
  }

  Future<void> getAssetCodeByShortLongName(String text) async {
    String params = "&AssetCode=$text";
    isLoading.value = true;
    AssetCodeModel? response = await ApiFetch.getAssetCodeByShortLongName(params);
    isLoading.value = false;
    if (response != null) {
      AssetCodeModel assetData = response;
      Debug.log("Asset Code: ${assetData.assetCode}");
      Debug.log("Short Name: ${assetData.shortName}");
      Debug.log("Long Name: ${assetData.longName}");
    }
  }

  void selectOption(String value) {
    selectedRadioValue.value = value;
  }

  void onDeleteRow(String id) {
    tableDataList.removeWhere((row) => row.id == id);
  }

  bool isAssetCodeDuplicate(String assetCode) {
    return tableDataList.any((row) => row.assetCode == assetCode);
  }

  void addTableRow(String assetCode) {
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    TableRowData newRow = TableRowData(
      id: uniqueId,
      assetCode: assetCode,
    );
    if (!isAssetCodeDuplicate(assetCode)) {
      tableDataList.add(newRow);
    } else {
      Get.snackbar(
        "Message",
        "Duplicat Asset code already added to the table.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      final bytes = await File(pickedFile.path).readAsBytes();
      selectedImageBase64.value = base64Encode(bytes);
      Debug.log('......................................${selectedImageBase64.value}');
    }
  }

  Future<void> saveComplainData() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    Debug.log(selectedDepartment.value?.deptCode);
    Debug.log(selectedToDepartment.value?.departmentCode);
    Debug.log(textarea.text);
    Debug.log(employeeCode);
    Debug.log(selectedImageBase64.value);
    final List<String> assetCodesList = tableDataList.map((rowData) => rowData.assetCode).toList();
    Get.defaultDialog(
      title: 'Confirmation',
      middleText: 'Do you want to save Complaint?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        Get.dialog(const LoadingSpinner());
        Map<String, dynamic> data = {
          "FromDepartment": selectedDepartment.value?.deptCode,
          "ToDepartment": selectedToDepartment.value?.departmentCode,
          "Detail": textarea.text,
          "UserId": employeeCode,
          "Image": selectedImageBase64.value ?? '',
          "AssetCodes": assetCodesList.isNotEmpty ? assetCodesList : null,
          "SourceTypes": Keys.source,
        };

        bool success = await ApiFetch.saveComplaintData(data);
        if (success) {
          Get.snackbar(
            "Message",
            "Your Complaint Send Successfully!",
            snackPosition: SnackPosition.TOP,
          );

          Get.offAllNamed(AppRoutes.home);
        } else {
          Get.snackbar(
            "Message",
            "Complaint Not Saved Successfully!",
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  Future<void> getQRCode() async {
    var results = await Get.toNamed(AppRoutes.barCodeScan);
    if (results != null) {
      assetCodeController.text = results;
    }
    isLoading.value = false;
  }
}

class TableRowData {
  final String id;
  final String assetCode;

  TableRowData({required this.id, required this.assetCode});
}
