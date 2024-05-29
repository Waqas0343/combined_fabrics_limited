import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../medical_issuance_model/medicine_first_aid_box_issuance.dart';

class FirstAidBoxIssuanceController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<FirstAidBoxMedicineIssuanceListModel> firstAidList = <FirstAidBoxMedicineIssuanceListModel>[].obs;
  final RxList<FirstAidMedicineList> medicineList = <FirstAidMedicineList>[].obs;
  final RxBool isLoading = true.obs;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController boxNoController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  final TextEditingController dateController = TextEditingController();
  RxBool autoFilterEnabled = false.obs;
  @override
  void onInit() {
    fromDateController.text = dateFormat.format(dateTime);
    toDateController.text = dateFormat.format(dateTime);
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getFirstAidMedicineList();
    super.onInit();
  }

  Future<void> getFirstAidMedicineList({
    String? fromData,
    String? toDate,
    String? boxNo,
  }) async {
    fromData ??= fromDateController.text;
    toDate ??= toDateController.text;
    boxNo ??= '';
    isLoading(true);
    String data = "FirstAidBoxNo=$boxNo&FromDate=$fromData&ToDate=$toDate";
    medicineList.clear();
    List<FirstAidBoxMedicineIssuanceListModel>? responseList = await ApiFetch.getFirstAidMedicineList(data);
    isLoading(false);
    if (responseList != null) {
      firstAidList.assignAll(responseList);
      medicineList.assignAll(responseList.expand((patient) => patient.medicine));
    }
  }

  Future<void> pickFromDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(minutes: 10),
      ),
    );

    if (date != null) {
      fromDateController.text = dateFormat.format(date);
      dateTime = date;
    }
  }

  Future<void> pickToDate() async {
    DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(minutes: 10),
      ),
    );

    if (date != null) {
      toDateController.text = dateFormat.format(date);
      dateTime = date;
    }
  }
  void setAutoFilter(bool value) {
    autoFilterEnabled.value = value;
    Get.find<Preferences>().setBool(Keys.autoFilter, value);
  }

  void autoFilter() {
    if (autoFilterEnabled.value) {
      getFirstAidMedicineList(
          fromData: fromDateController.text,
          toDate: toDateController.text,
          boxNo: boxNoController.text,

      );
    } else {
      fromDateController.clear();
      toDateController.clear();
      boxNoController.clear();
    }
  }

}
