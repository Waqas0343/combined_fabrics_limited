import 'dart:io';
import 'package:combined_fabrics_limited/app/debug/debug_pointer.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../../helpers/toaster.dart';
import '../../routes/app_routes.dart';
import '../../server/api_fetch.dart';
import '../../services/preferences.dart';
import 'mobile_app_version_model.dart';

class SplashController extends GetxController {
  final RxList<MobileVersionListModel> versionList =
      RxList<MobileVersionListModel>();
  final RxBool connectivityError = RxBool(false);
  final RxBool buttonAction = RxBool(true);
  final RxBool isLoading = RxBool(true);


  @override
  void onInit() {
    bool status = Get.find<Preferences>().getBool(Keys.status) ?? false;
    super.onInit();
    if (status && Platform.isAndroid) {
      getMobileVersion();
    } else {
      checkLogin();
    }
  }

  Future<void> checkLogin() async {
    connectivityError(false);
    bool status = Get.find<Preferences>().getBool(Keys.status) ?? false;
    bool isFirstTime = Get.find<Preferences>().getBool(Keys.isFirstTime) ?? true;
    await 3.0.delay();
    if (status) {
      Get.offNamed(AppRoutes.home);
    } else {
      if (isFirstTime) {
        Get.offNamed(AppRoutes.introduction);
      } else {
        Get.offNamed(AppRoutes.login);
      }
    }
  }

  Future<void> saveNewMobileVersion() async {
    buttonAction(false);
    Map<String, dynamic> payload = {
      "REMARKS": 'OK',
      "MbApp_version": Keys.versionNo,
    };
    Map<String, dynamic>? response =
        await ApiFetch.saveRowingQualityDetail(payload);
    isLoading.value = false;
    buttonAction(true);
    if (response != null && response["Status"] == true) {
      Toaster.showToast("Information Save Successfully!.");
      var returnData = response["ReturnData"];
    } else {
      Toaster.showToast("Information Not Saved");
    }
  }

  Future<void> getMobileVersion() async {
    isLoading(true);
    List<MobileVersionListModel>? responseList = await ApiFetch.getMobileAppVersionList();
    isLoading(false);
    if (responseList != null) {
      versionList.assignAll(responseList);
      compareVersions();
    }
  }

  void compareVersions() {
    if (Platform.isAndroid) {
      String currentVersion = Keys.versionNo;
      if (versionList.isNotEmpty) {
        String latestVersion = versionList.first.publishVersion;
        Debug.log("------------------- Current Version------------------------ $currentVersion-----------------------------------");
        Debug.log("------------------- Mobile Publish ------------------------ $latestVersion-----------------------------------");
        if (currentVersion != latestVersion) {
          showUpdateDialog();
        } else {
          checkLogin();
        }
      }
    }
  }

  void showUpdateDialog() {
    Get.defaultDialog(
      title: "Update Application",
      middleText: "Do you want to update your application with latest feature?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () {
        _launchUrl();
      },
      onCancel: () {
        Get.back();
        checkLogin();
      },
    );
  }
  Future<void> _launchUrl() async {
    String url = 'http://172.16.0.4/Pages/LoadApppFile.aspx';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

}
