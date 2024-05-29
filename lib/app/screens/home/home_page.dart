import 'package:combined_fabrics_limited/app_assets/styles/my_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/spacing.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../app_widgets/app_drawer/app_drawer.dart';
import '../../app_widgets/confirmation_alert.dart';
import '../../app_widgets/home/home_card.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import 'banners.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer:  const AppDrawer(),
        endDrawerEnableOpenDragGesture: false,
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          key: controller.drawerKey,
          titleSpacing: 0,
          elevation: 0,
          centerTitle: false,
          title: Align(
            alignment: Alignment.center,
            child: Image.asset(
              MyImages.logo,
              height: 40.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () => ConfirmationAlert.showDialog(
                title: "Logout Confirmation",
                description: "Are you sure you want to log out of this app?",
                onConfirm: () {
                  bool isEnabled =
                      Get.find<Preferences>().getBool(Keys.fingerPrint) ??
                          false;

                  if (!isEnabled) {
                    Get.find<Preferences>().logout();
                  }
                  Get.offAllNamed(AppRoutes.loginWithFingerPrint);
                },
              ),
            ),
          ],
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(10),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 12,
                left: 14,
                right: 14,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Appbar and Search field

              const Banners(),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    text: "${controller.greeting} ",
                    style: Get.textTheme.titleSmall,
                    children: [
                      TextSpan(
                        text: "Dear ",
                        style: Get.textTheme.titleSmall,
                      ),
                      TextSpan(
                        text: controller.employeeName,
                        style: Get.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.userMenuList.isNotEmpty) {
                  return const HomeCard();
                } else if (controller.userMenuList.isNotEmpty &&
                    controller.isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox.shrink();
              }),

              const Divider(
                thickness: 5,
              ),
              widgetSpacerVertically(),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 34,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'VERSION V.',
                          style: Get.textTheme.bodySmall,
                        ),
                        Text(
                          Keys.versionNo,
                          style: Get.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12,),
                        Text(
                          'Date: ',
                          style: Get.textTheme.bodySmall,
                        ),
                        Text('25/05/2024',
                          style: Get.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      "Copyrights Ⓒ Combined Fabrics (Private) Limited.\n"
                      "Combined Fabrics Head Office, Lahore, Pakistan\n"
                      "All rights are reserved.\n",
                      style: Get.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
