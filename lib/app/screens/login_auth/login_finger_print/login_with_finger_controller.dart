import 'package:combined_fabrics_limited/app_assets/styles/strings/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../app_assets/toaster.dart';
import '../../../../helpers/crypto_helper.dart';
import '../../../routes/app_routes.dart';
import '../../../server/api_fetch.dart';
import '../../../services/preferences.dart';

class LoginWithFingerController extends GetxController {
  String? loginId;
  String? password;

  final LocalAuthentication localAuthentication = LocalAuthentication();
  RxBool showFingerprintLogin = false.obs;
  final bool _isAuthenticated = false;
  final RxBool buttonAction = RxBool(true);

  void checkFingerprintSupport() async {
    bool isSupported = await localAuthentication.canCheckBiometrics;
    bool isEnabled = Get.find<Preferences>().getBool(Keys.fingerPrint) ?? false;
    if (isSupported && isEnabled) {
      showFingerprintLogin.value = true;
    } else {
      showFingerprintLogin.value = false;
    }
  }

  Future<void> loginWithFingerPrint() async {
    String? fingerPassword =
        password != null ? CryptoHelper.decryption(password!) : null;
    if (loginId == null || fingerPassword == null) {
      AppToaster.error('Please enable your fingerprint to log in.');
      return;
    }
    Map<String, dynamic> data = {
      "UserId": loginId,
      "Password": password,
    };
    String? token = await ApiFetch.login(data);
    Get.back(); // Close loading spinner
    buttonAction(true);

    if (token == null) {
      // Show a dialog or display a message indicating login failure.
      Get.defaultDialog(
        title: 'Login Failed',
        middleText:
            'Failed to log in. Please check your credentials and try again.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();
        },
      );
      return;
    }

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

    // Navigate to the home screen
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onInit() {
    checkFingerprintSupport();
    loginId = Get.find<Preferences>().getString(Keys.userId);
    password = Get.find<Preferences>().getString(Keys.password);
    super.onInit();
  }

  bool get isAuthenticated => _isAuthenticated;

  String? get imagePath => Get.find<Preferences>().getString(Keys.imagePath);

  String? get name => Get.find<Preferences>().getString(Keys.userId);
}
