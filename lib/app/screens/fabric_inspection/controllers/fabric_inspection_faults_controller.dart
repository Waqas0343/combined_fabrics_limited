import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../models/faults_model.dart';
import '../models/rolls_model.dart';

class FabricInspectionFaultsController extends GetxController {
  final Rxn<RollsListModel> rollsModel = Rxn<RollsListModel>();
  final RxList<FaultsListModel> faultsList = RxList<FaultsListModel>();

  TextEditingController searchController = TextEditingController();
  final isLoading = false.obs;
  DateTime? expireDate;
  String lotNoParam = '';
  String? colorParam;
  String? fabricParam;
  String? rpStatus;
  String? workOrder;
  String? diaGG;
  int? rolls;
  String? kgs;
  String? ecruKgs;
  String? table = Get.find<Preferences>().getString(Keys.inspectionTable);
  String? shift = Get.find<Preferences>().getString(Keys.shiftValue);

  @override
  void onInit() {
    super.onInit();
    rollsModel.value = Get.arguments['model'];
    final arguments = Get.arguments as Map<String, dynamic>;
    lotNoParam = arguments['lotNo'];
    colorParam = arguments['color'];
    fabricParam = arguments['fabric'];
    workOrder = arguments['work order'];
    rpStatus = arguments['rpStatus'];
    diaGG = arguments['DiaGG'];
    rolls = arguments['rolls'];
    kgs = arguments['kg'];
    ecruKgs = arguments['EcruKgs'];
    expireDate ??= DateTime.now();
    getFaults();
  }

  Future<void> getFaults() async {
    String params =
        "RollNo=${rollsModel.value?.rollNo}&RollCat=${rollsModel.value?.rollCat}&RpStatus=${rollsModel.value?.rpStatus ?? ''}&RpStatus=$rpStatus";
    isLoading.value = true;
    FaultsModel? faultsResponse = await ApiFetch.getFaults(params);
    isLoading.value = false;
    if (faultsResponse != null) {
      faultsList.assignAll(faultsResponse.list);
      expireDate = faultsResponse.expiredate;
      Get.find<Preferences>()
          .setString(Keys.rollTime, expireDate?.toIso8601String());
    }
  }

  Future<bool> saveFaults() async {
    if (rollsModel.value == null) {
      return false;
    }
    isLoading.value = true;
    List<FaultsListModel> faultsToSave =
        faultsList.where((fault) => fault.faultCount.value > 0).toList();

    if (faultsToSave.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        "No Faults Selected",
        "Please select at least one fault.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    List<Map<String, dynamic>> payload = faultsToSave.map((fault) {
      return {
        "RollNo": rollsModel.value?.rollNo,
        "RollCategory": rollsModel.value?.rollCat ?? '',
        "FaultCode": fault.faultCode,
        "FaultsCount": fault.faultCount.value,
        "RpStatus": rpStatus,
      };
    }).toList();
    bool success = await ApiFetch.saveFaults(payload);
    isLoading.value = false;
    if (success) {
      Get.snackbar(
        "Message",
        'Your Data Saved Successfully!',
        snackPosition: SnackPosition.TOP,
      );
    }
    Get.toNamed(
      AppRoutes.fabricFaultFormScreen,
      arguments: {
        'lotNo': lotNoParam,
        'color': colorParam,
        'fabric': fabricParam,
        'work order': workOrder,
        'rpStatus': rpStatus,
        'DiaGG': diaGG,
        'rolls': rolls,
        'kg': kgs,
        'EcruKgs': ecruKgs,
        'model': rollsModel.value,
      },
    );
    return success;
  }
}
