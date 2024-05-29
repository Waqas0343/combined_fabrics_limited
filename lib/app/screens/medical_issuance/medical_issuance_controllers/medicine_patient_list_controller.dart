import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../medical_issuance_model/medicines_patient_issuance_model.dart';

class MedicinePatientListController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<PatientListModel> patientList = <PatientListModel>[].obs;
  final RxList<PatientMedicineModel> medicineList =
      <PatientMedicineModel>[].obs;
  final RxBool isLoading = true.obs;
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController issuanceNoController = TextEditingController();
  final TextEditingController patientCardController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final TextEditingController dateController = TextEditingController();
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  RxBool autoFilterEnabled = false.obs;

  @override
  void onInit() {
    fromDateController.text = dateFormat.format(dateTime);
    toDateController.text = dateFormat.format(dateTime);
    dateController.text = dateFormat.format(dateTime);
    autoFilterEnabled.value = Get.find<Preferences>().getBool(Keys.autoFilter) ?? false;
    getPatientMedicineList();
    super.onInit();
  }

  Future<void> getPatientMedicineList({
    String? fromData,
    String? toDate,
    String? issuanecNo,
    String? EmpCard,
  }) async {
    fromData ??= fromDateController.text;
    toDate ??= toDateController.text;
    EmpCard ??= '';
    issuanecNo ??= '';
    isLoading(true);
    String data = "IssuanceNo=$issuanecNo&PatientCardNo=$EmpCard&FromDate=$fromData&ToDate=$toDate";
    medicineList.clear();
    List<PatientListModel>? responseList = await ApiFetch.getPatientMedicineList(data);
    isLoading(false);
    if (responseList != null) {
      patientList.assignAll(responseList);
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
      getPatientMedicineList(
        fromData: fromDateController.text,
        toDate: toDateController.text,
        issuanecNo: issuanceNoController.text,
        EmpCard: patientCardController.text
      );
    } else {
      fromDateController.clear();
      toDateController.clear();
       issuanceNoController.clear();
      patientCardController.clear();
    }
  }
}
