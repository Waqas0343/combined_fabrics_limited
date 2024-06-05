import 'package:combined_fabrics_limited/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../../app_assets/styles/strings/app_constants.dart';
import '../../../../helpers/crypto_helper.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';
import '../../dialogs/dialog.dart';

class LoginController extends GetxController {
  String? loginId;
  String? password;
  final rememberMe = false.obs;
  final RxBool buttonAction = RxBool(true);
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginIDController = TextEditingController();
  var isPasswordVisible = false.obs;

  void login() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    buttonAction(false);
    Get.dialog(const LoadingSpinner()); // Loading spinner
    Map<String, dynamic> data = {
      "UserId": loginId,
      "Password": password,
    };
    String? token = await ApiFetch.login(data); // HTTP request
    Get.back();
    buttonAction(true);

    if (token == null) {
      Get.defaultDialog(
        title: 'Login Failed',
        middleText: 'Failed to log in. Please check your credentials and try again.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
      return;
    }
    // Store token data in Preferences
    Get.find<Preferences>().setString(Keys.token, token);
    // Decode the token
    Map<String, dynamic> decodedTokenData = JwtDecoder.decode(token);
    //Store the Decoded Data in Preferences
    Get.find<Preferences>().setString(Keys.userId, decodedTokenData["UserId"]);
    Get.find<Preferences>().setString(Keys.employeeCode, decodedTokenData["EmployeeCode"]);
    Get.find<Preferences>().setString(Keys.departmentCode, decodedTokenData["DepartmentCode"]);
    Get.find<Preferences>().setBool(Keys.departmentAdmin, decodedTokenData["DepartmentAdmin"] == "True");
    Get.find<Preferences>().setBool(Keys.isComplaintHandler, decodedTokenData["IsComplaintHandler"] == "True");
    Get.find<Preferences>().setBool(Keys.allowedToComplain, decodedTokenData["AllowedToComplain"] == "True");
    Get.find<Preferences>().setBool(Keys.isAllowedDyeingApp, decodedTokenData["IsAllowedDyeingApp"] == "True");
    Get.find<Preferences>().setBool(Keys.isAllowedDfapp, decodedTokenData["IsAllowedDfapp"] == "True");
    Get.find<Preferences>().setBool(Keys.isAllowedFidapp, decodedTokenData["IsAllowedFidapp"] == "True");
    Get.find<Preferences>().setBool(Keys.isAllowedFfsapp, decodedTokenData["IsAllowedFfsapp"] == "True");
    Get.find<Preferences>().setString(Keys.cmpType, decodedTokenData["CmpType"]);
    Get.find<Preferences>().setBool(Keys.status, true);
    final service = FlutterBackgroundService();
    await service.startService();
    Get.offAllNamed(AppRoutes.home);
  }

  void toggleRememberMe(bool? value) {
    if (value != null) {
      rememberMe.value = value;
      Get.find<Preferences>().setBool(Keys.rememberMe, rememberMe.value);
    }
  }

  void saveLoginCredentials(String value) {
    if (rememberMe.value) {
      String? encyPassword = password != null ? CryptoHelper.encryption(password!) : null;
      Get.find<Preferences>().setString(Keys.password, encyPassword);
      Get.find<Preferences>().setString(Keys.userId, loginId);
    }
  }
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
