import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../debug/debug_pointer.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/inspection_table_model.dart';

class TableShiftDialogController extends GetxController {


  final RxList<InspectionTableList> tableList = RxList<InspectionTableList>();
  final Rxn<InspectionTableList?> selectedTable = Rxn<InspectionTableList?>();
  final TextEditingController shiftController = TextEditingController();
  final RxBool isLoading = RxBool(true);
  final Rx<String> shiftData = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    Future.wait([
      getInspectionTable(),
      getShift(),
    ]);
  }
  Future<void> getInspectionTable() async {
    isLoading(true);
    List<InspectionTableList>? responseList = await ApiFetch.getInspectionTables();
    isLoading(false);
    if (responseList != null) {
      tableList.assignAll(responseList);
    }
  }


  Future<void> getShift() async {
    try {
      isLoading(true);
      final String data = await ApiFetch.getShiftData();
      isLoading(false);
      shiftData.value = data;
      if (shiftData.isNotEmpty) {
        shiftController.text = shiftData.value;
      }
    } catch (e) {
      Debug.log('Error: $e');
      shiftData.value = '';
    }
  }
  Future<void> saveSelectedValues(String shiftValue, selectedTable) async {
    Get.find<Preferences>().setString(Keys.shiftValue,shiftValue);
    Get.find<Preferences>().setString(Keys.inspectionTable,selectedTable);

  }
}