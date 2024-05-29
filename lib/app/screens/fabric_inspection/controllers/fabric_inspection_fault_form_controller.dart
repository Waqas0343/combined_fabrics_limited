import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';
import '../models/get_detail_by_roll_model.dart';
import '../models/quality_status_model.dart';
import '../models/roll_marking_model.dart';
import '../models/rolls_model.dart';

class FabricInspectionFormController extends GetxController {
  final RxList<RollMarkingStatusList> rollStatusList = RxList<RollMarkingStatusList>();
  final Rx<RollMarkingStatusList?> selectedMarkingRoll = Rx<RollMarkingStatusList?>(null);
  final Rx<QualityListModel?> selectedQuality = Rx<QualityListModel?>(null);
  final RxList<QualityListModel> qualityList = RxList<QualityListModel>();
  final Rxn<RollDetailModelData> rollDetail = Rxn<RollDetailModelData>();
  final TextEditingController measurementController = TextEditingController();
  final TextEditingController elonLengthController = TextEditingController();
  final TextEditingController elonWidthController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController meterController = TextEditingController();
  final TextEditingController gsmController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  final Rxn<RollsListModel> rollsModel = Rxn<RollsListModel>();

  String userID = Get.find<Preferences>().getString(Keys.userId) ?? "Guest User";
  String employeeCode = Get.find<Preferences>().getString(Keys.employeeCode) ?? "";
  String? table = Get.find<Preferences>().getString(Keys.inspectionTable);
  String? shift = Get.find<Preferences>().getString(Keys.shiftValue);
  String? dateTime = Get.find<Preferences>().getString(Keys.rollTime);
  double? previousValue;
  final RxBool isLoading = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final RxBool buttonAction = RxBool(true);

  RxBool isYesChecked = false.obs;
  RxBool isShadeChecked = false.obs;
  RxList<double> measurementList = <double>[].obs;
  double minValue = 0;
  double maxValue = 0;

  String lotNoParam = '';
  String? colorParam;
  String? fabricParam;
  String? workOrder;
  String? rpStatus;
  String? diaGG;
  int? rolls;
  String? kgs;
  String? ecruKgs;

  @override
  void onInit() {
    super.onInit();
    rollsModel.value = Get.arguments['model'];
    final arguments = Get.arguments as Map<String, dynamic>;
    lotNoParam = arguments['lotNo'];
    colorParam = arguments['color'];
    fabricParam = arguments['fabric'];
    workOrder = arguments['work order'];
    diaGG = arguments['DiaGG'];
    rolls = arguments['rolls'];
    kgs = arguments['kg'];
    ecruKgs = arguments['EcruKgs'];
    if (!["M1", "M2", "M3", "M4", "M5","M6","M7","M8"].contains(table)) {
      weightController.text = rollsModel.value!.kgs.toString();
    }
    rpStatus = arguments['rpStatus'];
    startController.text =
        DateFormat('HH:mm:ss').format(DateTime.parse(dateTime.toString()));
    Future.wait([
      getRollDetail(),
      getQuality(),
      getRollMarking(),
    ]);
  }

  Future<void> getRollDetail() async {
    isLoading.value = true;
    String params =
        "RollNo=${rollsModel.value?.rollNo}&RollCat=${rollsModel.value?.rollCat}&RpStatus=$rpStatus";
    RollDetailModelData? rollData = await ApiFetch.getDetailByRoll(params);
    Debug.log(rollData);
    isLoading.value = false;
    if (rollData != null) {
      rollDetail.value = rollData;
      meterController.text = rollData.meter.toString();
      weightController.text = rollData.weight.toString();
      gsmController.text = rollData.gsm.toString();
      measurementList.add(rollData.minWidth);
      measurementList.add(rollData.maxWidth);
      Debug.log(rollData.minWidth);
      Debug.log(rollData.maxWidth);
      selectedMarkingRoll.value?.display = rollData.rollMarkingStatus;
      remarksController.text = rollData.remarks;
      Debug.log(rollData.rollMarkingStatus);
    }
  }

