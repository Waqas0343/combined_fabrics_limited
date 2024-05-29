import 'package:combined_fabrics_limited/app/services/preferences.dart';
import 'package:combined_fabrics_limited/app_assets/styles/my_colors.dart';
import 'package:combined_fabrics_limited/app_assets/styles/strings/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/my_images.dart';
import '../../routes/app_routes.dart';
import '../../screens/home/home_controller.dart';
import '../confirmation_alert.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyColors.primaryColor,
            ),
            padding: const EdgeInsets.only(
              bottom: 16,
              top: 6,
              right: 8,
              left: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 0,
                  child: Image.asset(
                    MyImages.logoWhite,
                    height: 40,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          // Replace with your desired icon color
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(right: 16),
                          height: 65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                controller.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: MyColors.shimmerHighlightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                controller.employeeCode,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.titleSmall?.copyWith(
                                  color: MyColors.shimmerHighlightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle home navigation
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.fingerprint,
              size: 30,
            ),
            title: const Text('Enable fingerprint'),
            trailing: controller.isFingerprintSupported
                ? Obx(
                  () => Switch(
                value: controller.isBiometricEnabled.value,
                onChanged: controller.toggleBiometric,
              ),
            )
                : null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings navigation
            },
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text('Logout'),
            onTap: () => ConfirmationAlert.showDialog(
              title:"Logout Confirmation",
              description:"Are you sure you want to log out of this app?",
              onConfirm: () {
                bool isEnabled = Get.find<Preferences>().getBool(Keys.fingerPrint) ?? false;

                if (!isEnabled) {
                  Get.find<Preferences>().logout();
                }
                Get.offAllNamed(AppRoutes.loginWithFingerPrint);
              },
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
