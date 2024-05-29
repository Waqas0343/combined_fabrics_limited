import 'dart:convert';
import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../../server/api_fetch.dart';
import '../../complaint_models/complaint_remark_model.dart';
import '../../complaint_models/get_department_complaint_model.dart';


class ComplaintRemarksController extends GetxController{
  final RxList<ComplaintRemarkListModel> remarksList = RxList<ComplaintRemarkListModel>();
  final Rxn<DepartmentComplaintListModel> complaintModel = Rxn<DepartmentComplaintListModel>();
  final picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<String?> selectedImageBase64 = Rx<String?>(null);
  final RxBool isLoading = RxBool(true);


  @override
  void onInit() {
    complaintModel.value = Get.arguments['ComplaintModel'];
    complaintRemarks();
    super.onInit();
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      final bytes = await File(pickedFile.path).readAsBytes();
      selectedImageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> complaintRemarks() async {
    try {
      String params = "CMPNO=${complaintModel.value?.cmpNo}";
      isLoading(true);
      List<ComplaintRemarkListModel>? responseList = await ApiFetch.getComplaintRemark(params);
      isLoading(false);
      if (responseList != null) {
        remarksList.assignAll(responseList);
      }
    } catch (e) {
      Debug.log('Error fetching complaint remarks: $e');
    }
  }

}