import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/rolls_model.dart';

class FabricInspectionListController extends GetxController {
  final RxList<RollsListModel> rollsList = RxList<RollsListModel>();

  final RxBool _hasMore = RxBool(false);
  final RxBool isLoading = RxBool(true);
  final RxBool hasSearchText = RxBool(false);
  final TextEditingController searchController = TextEditingController();
  String lotNoParam = '';
  String? colorParam;
  String? fabricParam;
  String? workOrder;
  String? diaGG;
  String? rpStatus;
  int? rolls;
  String? kgs;
  String? ecruKgs;
  String? table = Get.find<Preferences>().getString(Keys.inspectionTable);
  String? shift = Get.find<Preferences>().getString(Keys.shiftValue);
  int offSet = 0;

  @override
  void onInit() {
    final arguments = Get.arguments as Map<String, dynamic>;

    lotNoParam = arguments['lotNo'];
    colorParam = arguments['color'];
    fabricParam = arguments['fabric'];
    workOrder = arguments['work order'];
    diaGG = arguments['DiaGG'];
    rolls = arguments['rolls'];
    kgs = arguments['kg'];
    ecruKgs = arguments['EcruKgs'];
    rpStatus = arguments['rpStatus'];
    Future.wait([
      getRoll(),
    ]);

    searchController.addListener(focusListener);
    super.onInit();
  }

  bool get hasMore => _hasMore.value;

  Future<void> getRoll() async {
    Debug.log(fabricParam);
    Debug.log(colorParam);
    Debug.log(lotNoParam);
    Debug.log(lotNoParam);
    String lotNoEncoded = Uri.encodeComponent(lotNoParam);
    String colorEncoded = Uri.encodeComponent(colorParam!);
    String fabricEncoded = Uri.encodeComponent(fabricParam!);
    String params =
        "LotNo=$lotNoEncoded&Color=$colorEncoded&Fabric=$fabricEncoded&RollNo=${searchController.text}&RpStatus=$rpStatus";
    isLoading(true);
    rollsList.refresh();
    List<RollsListModel>? responseList = await ApiFetch.getRolls(params);
    isLoading(false);
    if (responseList != null) {
      rollsList.assignAll(responseList);
    }
  }

  Future<void> applyFilter() async {
    rollsList.clear();
    getRoll();
  }

  void focusListener() {
    hasSearchText.value = searchController.text.trim() != "";
  }
}