  Future<void> getQuality() async {
    isLoading(true);
    List<QualityListModel>? responseList = await ApiFetch.getQualityStatus();
    isLoading(false);
    if (responseList != null) {
      qualityList.assignAll(responseList);
    }
  }

  Future<void> getRollMarking() async {
    isLoading(true);
    List<RollMarkingStatusList>? responseList =
        await ApiFetch.getRollMarkingStatus();
    isLoading(false);
    if (responseList != null) {
      rollStatusList.assignAll(responseList);
    }
  }

  Future<void> saveFormData() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    Debug.log(isYesChecked.value);
    Debug.log(isShadeChecked.value);
    Debug.log(elonLengthController.text);
    Debug.log(elonWidthController.text);
    // Connectivity checking
    // if (!await Connectivity.isOnline()) {
    //   Connectivity.internetNotAvailable();
    //   buttonAction.value = true;
    //   return;
    // }
    Get.defaultDialog(
      title: 'Confirmation',
      middleText: 'Do you want to save the form?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        double minValue = measurementList
            .reduce((value, element) => value < element ? value : element);
        double maxValue = measurementList
            .reduce((value, element) => value > element ? value : element);
        Get.dialog(const LoadingSpinner()); // Display loading spinner
        Debug.log(selectedMarkingRoll.value?.display);
        Map<String, dynamic> data = {
          "RollNo": rollsModel.value?.rollNo,
          "RollCategory": rollsModel.value?.rollCat,
          "RpStatus": rpStatus,
          "WorkOrderNo": workOrder,
          "LotNo": lotNoParam,
          "Color": Uri.encodeComponent(fabricParam!),
          "Fabric": fabricParam,
          "MinWidth": minValue,
          "MaxWidth": maxValue,
          "Width1": measurementList.isNotEmpty ? measurementList[0] : 0,
          "Width2": measurementList.length > 1 ? measurementList[1] : 0,
          "Width3": measurementList.length > 2 ? measurementList[2] : 0,
          "Width4": measurementList.length > 3 ? measurementList[3] : 0,
          "Gsm": gsmController.text,
          "Remarks":
              remarksController.text.isNotEmpty ? remarksController.text : "",
          "InspectionShift": shift,
          "InspectedByCode": employeeCode,
          "InspectionTableNo": table,
          "QualityStatus": selectedQuality.value?.display,
          "RollMarkingStatus": selectedMarkingRoll.value?.display,
          "UserId": userID,
          "Meter": meterController.text.isNotEmpty ? meterController.text : 0,
          "Weight": weightController.text,
          "ElongationWidth": elonWidthController.text.isNotEmpty
              ? elonWidthController.text
              : null,
          "ElongationLength": elonLengthController.text.isNotEmpty
              ? elonLengthController.text
              : null,
          "ShrinkageCut": isYesChecked.value,
          "ShadeContinuity": isShadeChecked.value,
          "StartTime": dateTime,
          "EndTime": " ",
        };

        bool success = await ApiFetch.saveFaultsFormData(data);

        Get.back(); // Close the loading spinner dialog

        if (success) {
          Get.snackbar(
            "Message",
            'Roll Detail Added OR Updated Successfully!',
            snackPosition: SnackPosition.TOP,
          );
          Get.offAllNamed(
            AppRoutes.fabricInspectionList,
            arguments: {
              'lotNo': lotNoParam,
              'color': colorParam,
              'fabric': fabricParam,
              'work order': workOrder,
              'DiaGG': diaGG,
              'rolls': rolls,
              'kg': kgs,
              'EcruKgs': ecruKgs,
              'rpStatus': rpStatus,
            },
          );
        } else {
          Get.snackbar(
            "Message",
            'Data Not Saved Successfully!',
            snackPosition: SnackPosition.TOP,
          );
        }
      },
      onCancel: () {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  void toggleSwitch(bool value) {
    isYesChecked.value = value;
  }

  void toggleShade(bool value) {
    isShadeChecked.value = value;
  }

  bool getSelectedValue() {
    return isYesChecked.value;
  }

  bool getSelectedShadeValue() {
    return isShadeChecked.value;
  }
}
