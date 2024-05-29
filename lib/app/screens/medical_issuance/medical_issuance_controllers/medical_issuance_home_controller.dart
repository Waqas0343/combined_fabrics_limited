import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/toaster.dart';
import '../../../debug/debug_pointer.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';
import '../medical_issuance_model/medcine_patient_card_model.dart';
import '../medical_issuance_model/medical_disease_model.dart';
import '../medical_issuance_model/medicine_first_aid_box_model.dart';
import '../medical_issuance_model/medicine_list_model.dart';
import '../medical_issuance_model/medicine_stock_model.dart';

class MedicalIssuanceHomeController extends GetxController {
  final TextEditingController selectedMedicineController = TextEditingController();
  final TextEditingController medicineQuantityController = TextEditingController();
  final TextEditingController employeeCodeController = TextEditingController();
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final Rxn<MedicineStockListModel?> selectedMedicine = Rxn<MedicineStockListModel?>();
  final Rxn<DiseaseListModel?> selectedDisease = Rxn<DiseaseListModel?>();
  final Rxn<FirstAidBoxListModel?> selectedBoxes = Rxn<FirstAidBoxListModel?>();
  final RxList<MedicineListModel> medicineList = RxList<MedicineListModel>();
  final RxList<MedicineStockListModel> stockMedicineList = RxList<MedicineStockListModel>();
  final TextEditingController searchController = TextEditingController();
  final RxList<DiseaseListModel> diseaseList = RxList<DiseaseListModel>();
  final RxList<FirstAidBoxListModel> boxesList = RxList<FirstAidBoxListModel>();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController diagnosisByController = TextEditingController();
  final TextEditingController contractorNameController = TextEditingController();
  final TextEditingController contractorVisitingCardController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController boxNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final RxList<MedicineData> tableDataList = <MedicineData>[].obs;
  TextEditingController addMedicineController = TextEditingController();
  TextEditingController addFirstAidBoxNoController = TextEditingController();
  TextEditingController adFirstAidBoxNameController = TextEditingController();
  final RxBool _isSaving = false.obs;
  final Rx<PatientCardDataModel?> patientCardData = Rx<PatientCardDataModel?>(null);
  final DateFormat dateFormat = DateFormat(Keys.dateFormat);
  String departmentCode =Get.find<Preferences>().getString(Keys.departmentCode) ?? "Guest User";
  String departmentName = Get.find<Preferences>().getString(Keys.employeeCode) ?? "Guest User";
  RxString selectedRadioValue = 'Employee'.obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = RxBool(true);
  DateTime dateTime = DateTime.now();
  RxInt quantity = 1.obs;
  RxInt selectedQuantity = 0.obs;
  List<Color> rowColors = [
    const Color(0xffe5f7f1),
    Colors.white,
  ];
  MedicineStockListModel? selected;
  final RxList<DiseaseListModel> selectedDiseases = <DiseaseListModel>[].obs;
  final RxBool buttonAction = RxBool(true);

  @override
  void onInit() {
    diagnosisByController.text = employeeName;
    remarksController.text = "Dr. Kamran Bajwa";
    dateController.text = dateFormat.format(dateTime);
    getMedicines();
    getDiseaseName();
    getFirstAidName();
    super.onInit();
  }

  Future<void> getMedicines() async {
    String params = "ItemName=";
    isLoading(true);
    List<MedicineStockListModel>? responseList = await ApiFetch.getMedicineStockList(params);
    isLoading(false);
    if (responseList != null) {
      stockMedicineList.assignAll(responseList);
    }
  }

  // Future<void> getMedicines() async {
  //   isLoading(true);
  //   List<MedicineListModel>? responseList = await ApiFetch.getMedicinesList();
  //   isLoading(false);
  //   if (responseList != null) {
  //     medicineList.assignAll(responseList);
  //   }
  // }

  Future<void> getDiseaseName() async {
    isLoading(true);
    List<DiseaseListModel>? responseList = await ApiFetch.getDiseaseList();
    isLoading(false);
    if (responseList != null) {
      diseaseList.assignAll(responseList);
    }
  }

  Future<void> getFirstAidName() async {
    isLoading(true);
    List<FirstAidBoxListModel>? responseList =
        await ApiFetch.getFirstAidBoxList();
    isLoading(false);
    if (responseList != null) {
      boxesList.assignAll(responseList);
    }
  }

  Future<void> addNewFirstAidBox() async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data =
        "FirstAidBoxNo=${addFirstAidBoxNoController.text}&FirstAidBoxName=${adFirstAidBoxNameController.text}";
    bool response = await ApiFetch.saveNewFirstAidBox(data);
    isLoading(false);
    Get.back();

