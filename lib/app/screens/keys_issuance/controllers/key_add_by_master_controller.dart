import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../dialogs/dialog.dart';
import '../../goods_inspections_note/goods_inspection_models/goods_inspection_other_department_model.dart';
import '../models/get_master_keys_model.dart';
import '../models/key_sub_department_model.dart';
import '../models/keys_concerned_person_model.dart';

class KeyAddByMasterController extends GetxController {
  final RxList<GoodsInspectionOtherDepartmentListModel> otherDepartmentList = RxList<GoodsInspectionOtherDepartmentListModel>();
  final Rxn<GoodsInspectionOtherDepartmentListModel?> selectedDepartment = Rxn<GoodsInspectionOtherDepartmentListModel?>();
  final RxList<KeyConcernedPersonListModel> concernedPersonList = RxList<KeyConcernedPersonListModel>();
  final RxList<SubDepartmentListModel> subDepartmentList = RxList<SubDepartmentListModel>();
  final Rxn<SubDepartmentListModel?> selectedSubDepartment = Rxn<SubDepartmentListModel?>();
  RxList<KeyConcernedPersonListModel> selectedPersons = <KeyConcernedPersonListModel>[].obs;
  final TextEditingController keyDepartmentNameController = TextEditingController();
  final TextEditingController totalKeysNoController = TextEditingController();
  final TextEditingController keyDeptCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();
  final TextEditingController addSubDepNameController = TextEditingController();
  final TextEditingController addSubDeptIdController = TextEditingController();
  final TextEditingController alarmTimeController = TextEditingController();
  final Rxn<MasterKeysListModel> updateKeyData = Rxn<MasterKeysListModel>();
  final TextEditingController keyPersonController = TextEditingController();
  final TextEditingController issueTimeController = TextEditingController();
  final TextEditingController keysCodeController = TextEditingController();
  final TextEditingController keysNewController = TextEditingController();
  final TextEditingController keysNoController = TextEditingController();
  final TextEditingController keysIDController = TextEditingController();
  RxList<KeyDeparment> selectedDepartments = <KeyDeparment>[].obs;
  RxList<KeyTimeTable> dataTableEntries = <KeyTimeTable>[].obs;
  final DateFormat timeFormat = DateFormat(Keys.timeFormat);
  var selectedWeekday = WeekdayModel(name: 'Monday').obs;
  List<String> departmentType = ["Department", "Car"];
  List<int> concernedPersonLevel = [1, 2, 3];
  var selectedItems = <KeyTimeTable>[].obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = RxBool(true);
  RxString selectedRadioValue = ''.obs;
  RxBool checkKeyStatus = RxBool(false);
  DateTime dateTime = DateTime.now();
  RxInt selectedLevelValue = 1.obs;
  var selectedWeekdayIndex = 0.obs;
  int selectedPersonIndex = -1;
  List<int> selectedLevels = [];
  int? index;
  var weekdays = [
    WeekdayModel(name: 'Monday'),
    WeekdayModel(name: 'Tuesday'),
    WeekdayModel(name: 'Wednesday'),
    WeekdayModel(name: 'Thursday'),
    WeekdayModel(name: 'Friday'),
    WeekdayModel(name: 'Saturday'),
    WeekdayModel(name: 'Sunday'),
  ];

  @override
  void onInit() {
    if (Get.arguments != null) {
      initializeWithData();
    }
    getDepartmentList();
    getSubDepartmentName();
    super.onInit();
  }

  void initializeWithData() {
    updateKeyData.value = Get.arguments['model'];
    Debug.log(updateKeyData.value);
    index = Get.arguments['index'];
    keysNoController.text = updateKeyData.value!.keyCode.toString();
    selectedRadioValue.value = updateKeyData.value!.keyType;
    keyDeptCodeController.text = updateKeyData.value!.keyDeptCode.toString();
    descriptionController.text = updateKeyData.value!.keyDeptName;
    descriptionController.text = updateKeyData.value!.keyDetail ?? ' ';
    keysCodeController.text = updateKeyData.value!.keyId.toString();
    totalKeysNoController.text = updateKeyData.value!.noOfKeys.toString();
    keysIDController.text = updateKeyData.value!.keyId.toString();
    keyDepartmentNameController.text = updateKeyData.value!.keyDeptName;
    selectedPersons.addAll(updateKeyData.value!.keyConcernPersons);
    selectedDepartments.addAll(updateKeyData.value!.keyDeparment);
    checkKeyStatus = true.obs;
    dataTableEntries.addAll(updateKeyData.value!.keyTimeTable);
    updateKeyData.value?.keyConcernPersons.forEach((person) {
      selectedLevels.add(person.level);
    });
  }

  Future<void> getDepartmentList() async {
    isLoading(true);
    List<GoodsInspectionOtherDepartmentListModel>? responseList = await ApiFetch.getOtherDepartmentInGoodInspection();
    isLoading(false);
    if (responseList != null) {
      otherDepartmentList.assignAll(responseList);
    }
  }

  Future<void> getSubDepartmentName() async {
    isLoading(true);
    List<SubDepartmentListModel>? responseList =
        await ApiFetch.getKeySubDepartment();
    isLoading(false);
    if (responseList != null) {
      subDepartmentList.assignAll(responseList);
    }
  }

