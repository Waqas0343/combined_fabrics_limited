import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/routes/app_routes.dart';
import 'package:combined_fabrics_limited/helpers/toaster.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rowing_quality_change_flag_model.dart';

class InLineFlagMarkController extends GetxController {
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  final RxList<ChangeFlagReasonListModel> selectedReason = <ChangeFlagReasonListModel>[].obs;
  final TextEditingController reasonController = TextEditingController();
  final RxBool buttonAction = RxBool(true);
  final RxBool isLoading = RxBool(true);
  final formKey = GlobalKey<FormState>();
  Color? flagColor;
  int? formNo;
  String? lineNo;
  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    formNo = arguments['FormNo'];
    flagColor = arguments['color'];
    lineNo = arguments['LineNo'];
    Debug.log('Flag Color in OnInit: $flagColor');
  }

  Future<void> saveInspectionFlagColor() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    String remarks = selectedReason.map((item) => item.reasons).join(", ");
    Map<String, dynamic> payload = {
      "flag": flagColor?.value.toRadixString(16).toUpperCase(),
      "FormNoRdimFk": formNo,
      "Remarks": remarks,
      "CreatedBy": employeeName,
    };
    Debug.log(payload);

    bool success = await ApiFetch.saveRowingQualityInspectionFlag(payload);
    isLoading.value = false;
    buttonAction(true);

    if (success) {
      Get.offAllNamed(AppRoutes.inLineInspection,  arguments: {
        'LineNo': lineNo,
      });
      Debug.log('--------------------------------------------$lineNo');
    } else {
      Toaster.showToast("Fault Flag Not Add!.");
    }
  }
}