    if (response) {
      Get.snackbar(
        "Successfully",
        "Your Box  added successfully.",
        snackPosition: SnackPosition.TOP,
      );

      // Call the getDiseaseName function and clear the disease list
      await getDiseaseName();
    } else {
      Get.snackbar(
        "Alert!",
        "Failed to add the Box.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> saveNewDisease() async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data = "diseaseName=${addMedicineController.text}";
    bool response = await ApiFetch.saveNewDiseaseName(data);
    isLoading(false);
    Get.back();

    if (response) {
      Get.snackbar(
        "Successfully",
        "Your Disease was added successfully.",
        snackPosition: SnackPosition.TOP,
      );

      await getDiseaseName();
    } else {
      Get.snackbar(
        "Alert!",
        "Failed to add the disease.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void addTableRow(String itemCode, String itemName, int quantity) {
    MedicineData newRow = MedicineData(
      id: itemCode,
      medicineName: itemName,
      quantity: quantity,
    );

    if (!isMedicineDuplicate(itemCode)) {
      tableDataList.add(newRow);
    } else {
      Get.snackbar(
        "Alert!",
        "Duplicate Asset code already added to the table.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  // Declare an RxBool variable to track whether an operation is in progress


  Future<void> saveMedicineData() async {
    if (_isSaving.value) {
      return;
    }
    _isSaving.value = true;
    try {
      buttonAction.value = false;
      if (!formKey.currentState!.validate()) {
        return;
      }
      formKey.currentState!.save();
      isLoading.value = true;
      List<Map<String, dynamic>> medicineList = [];
      for (MedicineData medicine in tableDataList) {
        if (medicine.quantity > 0) {
          medicineList.add({
            "ItemCode": medicine.id,
            "Qty": medicine.quantity,
          });
        }
      }
      if (medicineList.isEmpty) {
        isLoading.value = false;
        buttonAction.value = true;
        Toaster.showToast("Please select at least one medicine.");
        return;
      }

      Map<String, dynamic> payload = {
        "IssuanceType": selectedRadioValue.value,
        "PatiantCardNo": employeeCodeController.text,
        "Diagnosis": selectedDiseases.asMap().entries.map((entry) {
          DiseaseListModel disease = entry.value;
          return {
            "Disease": disease.diseaseName,
          };
        }).toList(),
        "DiagnosisBy": employeeName,
        "DeptCode": patientCardData.value?.deptCode ?? 0,
        "DeptName": patientCardData.value?.deptName,
        "Remarks": remarksController.text,
        "FirstAidBoxNo": selectedBoxes.value?.firstAidBoxNumber,
        "ContractorInformation": contractorNameController.text + contractorVisitingCardController.text,
        "Transdate": dateController.text,
        "Medicine": medicineList,
      };
      Debug.log('-----------------------------------------------------------My Data------------------------------------$payload');
      // Perform API call
      bool success = await ApiFetch.medicineIssue(payload);
      isLoading.value = false;

      if (success) {
        Get.snackbar(
          "Successfully",
          "Medicine Issue Successfully!.",
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed(AppRoutes.medicineDashboardScreen);
      } else {
        Get.snackbar(
          "Alert!",
          "Medicine Not Issue!.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      _isSaving.value = false;
      buttonAction.value = true;
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

  void onDeleteRow(String id) {
    tableDataList.removeWhere((row) => row.id == id);
  }

  bool isMedicineDuplicate(String itemCode) {
    return tableDataList.any((row) => row.id == itemCode);
  }

  void medicinesIncrement() {
    if (quantity.value < 500) {
      quantity.value++;
    }
  }

  void medicineDecrement() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  Future<void> getPatientCardNo() async {
    String params = "EmpCode=${employeeCodeController.text}";
    try {
      isLoading(true);
      final data = await ApiFetch.getPatientCardNo(params);
      isLoading(false);
      if (data != null) {
        patientCardData.value = data;
        if (employeeCodeController.text != data.empCode.toString()) {
          Get.snackbar(
            "Successfully!",
            "Employee Code Not Exist in System!.",
            snackPosition: SnackPosition.TOP,
          );
        }
      }
    } catch (e, s) {
      Debug.log("Error fetching User data: $e");
      Debug.log("Stack trace: $s");
    }
  }

  void selectOption(String value) {
    selectedRadioValue.value = value;
  }
}

class MedicineData {
  final String id;
  final String medicineName;
  final int quantity;

  MedicineData({
    required this.id,
    required this.medicineName,
    required this.quantity,
  });
}
