import 'dart:async';

import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:combined_fabrics_limited/app/services/preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:io' show Platform;
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/toaster.dart';
import '../../server/api_fetch.dart';
import 'model/get_menu_model.dart';
import 'model/get_sub_menu_model.dart';

class HomeController extends GetxController {
  final RxList<MenuModelList> userMenuList = RxList<MenuModelList>();
  final RxList<SubMenuModelList> userSubMenuList = RxList<SubMenuModelList>();
  GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final RxInt unreadChats = RxInt(0);
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String name = Get.find<Preferences>().getString(Keys.cmpType) ?? "Guest User";
  String employeeCode =
      Get.find<Preferences>().getString(Keys.employeeCode) ?? "Guest User";
  String token = Get.find<Preferences>().getString(Keys.token) ?? "";
  String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
  String? userDepartment =
      Get.find<Preferences>().getString(Keys.departmentCode);
  RxInt documentCount = 0.obs;
  RxBool isBiometricEnabled = false.obs;
  final RxBool isLoading = true.obs;
  Timer? timer;

  @override
  void onInit() {
    Debug.log("Token $token");
    Debug.log("Cmp $name");
    Debug.log("Cmp $userDepartment");
    // handleNotifications();
    checkBiometric();
    toggleBiometric;
    getCountAllDocs();
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) async {
      getCountAllDocs();
    });


    getUserMenu();
    getUserSubMenuList();

    super.onInit();
  }

  Future<void> getUserMenu() async {
    isLoading(true);
    String params = "UserId=$employeeName";
    List<MenuModelList>? responseList = await ApiFetch.getMenuForUser(params);
    isLoading(false);
    if (responseList != null) {
      userMenuList.assignAll(responseList);
    }
  }

  Future<void> getCountAllDocs() async {
    isLoading(true);
    String params = "userId=$employeeName";
    documentCount.value = await ApiFetch.getCountAllDocs(params) ?? 0;
    isLoading(false);
  }

  Future<void> getUserSubMenuList() async {
    // isLoading(true);
    // String params = "MenuId=&UserId=$employeeName";
    // List<SubMenuModelList>? responseList =
    //     await ApiFetch.getSubMenuForUser(params);
    // isLoading(false);
    // if (responseList != null) {
    //   userSubMenuList.assignAll(responseList);
    // }
  }

  void checkBiometric() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    if (canCheckBiometrics) {
      List<BiometricType> availableBiometrics =
          await _localAuthentication.getAvailableBiometrics();

      bool isEnabled =
          Get.find<Preferences>().getBool(Keys.fingerPrint) ?? false;

      if (isEnabled ||
          (availableBiometrics.contains(BiometricType.fingerprint) ||
              availableBiometrics.contains(BiometricType.face))) {
        isBiometricEnabled.value = true;
      } else {
        isBiometricEnabled.value = false;
      }
    } else {
      isBiometricEnabled.value = false;
    }
  }

  bool get isFingerprintSupported {
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> toggleBiometric(bool value) async {
    if (value) {
      try {
        bool isBiometric = await _localAuthentication.canCheckBiometrics;
        if (isBiometric) {
          bool isAuthenticated = await _localAuthentication.authenticate(
            localizedReason: 'Please authenticate to enable fingerprint login',
            options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true,
            ),
          );

          if (isAuthenticated) {
            isBiometricEnabled.value = true;
          } else {
            Toaster.showToast('Authentication failed. Please try again.');
            isBiometricEnabled.value = false;
          }
        }
      } catch (e) {
        Debug.log(e.toString());
        Toaster.showToast('Authentication failed. Please try again.');
        isBiometricEnabled.value = false;
      }
    } else {
      isBiometricEnabled.value = false;
    }

    saveFingerprintState(isBiometricEnabled.value);
  }

  Future<void> saveFingerprintState(bool isEnabled) async {
    await Get.find<Preferences>().setBool(Keys.fingerPrint, isEnabled);
  }

  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }
}