  Future<void> getKeyConcernedPerson(String departmentCode) async {
    isLoading(true);
    String data = "DeptCode=$departmentCode";
    List<KeyConcernedPersonListModel>? responseList =
        await ApiFetch.getKeysConcernedPersonList(data);
    isLoading(false);
    if (responseList != null) {
      concernedPersonList.assignAll(responseList);
    }
  }

  void toggleBookStatus(bool status) {
    checkKeyStatus.value = status;
  }

  void addSelectedPersonWithLevel(
      KeyConcernedPersonListModel? selectedPerson, int selectedLevel) {
    if (selectedPerson != null && selectedPerson.level != null) {
      selectedPersons.add(selectedPerson);
      selectedLevels.add(selectedLevel);
    } else {
      Debug.log('Invalid selectedPerson or level.');
    }
  }

  Future<void> pickTime(BuildContext context, String data) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      if (data == "Key IssueTime") {
        issueTimeController.text =
            timeFormat.format(DateTime(2023, 1, 1, time.hour, time.minute));
      } else if (data == "Key Return Time") {
        returnTimeController.text =
            timeFormat.format(DateTime(2023, 1, 1, time.hour, time.minute));
      } else if (data == "Key Alarm Time") {
        alarmTimeController.text =
            timeFormat.format(DateTime(2023, 1, 1, time.hour, time.minute));
      }

      update();
    }
  }

  Future<void> saveNewSubDepartment() async {
    isLoading(true);
    Get.dialog(const LoadingSpinner());
    String data =
        "SubDeptName=${addSubDepNameController.text}&SubDeptId=${addSubDeptIdController.text}";
    bool response = await ApiFetch.saveNewSubDepartmentName(data);
    isLoading(false);
    Get.back();

    if (response) {
      Get.snackbar(
        "Successfully",
        "Your Sub Dept Name was added successfully.",
        snackPosition: SnackPosition.TOP,
      );

      // Call the getDiseaseName function and clear the disease list
      await getSubDepartmentName();
    } else {
      Get.snackbar(
        "Alert!",
        "Failed to add the Sub Dept Name.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  int getSelectedLevelForPerson(int index) {
    if (index >= 0 && index < selectedLevels.length) {
      return selectedLevels[index];
    } else {
      Debug.log('Invalid index: $index');
      return 0;
    }
  }

  void removeSelectedPerson(int index) {
    selectedPersons.removeAt(index);
    selectedLevels.removeAt(index);
  }

  void removeTimeTable(int index) {
    dataTableEntries.removeAt(index);
  }

  void selectOption(String value) {
    selectedRadioValue.value = value;
  }

  void addEntry(KeyTimeTable entry) {
    if (!dataTableEntries.any((e) => e.weekDay == entry.weekDay)) {
      dataTableEntries.add(entry);
    }
  }

  void onWeekdaySelected(int index) {
    selectedWeekdayIndex.value = index;
    selectedWeekday.value = weekdays[index];
  }

  void removeDepartment(int index) {
    selectedDepartments.removeAt(index);
  }

  Future<void> saveKeyData() async {
    if (!formKey.currentState!.validate()) return;
    try {
      isLoading.value = true;
      List<Map<String, dynamic>> keyDepartmentList =
          selectedDepartments.map((department) {
        return {
          "KeyId": keysCodeController.text.isNotEmpty
              ? keysCodeController.text
              : null,
          "DeptCode": department.deptCode,
          "DeptName": department.deptName,
          "SubDeptId": selectedSubDepartment.value?.subDeptId,
        };
      }).toList();

      Map<String, dynamic> payload = {
        "KeyId":
            keysCodeController.text.isNotEmpty ? keysCodeController.text : null,
        "KeyCode": keysNoController.text,
        "KeyType": selectedRadioValue.value,
        "KeyDetail": descriptionController.text,
        "NoOfKeys": totalKeysNoController.text,
        "KeyDept": keyDeptCodeController.text,
        "TimeTableStatus": checkKeyStatus.value,
        "keyConcernPersons": selectedPersons.asMap().entries.map((entry) {
          int index = entry.key;
          KeyConcernedPersonListModel person = entry.value;
          return {
            "PersonId": updateKeyData.value != null ? person.personId : null,
            "EmployeeCardNo": person.employeeCardNo,
            "Level": selectedLevels[index],
          };
        }).toList(),
        "KeyTimeTable": dataTableEntries.map((keyModel) {
          return {
            "KeyId": keysCodeController.text.isNotEmpty
                ? keysCodeController.text
                : null,
            "WeekDay": keyModel.weekDay,
            "IssueTime": keyModel.issueTime,
            "ReturnTime": keyModel.returnTime,
            "AlarmTime": keyModel.alarmTime,
          };
        }).toList(),
        "KeyDeparment": keyDepartmentList
      };

      bool success = await ApiFetch.addKeyByMaster(payload);
      if (success) {
        Get.snackbar(
          "Key Save Successfully",
          "Your Key Add Successfully.",
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed(AppRoutes.keysDashBoardScreen);
      } else {
        Get.snackbar(
          "Key Not Save",
          "Your Key  Not Save.",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Message",
        "Error: Unable to save key details.",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class WeekdayModel {
  String? name;

  WeekdayModel({required this.name});
}

class Entry {
  String weekdayName;
  String issueTime;
  String returnTime;
  String alarmTime;

  Entry({
    required this.weekdayName,
    required this.issueTime,
    required this.returnTime,
    required this.alarmTime,
  });
}
