import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../app_widgets/confirmation_alert.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import '../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';

class KeysDashBoard extends StatelessWidget {
  const KeysDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keys Issuance DashBoard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            onPressed: () => ConfirmationAlert.showDialog(
              title: "Logout Confirmation",
              description: "Are you sure you want to log out of this app?",
              onConfirm: () {
                Get.find<Preferences>().logout();
              },
            ),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double deviceWidth = constraints.maxWidth;
        double imageHeight = 220.0;
        if (deviceWidth > 600) {
          imageHeight = 400.0;
        }
        return ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Container(
              width: deviceWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/key.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: "Current ",
                style: Get.textTheme.titleSmall,
                children: [
                  TextSpan(
                    text: "Login ",
                    style: Get.textTheme.titleSmall,
                  ),
                  TextSpan(
                    text: employeeName,
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.keysIssuanceHome);
                    },
                    child: const ComplaintPortalCard(
                      icon: Icon(
                        Icons.vpn_key_sharp,
                        color: Colors.green,
                      ),
                      color: Color(0xFF50C9C3),
                      titleText: '',
                      subTitleText: "Daily Keys Issuance",
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.keysManagementScreen);
                    },
                    child: const ComplaintPortalCard(
                      icon: Icon(
                        Icons.create,
                        color: Colors.orange,
                      ),
                      color: Color(0xFF50C9C3),
                      titleText: '',
                      subTitleText: "Create Key Profile",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.viewKeyReports),
              child: const ComplaintPortalCard(
                icon: Icon(
                  Icons.key_outlined,
                  color: Colors.red,
                ),
                color: Color(0xFF6C63FF),
                titleText: '',
                subTitleText: "View Key Reports",
              ),
            ),
          ],
        );
      }),
    );
  }
}
