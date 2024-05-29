import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/lot_detail_model.dart';
import '../models/lots_model.dart';

class FabricInspectionHomeController extends GetxController {
  final RxList<LotsListModel> lotList = RxList<LotsListModel>();
  final RxList<LotDetailModelList> lotDetailList = RxList<LotDetailModelList>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isLoading = RxBool(true);
  final TextEditingController lotTextController = TextEditingController();
  RxInt selectedLot = RxInt(0);
  final lotFocusScope = FocusNode();
  String? lotsList;

  String? table = Get.find<Preferences>().getString(Keys.inspectionTable);
  String? shift = Get.find<Preferences>().getString(Keys.shiftValue);

  Future<void> getLots(String query) async {
    String params = "Lot=$query";
    isLoading(true);
    if (query.isNotEmpty) {
      List<LotsListModel>? responseList = await ApiFetch.getLotsNo(params);
      isLoading(false);
      if (responseList != null) {
        lotList.assignAll(responseList);
      }
    }
  }

  Future<void> lotDetail(String selectedLotNo) async {
    String params = "LotNo=$selectedLotNo"; // Send employeeCode by default
    isLoading(true);
    List<LotDetailModelList>? responseList = await ApiFetch.getLotsDetail(params);
    isLoading(false);
    if (responseList != null) {
      lotDetailList.assignAll(responseList);
    }
  }
}
