import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_assets/styles/strings/app_constants.dart';
import '../../app_widgets/confirmation_alert.dart';
import '../../routes/app_routes.dart';
import '../../services/preferences.dart';
import '../complaint_portal/complain_widget/complain_portal_dashboard_card.dart';

class MedicineDashboardScreen extends StatelessWidget {
  const MedicineDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String employeeName = Get.find<Preferences>().getString(Keys.userId) ?? "";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Issuance DashBoard"),
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
      body: LayoutBuilder(
          builder: (context, constraints) {
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
                    10), // Half of width/height to create a circular shape
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/medicine.png',
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
                      Get.toNamed(AppRoutes.medicalIssuance);
                    },
                    child: const ComplaintPortalCard(
                      icon: Icon(
                        Icons.medical_information,
                        color: Colors.green,
                      ),
                      color: Color(0xFF50C9C3),
                      titleText: '',
                      subTitleText: "Medicine Issuance",
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(AppRoutes.checkMedicineIssueScreen);
                    },
                    child: const ComplaintPortalCard(
                      icon: Icon(
                        Icons.history_edu_outlined,
                        color: Colors.orange,
                      ),
                      color: Color(0xFF50C9C3),
                      titleText: '',
                      subTitleText: "Check All Records",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.checkMedicineStock),
                    child: const ComplaintPortalCard(
                      icon: Icon(Icons.create_outlined),
                      color: Color(0xFF6C63FF),
                      titleText: '',
                      subTitleText: "View Medicine Stock",
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.firstAidBoxIssuance),
                    child: const ComplaintPortalCard(
                      icon: Icon(Icons.medical_services_outlined),
                      color: Color(0xFF6C63FF),
                      titleText: '',
                      subTitleText: "First Aid Boxes Record",
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
